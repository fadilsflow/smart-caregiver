# Smart Caregiver

## Repository Structure
- **Server**: FastAPI backend — `server/`
- **Mobile**: Flutter application — `mobile/`

## Server — Key Commands

Run from `server/`:

| Action | Command |
|--------|---------|
| Install deps | `pip install -r requirements.txt` |
| Run dev server | `uvicorn src.main:app --reload` |
| Run all tests | `pytest` |
| Seed dev data | `python -m src.database.seed` |
| DB migrations | `alembic upgrade head` |
| Auto-generate migration | `alembic revision --autogenerate -m "msg"` |

Test quirks: `asyncio_mode = auto`, fixture `loop_scope = module` (set in `pyproject.toml`). Two test configs exist — `conftest.py` uses real DB, `tests/__init__.py` uses SQLite in-memory.

## Server — Architecture

**Entrypoint**: `server/src/main.py` — mounts 9 routers:

| Router | Prefix | Description |
|--------|--------|-------------|
| auth | `/auth` | Register, login, refresh, me |
| auth_google | `/auth/google` | Google OAuth login |
| elderly | `/elderly` | CRUD elderly profiles |
| health | `/health/records`, `/elderly/{id}/health/*` | Health records + fuzzy analysis |
| dashboard | `/dashboard` | Overview + health trends |
| notification | `/notifications` | List, read, preferences |
| schedule | `/elderly/{id}/schedules` | CRUD schedules + alarm reminders |
| recommendation | `/elderly/{id}/recommendations` | AI activity recommendations |
| internal_jobs | `/internal/jobs` | Weekly summary, alarm dispatch |

**Auth model**: Only **caregiver** role exists (viewer was removed). All data access gated by `require_caregiver_owner` (403 if not owner). `require_elderly_access` behaves identically (kept for read-operation semantics). JWT required for all endpoints except `POST /auth/register`, `POST /auth/login`, `POST /auth/refresh`, and Google OAuth endpoints.

**Key side effects** (triggers):
- Create health record → auto fuzzy analysis + `HEALTH_RECORDED` notification (or `CRITICAL_ALERT` if threshold exceeded)
- Approve recommendation with `scheduled_at` → auto-create `Schedule` with `source="ai_approved"`
- Create schedule with `reminder_minutes` → auto-create `ScheduleAlarm` rows
- `POST /internal/jobs/dispatch-due-alarms` → creates `ALARM_REMINDER` notifications
- `POST /internal/jobs/send-weekly-summary` → creates `WEEKLY_SUMMARY` notifications

**Fuzzy logic**: 3 modules (cardiovascular, metabolic, infection) run on health record creation via thread-pool executor. Scores stored per-record.

**AI recommendation**: Calls Groq LLM (`qwen/qwen3-32b`) with elderly profile data. Falls back to line-parsing if JSON extraction fails. Requires `GROQ_API_KEY`.

## Server — Environment

Required in `server/.env` (see `.env.example`):

| Variable | Notes |
|----------|-------|
| `DATABASE_URL` | PostgreSQL via asyncpg (Neon) |
| `SECRET_KEY` | JWT signing key |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | Default 30 |
| `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` | Google OAuth |
| `GROQ_API_KEY` | LLM for recommendations |
| `INTERNAL_API_KEY` | Auth for `/internal/jobs/*` endpoints |

## Docs

- [PRD](docs/prd.md) — product requirements
- [BDD Scenarios](docs/bdd.md) — behavior scenarios
- [Server Implementation Plan](docs/server_plan.md)
- [Server README](server/README.md)
- [Mobile README](mobile/README.md)

## Available Skills

- `.agents/skills/fastapi-expert/` — FastAPI patterns for backend work
- `.agents/skills/getx-state-management-patterns/` — GetX for Flutter
- `.agents/skills/advanced-getx-patterns/` — Advanced GetX patterns
