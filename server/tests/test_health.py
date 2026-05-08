import uuid

import pytest
import pytest_asyncio
from sqlalchemy import select

from src.app.services.health_service import (
    _check_thresholds,
    _max_priority_status,
    create_health_record,
)
from src.app.schemas.health import HealthRecordCreate
from src.database.enums import HealthParameter, HealthStatus, NotificationPriority, NotificationType
from src.database.models.elderly import ElderlyProfile
from src.database.models.health import HealthRecord, HealthThreshold
from src.database.models.notification import Notification
from src.database.models.user import User
async def _make_elderly(db_session) -> tuple[User, ElderlyProfile]:
    uid = uuid.uuid4()
    user = User(
        id=uid,
        email=f"caregiver_{uid.hex[:8]}@test.com",
        hashed_password="dummy",
        full_name="Test",
        is_active=True,
    )
    db_session.add(user)
    elderly = ElderlyProfile(
        id=uuid.uuid4(),
        caregiver_id=user.id,
        full_name="Test Elderly",
        age=70,
        gender="male",
        mobility_level="assisted",
    )
    db_session.add(elderly)
    await db_session.flush()
    return user, elderly


class TestMaxPriority:
    def test_critical_wins_over_all(self):
        assert _max_priority_status(HealthStatus.NORMAL, HealthStatus.CRITICAL) == HealthStatus.CRITICAL
        assert _max_priority_status(HealthStatus.WARNING, HealthStatus.CRITICAL) == HealthStatus.CRITICAL
        assert _max_priority_status(HealthStatus.NEEDS_ATTENTION, HealthStatus.CRITICAL) == HealthStatus.CRITICAL

    def test_needs_attention_beats_warning(self):
        assert _max_priority_status(HealthStatus.WARNING, HealthStatus.NEEDS_ATTENTION) == HealthStatus.NEEDS_ATTENTION

    def test_normal_lowest(self):
        assert _max_priority_status(HealthStatus.NORMAL, HealthStatus.WARNING) == HealthStatus.WARNING


class TestCheckThresholds:
    @pytest.mark.asyncio
    async def test_no_thresholds_defined(self, db_session):
        _, elderly = await _make_elderly(db_session)
        record = HealthRecord(
            elderly_id=elderly.id,
            systolic_bp=150,
            diastolic_bp=95,
        )
        triggered = await _check_thresholds(db_session, record)
        assert triggered == []

    @pytest.mark.asyncio
    async def test_all_parameters_within_range(self, db_session):
        _, elderly = await _make_elderly(db_session)
        thresholds = [
            HealthThreshold(elderly_id=elderly.id, parameter=HealthParameter.SYSTOLIC_BP, min_value=90, max_value=140),
            HealthThreshold(elderly_id=elderly.id, parameter=HealthParameter.DIASTOLIC_BP, min_value=60, max_value=90),
            HealthThreshold(elderly_id=elderly.id, parameter=HealthParameter.BLOOD_SUGAR, min_value=70, max_value=180),
            HealthThreshold(elderly_id=elderly.id, parameter=HealthParameter.HEART_RATE, min_value=60, max_value=100),
            HealthThreshold(elderly_id=elderly.id, parameter=HealthParameter.BODY_TEMPERATURE, min_value=36.0, max_value=37.5),
        ]
        for t in thresholds:
            db_session.add(t)
        await db_session.flush()

        record = HealthRecord(
            elderly_id=elderly.id,
            systolic_bp=120,
            diastolic_bp=80,
            blood_sugar=100,
            heart_rate=75,
            body_temperature=36.5,
        )
        triggered = await _check_thresholds(db_session, record)
        assert triggered == []

    @pytest.mark.asyncio
    async def test_systolic_bp_exceeds_max(self, db_session):
        _, elderly = await _make_elderly(db_session)
        t = HealthThreshold(elderly_id=elderly.id, parameter=HealthParameter.SYSTOLIC_BP, min_value=90, max_value=140)
        db_session.add(t)
        await db_session.flush()

        record = HealthRecord(
            elderly_id=elderly.id,
            systolic_bp=180,
            diastolic_bp=80,
        )
        triggered = await _check_thresholds(db_session, record)
        assert len(triggered) == 1
        assert triggered[0]["parameter"] == "systolic_bp"
        assert triggered[0]["value"] == 180

    @pytest.mark.asyncio
    async def test_multiple_params_exceed(self, db_session):
        _, elderly = await _make_elderly(db_session)
        params_data = [
            (HealthParameter.SYSTOLIC_BP, 90, 140),
            (HealthParameter.DIASTOLIC_BP, 60, 90),
            (HealthParameter.BLOOD_SUGAR, 70, 180),
            (HealthParameter.HEART_RATE, 60, 100),
            (HealthParameter.BODY_TEMPERATURE, 36.0, 37.5),
        ]
        for param, mn, mx in params_data:
            db_session.add(HealthThreshold(elderly_id=elderly.id, parameter=param, min_value=mn, max_value=mx))
        await db_session.flush()

        record = HealthRecord(
            elderly_id=elderly.id,
            systolic_bp=180,
            diastolic_bp=110,
            blood_sugar=300,
            heart_rate=120,
            body_temperature=39.5,
        )
        triggered = await _check_thresholds(db_session, record)
        params = {t["parameter"] for t in triggered}
        assert params == {"systolic_bp", "diastolic_bp", "blood_sugar", "heart_rate", "body_temperature"}

    @pytest.mark.asyncio
    async def test_value_below_min(self, db_session):
        _, elderly = await _make_elderly(db_session)
        params_data = [
            (HealthParameter.SYSTOLIC_BP, 90, 140),
            (HealthParameter.HEART_RATE, 60, 100),
        ]
        for param, mn, mx in params_data:
            db_session.add(HealthThreshold(elderly_id=elderly.id, parameter=param, min_value=mn, max_value=mx))
        await db_session.flush()

        record = HealthRecord(
            elderly_id=elderly.id,
            systolic_bp=85,
            heart_rate=50,
        )
        triggered = await _check_thresholds(db_session, record)
        params = {t["parameter"] for t in triggered}
        assert params == {"systolic_bp", "heart_rate"}


class TestCreateHealthRecordThreshold:
    @pytest.mark.asyncio
    async def test_create_record_triggers_notification_with_threshold_params(
        self, db_session
    ):
        caregiver, elderly = await _make_elderly(db_session)
        params_data = [
            (HealthParameter.SYSTOLIC_BP, 90, 140),
            (HealthParameter.DIASTOLIC_BP, 60, 90),
            (HealthParameter.BLOOD_SUGAR, 70, 180),
        ]
        for param, mn, mx in params_data:
            db_session.add(HealthThreshold(elderly_id=elderly.id, parameter=param, min_value=mn, max_value=mx))
        await db_session.flush()

        payload = HealthRecordCreate(
            elderly_id=elderly.id,
            systolic_bp=180,
            diastolic_bp=110,
            blood_sugar=100,
        )
        response = await create_health_record(
            db=db_session,
            payload=payload,
            recorded_by=caregiver.id,
        )

        assert response.health_status in (
            HealthStatus.NEEDS_ATTENTION.value,
            HealthStatus.CRITICAL.value,
        )

        notif_stmt = select(Notification).where(
            Notification.elderly_id == elderly.id
        )
        notif_result = await db_session.execute(notif_stmt)
        notifications = notif_result.scalars().all()
        assert len(notifications) >= 1

        critical_notifs = [n for n in notifications if n.notification_type == NotificationType.CRITICAL_ALERT]
        assert len(critical_notifs) >= 1

        payload_data = critical_notifs[0].payload
        assert payload_data is not None
        assert "triggered_parameters" in payload_data
        params = {p["parameter"] for p in payload_data["triggered_parameters"]}
        assert "systolic_bp" in params
        assert "diastolic_bp" in params

    @pytest.mark.asyncio
    async def test_normal_record_no_threshold_trigger(
        self, db_session
    ):
        caregiver, elderly = await _make_elderly(db_session)
        params_data = [
            (HealthParameter.SYSTOLIC_BP, 90, 140),
            (HealthParameter.DIASTOLIC_BP, 60, 90),
            (HealthParameter.BLOOD_SUGAR, 70, 180),
            (HealthParameter.HEART_RATE, 60, 100),
        ]
        for param, mn, mx in params_data:
            db_session.add(HealthThreshold(elderly_id=elderly.id, parameter=param, min_value=mn, max_value=mx))
        await db_session.flush()

        payload = HealthRecordCreate(
            elderly_id=elderly.id,
            systolic_bp=120,
            diastolic_bp=80,
            blood_sugar=100,
            heart_rate=75,
        )
        await create_health_record(
            db=db_session,
            payload=payload,
            recorded_by=caregiver.id,
        )

        notif_stmt = select(Notification).where(
            Notification.elderly_id == elderly.id
        )
        notif_result = await db_session.execute(notif_stmt)
        notifications = notif_result.scalars().all()
        health_recorded = [n for n in notifications if n.notification_type == NotificationType.HEALTH_RECORDED]
        assert len(health_recorded) >= 1
        payload_data = health_recorded[0].payload
        assert payload_data is not None
        assert "triggered_parameters" not in payload_data


class TestNotificationPriority:
    @pytest.mark.asyncio
    async def test_critical_alert_has_high_priority(
        self, db_session
    ):
        caregiver, elderly = await _make_elderly(db_session)
        t = HealthThreshold(elderly_id=elderly.id, parameter=HealthParameter.SYSTOLIC_BP, min_value=90, max_value=140)
        db_session.add(t)
        await db_session.flush()

        payload = HealthRecordCreate(
            elderly_id=elderly.id,
            systolic_bp=200,
        )
        await create_health_record(
            db=db_session,
            payload=payload,
            recorded_by=caregiver.id,
        )

        notif_stmt = select(Notification).where(
            Notification.elderly_id == elderly.id
        )
        notif_result = await db_session.execute(notif_stmt)
        notifications = notif_result.scalars().all()

        for n in notifications:
            if n.notification_type == NotificationType.CRITICAL_ALERT:
                assert n.priority == NotificationPriority.HIGH

    @pytest.mark.asyncio
    async def test_normal_record_has_normal_priority(
        self, db_session
    ):
        caregiver, elderly = await _make_elderly(db_session)
        params_data = [
            (HealthParameter.SYSTOLIC_BP, 90, 140),
            (HealthParameter.HEART_RATE, 60, 100),
        ]
        for param, mn, mx in params_data:
            db_session.add(HealthThreshold(elderly_id=elderly.id, parameter=param, min_value=mn, max_value=mx))
        await db_session.flush()

        payload = HealthRecordCreate(
            elderly_id=elderly.id,
            systolic_bp=120,
            heart_rate=75,
        )
        await create_health_record(
            db=db_session,
            payload=payload,
            recorded_by=caregiver.id,
        )

        notif_stmt = select(Notification).where(
            Notification.elderly_id == elderly.id
        )
        notif_result = await db_session.execute(notif_stmt)
        notifications = notif_result.scalars().all()

        for n in notifications:
            assert n.priority == NotificationPriority.NORMAL
