// HTTP-приложение Node.js для стенда OTUS.
"use strict";

const { createServer } = require("node:http");

createServer((request, response) => {
  if (request.url !== "/") {
    response.writeHead(404);
    response.end("Not found");
    return;
  }

  const now = new Date().toISOString();
  response.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  response.end(
    '<!doctype html><html lang="ru"><meta charset="utf-8">' +
      "<title>OTUS Node.js</title><h1>OTUS Node.js</h1>" +
      `<p>Страница сгенерирована Node.js. Время UTC: ${now}</p></html>`,
  );
}).listen(3000, "0.0.0.0");

// Версия 1 · 2026-11-11 · Динамическая страница Node.js.
