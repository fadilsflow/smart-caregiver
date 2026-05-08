"""
Logging configuration using structlog.
Provides structured JSON logging with correlation ID support.
"""

import logging
import time
import uuid

import structlog
from structlog.processors import JSONRenderer, TimeStamper
from structlog.types import Processor

from fastapi import Request, Response
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.types import ASGIApp


def setup_logging(debug: bool = False) -> None:
    """Configure structlog with structured JSON output.

    Args:
        debug: If True, use console-friendly format instead of JSON.
    """
    logging.basicConfig(
        format="%(message)s",
        level=logging.DEBUG if debug else logging.INFO,
    )

    processors: list[Processor] = [
        structlog.contextvars.merge_contextvars,
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        TimeStamper(fmt="iso"),
        structlog.dev.ConsoleRenderer()
        if debug
        else JSONRenderer(),
    ]

    structlog.configure(
        processors=processors,
        wrapper_class=structlog.stdlib.BoundLogger,
        context_class=dict,
        logger_factory=structlog.stdlib.LoggerFactory(),
        cache_logger_on_first_use=True,
    )


def get_logger() -> structlog.stdlib.BoundLogger:
    """Get a structured logger instance."""
    return structlog.get_logger()


class RequestLoggingMiddleware(BaseHTTPMiddleware):
    """Log every request with method, path, status, duration, and correlation ID."""

    def __init__(self, app: ASGIApp):
        super().__init__(app)

    async def dispatch(self, request: Request, call_next) -> Response:
        correlation_id = request.headers.get("X-Request-ID", str(uuid.uuid4()))
        structlog.contextvars.clear_contextvars()
        structlog.contextvars.bind_contextvars(correlation_id=correlation_id)

        logger = get_logger()
        start = time.time()
        method = request.method
        path = request.url.path

        logger.info("request_started", method=method, path=path)

        try:
            response = await call_next(request)
            response.headers["X-Request-ID"] = correlation_id
        except Exception as exc:
            duration_ms = round((time.time() - start) * 1000, 2)
            logger.error(
                "request_failed",
                method=method,
                path=path,
                duration_ms=duration_ms,
                error=str(exc),
            )
            raise

        duration_ms = round((time.time() - start) * 1000, 2)
        logger.info(
            "request_completed",
            method=method,
            path=path,
            status=response.status_code,
            duration_ms=duration_ms,
        )

        return response
