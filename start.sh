DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${POSTGRES_DB:-testdb}"
DB_USER="${POSTGRES_USER:-postgres}"
DB_PASS="${POSTGRES_PASSWORD:-root}"

echo "等一等..."
sleep 5

# Flyway migrate
flyway \
  -url="jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME" \
  -user="$DB_USER" \
  -password="$DB_PASS" \
  -locations="filesystem:/app/migration" \
  migrate

# 最後啟動 Flask
echo "Flask 啟動!"
python app.py
