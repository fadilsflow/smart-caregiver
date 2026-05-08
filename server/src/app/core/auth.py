"""
JWT Authentication Dependencies and Access Control Helpers.

This module provides:
- get_current_user: JWT bearer token dependency
- Access level helpers for caregiver owner
"""

from enum import Enum
from typing import Optional

import uuid
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.app.core.config import settings
from src.app.core.security import decode_token
from src.database.models.elderly import ElderlyProfile
from src.database.models.user import User
from src.database.session import get_db

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


class AccessLevel(str, Enum):
    """Access level for elderly data."""

    CAREGIVER_OWNER = "caregiver_owner"
    NONE = "none"


async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: AsyncSession = Depends(get_db),
) -> User:
    """
    Extract and validate user from JWT token.
    
    Raises 401 if token is invalid or user not found.
    """
    payload = decode_token(token)
    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    if payload.get("type") != "access":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token type",
            headers={"WWW-Authenticate": "Bearer"},
        )

    user_id = payload.get("sub")
    if user_id is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token payload",
            headers={"WWW-Authenticate": "Bearer"},
        )

    try:
        user_uuid = uuid.UUID(user_id)
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid user ID in token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    stmt = select(User).where(User.id == user_uuid)
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()

    if user is None or not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found or inactive",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return user


async def get_current_user_optional(
    token: Optional[str] = Depends(OAuth2PasswordBearer(tokenUrl="/auth/login", auto_error=False)),
    db: AsyncSession = Depends(get_db),
) -> Optional[User]:
    """Optional current user - returns None if no valid token."""
    if token is None:
        return None
    
    try:
        return await get_current_user(token, db)
    except HTTPException:
        return None


async def check_elderly_access(
    elderly_id: uuid.UUID,
    user: User,
    db: AsyncSession,
) -> AccessLevel:
    """
    Check what access level a user has to an elderly profile.
    
    Returns:
    - CAREGIVER_OWNER: user is the caregiver who owns this elderly profile
    - NONE: no access
    """
    stmt = select(ElderlyProfile).where(ElderlyProfile.id == elderly_id)
    result = await db.execute(stmt)
    elderly = result.scalar_one_or_none()

    if elderly is None:
        return AccessLevel.NONE

    if elderly.caregiver_id == user.id:
        return AccessLevel.CAREGIVER_OWNER

    return AccessLevel.NONE


async def require_caregiver_owner(
    elderly_id: uuid.UUID,
    user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> tuple[uuid.UUID, User]:
    """
    Dependency that ensures the current user is the caregiver owner of the elderly profile.
    
    Raises 403 if user is not the caregiver owner.
    Raises 404 if elderly profile not found.
    """
    access_level = await check_elderly_access(elderly_id, user, db)
    
    if access_level != AccessLevel.CAREGIVER_OWNER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You must be the caregiver owner to access this resource.",
        )
    
    return elderly_id, user


async def require_elderly_access(
    elderly_id: uuid.UUID,
    user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> tuple[uuid.UUID, User, AccessLevel]:
    """
    Dependency that ensures the current user has access to the elderly profile.
    
    Only the caregiver owner can access elderly data.
    Raises 403 if no access.
    """
    stmt = select(ElderlyProfile).where(ElderlyProfile.id == elderly_id)
    result = await db.execute(stmt)
    elderly = result.scalar_one_or_none()

    if elderly is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Elderly profile {elderly_id} not found.",
        )

    access_level = await check_elderly_access(elderly_id, user, db)
    
    if access_level == AccessLevel.NONE:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You don't have access to this elderly profile.",
        )
    
    return elderly_id, user, access_level
