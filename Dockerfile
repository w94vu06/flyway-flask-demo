FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    postgresql-client wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget -O flyway.tar.gz "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/9.14.1/flyway-commandline-9.14.1-linux-x64.tar.gz" \
    && tar -zxvf flyway.tar.gz -C /opt \
    && rm flyway.tar.gz
ENV FLYWAY_HOME=/opt/flyway-9.14.1
ENV PATH="$PATH:$FLYWAY_HOME"

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app

EXPOSE 5000

CMD ["bash", "start.sh"]
