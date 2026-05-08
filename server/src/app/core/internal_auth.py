"""
Authentication for internal job endpoints using API key header.
"""

from fastapi import HTTPException, Request, status

from src.app.core.config import settings


async def verify_internal_api_key(request: Request) -> None:
    """Verify X-API-Key header matches configured key.

    If INTERNAL_API_KEY is empty (dev default), skip auth.
    """
    api_key = settings.INTERNAL_API_KEY
    if not api_key:
        return

    provided = request.headers.get("X-API-Key")
    if not provided or provided != api_key:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Invalid or missing API key",
        )
