FROM python:3.9-slim

# ---------------------------------------------------
# 1) 安裝系統套件: postgresql-client + wget
# ---------------------------------------------------
RUN apt-get update && apt-get install -y \
    postgresql-client wget && \
    rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------
# 2) 安裝 Flyway CLI
#   以 9.14.1 為例，版本可調整
# ---------------------------------------------------
WORKDIR /tmp
RUN wget -O flyway.tar.gz "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/9.14.1/flyway-commandline-9.14.1-linux-x64.tar.gz" \
    && tar -zxvf flyway.tar.gz -C /opt \
    && rm flyway.tar.gz
ENV FLYWAY_HOME=/opt/flyway-9.14.1
ENV PATH="$PATH:$FLYWAY_HOME"

# ---------------------------------------------------
# 3) 複製 Flask 專案 & 安裝 Python 套件
# ---------------------------------------------------
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app

# ---------------------------------------------------
# 4) 開放 Flask port
# ---------------------------------------------------
EXPOSE 5000

# ---------------------------------------------------
# 5) 容器啟動時執行 start.sh
# ---------------------------------------------------
CMD ["bash", "start.sh"]
