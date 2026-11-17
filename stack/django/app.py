"""WSGI-приложение Django с динамической страницей для стенда OTUS."""

import os
from datetime import datetime, timezone

from django.conf import settings
from django.core.wsgi import get_wsgi_application
from django.http import HttpRequest, HttpResponse
from django.urls import path

settings.configure(
    SECRET_KEY=os.environ["DJANGO_SECRET_KEY"],
    DEBUG=False,
    ALLOWED_HOSTS=["127.0.0.1", "localhost"],
    ROOT_URLCONF=__name__,
    MIDDLEWARE=["django.middleware.security.SecurityMiddleware"],
)


def index(_request: HttpRequest) -> HttpResponse:
    """Возвращает HTML-страницу со временем обработки запроса в UTC."""
    now = datetime.now(timezone.utc).isoformat(timespec="seconds")
    return HttpResponse(
        '<!doctype html><html lang="ru"><meta charset="utf-8">'
        "<title>OTUS Django</title><h1>OTUS Django</h1>"
        f"<p>Страница сгенерирована Django. Время UTC: {now}</p></html>"
    )


urlpatterns = [path("", index)]
application = get_wsgi_application()

# Версия 1 · 2026-11-11 · Динамическая страница Django.
