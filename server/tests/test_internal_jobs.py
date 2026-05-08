"""
Tests for internal jobs authentication.
"""

import pytest
from httpx import AsyncClient, ASGITransport

from src.main import app


@pytest.mark.asyncio
async def test_internal_jobs_without_api_key_returns_403():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        response = await client.post("/internal/jobs/send-weekly-summary")
        assert response.status_code == 403
        data = response.json()
        assert "Invalid or missing API key" in data["detail"]


@pytest.mark.asyncio
async def test_internal_jobs_with_wrong_api_key_returns_403():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        response = await client.post(
            "/internal/jobs/send-weekly-summary",
            headers={"X-API-Key": "wrong-key"},
        )
        assert response.status_code == 403


@pytest.mark.asyncio
async def test_internal_jobs_with_valid_api_key():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        response = await client.post(
            "/internal/jobs/send-weekly-summary",
            headers={"X-API-Key": "test-internal-api-key"},
        )
        assert response.status_code in [200, 500]
