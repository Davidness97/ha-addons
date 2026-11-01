#!/bin/bash
set -e

echo "Starting Kinect V2 Motion Watcher..."
echo "Waiting 5 seconds before starting..."
sleep 5

exec /opt/venv/bin/python -u /app/motion.py
