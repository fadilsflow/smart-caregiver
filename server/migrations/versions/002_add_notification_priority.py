"""add_notification_priority

Revision ID: 002_notification_priority
Revises: b3e1ee4b8fd1
Create Date: 2026-05-07

Changes:
  notifications table:
    - ADD priority VARCHAR(10) NOT NULL DEFAULT 'normal'

"""

from __future__ import annotations

import sqlalchemy as sa
from alembic import op

revision = "002_notification_priority"
down_revision = "b3e1ee4b8fd1"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column(
        "notifications",
        sa.Column("priority", sa.String(10), nullable=False, server_default="normal"),
    )


def downgrade() -> None:
    op.drop_column("notifications", "priority")
