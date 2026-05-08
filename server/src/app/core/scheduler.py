"""
APScheduler integration for background jobs.
Runs in-process within the FastAPI application.
"""

import logging

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger

from src.app.services.summary_service import process_all_weekly_summaries
from src.database.session import AsyncSessionLocal

logger = logging.getLogger(__name__)

scheduler = AsyncIOScheduler()


async def send_weekly_summaries_job() -> None:
    """Background job: process weekly summaries for all active elderly profiles."""
    logger.info("Starting weekly summary job")
    async with AsyncSessionLocal() as db:
        try:
            sent_count = await process_all_weekly_summaries(db)
            logger.info(
                "Weekly summary job completed",
                extra={"notifications_sent": sent_count},
            )
        except Exception as exc:
            logger.error("Weekly summary job failed", exc_info=exc)


def start_scheduler() -> None:
    """Start the APScheduler with all registered jobs."""
    trigger = CronTrigger(
        day_of_week="sun", hour=8, minute=0, timezone="Asia/Jakarta"
    )
    scheduler.add_job(
        send_weekly_summaries_job,
        trigger=trigger,
        id="weekly_summary",
        name="Send weekly health summaries",
        replace_existing=True,
        misfire_grace_time=3600,
    )
    scheduler.start()
    logger.info("APScheduler started")


def stop_scheduler() -> None:
    """Shutdown the scheduler gracefully."""
    if scheduler.running:
        scheduler.shutdown(wait=True)
        logger.info("APScheduler stopped")
