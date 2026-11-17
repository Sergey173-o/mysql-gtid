# Собирает Django-приложение и запускает его через Gunicorn.
FROM python:3.12-slim-bookworm

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .

USER 10001:10001
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "--access-logfile", "-", "app:application"]

# Версия 1 · 2026-11-11 · Среда Django и Gunicorn.
