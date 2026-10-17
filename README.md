# Практическая работа №1 — TPC-H Q18

Проект для построения небольшого lakehouse на Iceberg и выполнения варианта 3 (Q18).

## Запуск

1. Запустить Docker Desktop.
2. Из корня проекта выполнить `docker compose up -d --build`.
3. Открыть Trino Web UI: http://localhost:8080; MinIO Console: http://localhost:9001; Lakekeeper UI: http://localhost:8181/ui/.
4. SQL для загрузки и запроса находится в `sql/`.

Для первого запуска выбран `sf1`. Учётные данные в локальном compose предназначены только для учебного запуска. Trino UI доступен на порту 8080; SQL можно выполнять из Trino CLI внутри контейнера командой `docker compose exec trino trino --catalog tpch --schema sf1` или из UI.

## Состав

- MinIO-compatible S3 object store (`pgsty/minio` image) — объектное хранилище Parquet-файлов. В текущем Docker Hub upstream-образ MinIO недоступен; используется совместимый поддерживаемый образ на основе MinIO.
- PostgreSQL — хранилище метаданных Lakekeeper.
- Lakekeeper — Iceberg REST Catalog.
- Trino — SQL-движок и генератор TPC-H.
- Superset — BI-инструмент для подключения к Trino.

При старте в Superset уже создано соединение `Trino Lakehouse` с URI `trino://admin@trino:8080/iceberg/bronze`. Superset доступен на http://localhost:8088; локальный логин `admin` / `admin-local-only`. В **SQL Lab** выбери это соединение и выполни `SELECT count(*) FROM customer;` — проверенный ответ 150000.

## Выполнение запроса и слоёв

Создай схемы и таблицы командами из `sql/layers.sql` при первом запуске. `sql/q18.sql` — исходный запрос по TPC-H; `sql/q18_bronze.sql` выполняет ту же логику по Iceberg Bronze. В Trino Web UI можно смотреть длительность запросов; размеры файлов собраны из Iceberg `$files`.

## Отчёт

Файл отчёта — [`отчет.md`](отчет.md), в корне проекта рядом с этим README. Перед сдачей внеси ФИО ровно как в VK Education и перечитай выводы, чтобы они совпадали с тем, что ты сама поняла и сможешь объяснить.
