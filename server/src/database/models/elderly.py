"""
Elderly profile and access control models
REQ-002: Caregiver creates elderly profile
REQ-003: Multiple profiles per caregiver
"""

import uuid
from datetime import datetime
from typing import Optional

from sqlalchemy import (
    Boolean,
    DateTime,
    ForeignKey,
    Integer,
    String,
    Text,
    func,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from src.database.base import Base
from src.database.enums import ElderlyStatus, MobilityLevel


class ElderlyProfile(Base):
    """
    One row per elderly person. Belongs to exactly one caregiver.
    """

    __tablename__ = "elderly_profiles"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    caregiver_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )

    # ── Identity ──────────────────────────────────────────────────────────────
    full_name: Mapped[str] = mapped_column(String(255), nullable=False)
    age: Mapped[int] = mapped_column(Integer, nullable=False)
    gender: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    photo_url: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)

    # ── Medical background (REQ-002) ──────────────────────────────────────────
    medical_history: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    physical_condition: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    mobility_level: Mapped[MobilityLevel] = mapped_column(
        String(20), nullable=False, default=MobilityLevel.INDEPENDENT
    )
    hobbies_interests: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    allergies: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    emergency_contact_name: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    emergency_contact_phone: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)

    # ── Status ────────────────────────────────────────────────────────────────
    status: Mapped[ElderlyStatus] = mapped_column(
        String(20), nullable=False, default=ElderlyStatus.ACTIVE, index=True
    )

    # ── Timestamps ────────────────────────────────────────────────────────────
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )

    # ── Relationships ─────────────────────────────────────────────────────────
    caregiver: Mapped["User"] = relationship(
        back_populates="elderly_profiles", lazy="select"
    )
    health_records: Mapped[list["HealthRecord"]] = relationship(
        back_populates="elderly",
        cascade="all, delete-orphan",
        lazy="select",
        order_by="HealthRecord.recorded_at.desc()",
    )
    health_thresholds: Mapped[list["HealthThreshold"]] = relationship(
        back_populates="elderly", cascade="all, delete-orphan", lazy="selectin"
    )
    schedules: Mapped[list["Schedule"]] = relationship(
        back_populates="elderly", cascade="all, delete-orphan", lazy="select"
    )
    ai_recommendations: Mapped[list["AIActivityRecommendation"]] = relationship(
        back_populates="elderly", cascade="all, delete-orphan", lazy="select"
    )

    def __repr__(self) -> str:
        return f"<ElderlyProfile id={self.id} name={self.full_name}>"
