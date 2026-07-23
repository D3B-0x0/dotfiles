#!/bin/bash

echo "[1] Stopping and removing all Nextcloud AIO containers..."
docker rm -f $(docker ps -aq --filter name="nextcloud-aio") 2>/dev/null

echo "[2] Removing related Docker volumes..."
docker volume rm $(docker volume ls -q --filter name="nextcloud-aio") 2>/dev/null

echo "[3] Removing Nextcloud AIO Docker network..."
docker network rm nextcloud-aio 2>/dev/null

echo "[4] Removing any leftover docker containers with 'nextcloud' in name..."
docker rm -f $(docker ps -aq --filter name="nextcloud") 2>/dev/null

echo "[5] Removing any leftover docker volumes with 'nextcloud' in name..."
docker volume rm $(docker volume ls -q --filter name="nextcloud") 2>/dev/null

echo "[6] Pruning dangling docker volumes, networks, containers..."
docker system prune --volumes -af

echo "[7] Restarting Docker..."
sudo systemctl daemon-reexec
sudo systemctl restart docker

echo "[8] Optionally delete old mount points (uncomment to use)"
# sudo rm -rf /mnt/ncdata
# sudo rm -rf /mnt/hdd_toshiba/ncdata

echo "✅ Docker and Nextcloud AIO cleaned up completely."

