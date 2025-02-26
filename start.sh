#!/bin/bash

# Flyway 參數
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${POSTGRES_DB:-testdb}"
DB_USER="${POSTGRES_USER:-postgres}"
DB_PASS="${POSTGRES_PASSWORD:-root}"

# 等待 DB 就緒(如果是同 Docker Compose，可以考慮 depends_on + 遞延機制)
echo "Waiting for DB to be ready..."
sleep 5

# Flyway migrate
flyway \
  -url="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME" \
  -user="$DB_USER" \
  -password="$DB_PASS" \
  -locations="filesystem:/app/flyway/sql" \
  migrate

# 最後啟動 Flask
echo "Starting Flask..."
python app.py
