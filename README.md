# Практическая работа №1 — TPC-H Q18

Вариант 3: запрос Q18 из набора TPC-H. В работе используется локальный lakehouse на Iceberg и масштаб данных `sf1`.

## Порядок выполнения

1. Запусти Docker Desktop и дождись, пока он будет готов.
2. Открой терминал в папке проекта.
3. Запусти сервисы командой:

   ```bash
   docker compose up -d --build
   ```

4. Дождись запуска Trino и остальных сервисов. Веб-интерфейсы доступны по адресам:
   - Trino — [http://localhost:8080](http://localhost:8080)
   - MinIO — [http://localhost:9001](http://localhost:9001)
   - Lakekeeper — [http://localhost:8181/ui/](http://localhost:8181/ui/)
   - Superset — [http://localhost:8088](http://localhost:8088)

5. Создай таблицы слоёв Bronze, Silver и Gold. Для этого из корня проекта выполни:

   ```bash
   docker compose exec -T trino trino --catalog iceberg --schema bronze < sql/layers.sql
   ```

   Этот шаг выполняется при первом запуске проекта.

6. Выполни запрос Q18 к исходным таблицам TPC-H:

   ```bash
   docker compose exec -T trino trino --catalog tpch --schema sf1 < sql/q18.sql
   ```

7. Чтобы выполнить тот же запрос к таблицам Iceberg, запусти:

   ```bash
   docker compose exec -T trino trino --catalog iceberg --schema bronze < sql/q18_bronze.sql
   ```

   SQL-файлы также можно открыть и выполнять в Trino Web UI по адресу [http://localhost:8080](http://localhost:8080).

8. Проверь подключение к данным через Superset. Войди по адресу [http://localhost:8088](http://localhost:8088), используя логин `admin` и пароль `admin-local-only`. Открой **SQL Lab**, выбери соединение `Trino Lakehouse` и выполни:

   ```sql
   SELECT count(*) FROM customer;
   ```

   Для масштаба `sf1` запрос должен вернуть `150000`.

9. Когда закончишь работу, останови сервисы командой:

   ```bash
   docker compose down
   ```

## Сервисы

- **MinIO** хранит файлы таблиц Parquet; используется образ `pgsty/minio`.
- **PostgreSQL** хранит метаданные Lakekeeper.
- **Lakekeeper** управляет каталогом таблиц Iceberg.
- **Trino** выполняет SQL-запросы к TPC-H и Iceberg.
- **Superset** подключается к Trino и позволяет просматривать данные через SQL Lab.

## Файлы проекта

- `sql/layers.sql` — создание схем и таблиц Bronze, Silver и Gold, а также копии Bronze со сжатием GZIP.
- `sql/q18.sql` — запрос Q18 к исходным таблицам TPC-H.
- `sql/q18_bronze.sql` — запрос Q18 к таблицам Iceberg Bronze.
- [`отчет.md`](отчет.md) — отчёт по практической работе.
