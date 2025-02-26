from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)

# 從環境變數讀取資料庫連線資訊
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("POSTGRES_DB", "testdb")      # 預設: testdb
DB_USER = os.getenv("POSTGRES_USER", "postgres")  # 預設: postgres
DB_PASS = os.getenv("POSTGRES_PASSWORD", "root")  # 預設: root

@app.route("/")
def hello():
    return "Hello World! This is Flask + Flyway Demo."

@app.route("/users")
def get_users():
    """
    簡單示範: 從資料庫抓取 demo_user 資料
    """
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
        cur = conn.cursor()
        cur.execute("SELECT id, name FROM demo_user;")
        rows = cur.fetchall()
        cur.close()
        conn.close()
        return jsonify([
            {"id": r[0], "name": r[1]}
            for r in rows
        ])
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
