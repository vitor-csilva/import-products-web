#!/bin/sh

export UPLOAD_DIR=uploads

python3 -m src.cron

echo "Path $(UPLOAD_DIR) is cleaned !!"