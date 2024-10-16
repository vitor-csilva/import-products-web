#!/bin/sh

export UPLOAD_DIR=uploads

python3 -m src.cron

if [ "$?" = "0" ]; then
    echo "Path $(UPLOAD_DIR) is cleaned !!"
fi