from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("POSTGRES_DB", "testdb")
DB_USER = os.getenv("POSTGRES_USER", "postgres")
DB_PASS = os.getenv("POSTGRES_PASSWORD", "root")

@app.route("/")
def hello():
    return """
    <html>
    <head>
        <title>加熱符</title>
            <style>
                body {
                    margin: 0;
                    overflow: hidden;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                }
                img {
                    width: 100vw;
                    object-fit: cover;
                }
                button {
                    padding: 10px 20px;
                    font-size: 16px;
                    margin-top: 20px;
                    cursor: pointer; 
                    background-color: #007BFF;
                    color: white;
                    border: none;
                    border-radius: 5px;
                }
                button:hover {
                    background-color: #0056b3;
                }
            </style>
        </head>
    <body>
        <img src="/static/fullscreen.png" alt="">
        <a href="/list"><button type="button">查看中獎名單!!</button></a>
        <a href="/cart"><button type="button">購物車</button></a>
    </body>
    </html>
    """

@app.route("/list")
def get_users():
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
    
@app.route("/cart")
def cart_page():

    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
        cur = conn.cursor()
        
        cur.execute("SELECT id, product_name, quantity FROM cart_items;")
        rows = cur.fetchall()
        cur.close()
        conn.close()

        html_content = """
        <html>
        <head>
            <title>購物車</title>
        </head>
        <body>
            <h1>購物車內容</h1>
            <table border="1" cellpadding="5" cellspacing="0">
                <tr>
                    <th>ID</th>
                    <th>商品名稱</th>
                    <th>數量</th>
                </tr>
        """
        for row in rows:
            html_content += f"<tr><td>{row[0]}</td><td>{row[1]}</td><td>{row[2]}</td></tr>"
        html_content += "</table></body></html>"

        return html_content

    except Exception as e:
        return f"購物車內容讀取失敗: {e}"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
