"""
Error response schemas for consistent error handling.
"""

from typing import Any, Optional

from pydantic import BaseModel


class ErrorResponse(BaseModel):
    detail: str
    error_code: str
    context: Optional[dict[str, Any]] = None
