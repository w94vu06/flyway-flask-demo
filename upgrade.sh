#!/bin/bash

set -e

echo "[1] 切到 release branch 並拉取最新程式碼"
git fetch origin
git checkout release  # 假設正式版分支叫做 release
git pull origin release

echo "[2] 建構/更新 Docker 映像"
docker-compose build prod-web

echo "[3] 重啟線上服務 (prod-db, prod-web)"
docker-compose up -d prod-db prod-web

echo "[完成] 線上升版已完成。"
