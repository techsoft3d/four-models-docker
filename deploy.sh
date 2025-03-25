#!/bin/bash
set -e

echo "🚀 Setting up workspace..."
sudo chown -R $USER:$USER $GITHUB_WORKSPACE

echo "🧹 Deleting previous artifacts..."
sudo rm -rf $GITHUB_WORKSPACE/* || true

echo "📜 Writing hoops_license.txt..."
echo "${HOOPS_LICENSE}" | base64 --decode > hoops_license.txt
ls -l hoops_license.txt
cat hoops_license.txt

echo "🔐 Writing SSL certs..."
mkdir -p certs
echo "${SSL_CERT}" > certs/server.crt
echo "${SSL_KEY}" > certs/server.key
echo "${CA_CERT}" > certs/ca.crt

echo "🔍 Verifying SSL certs..."
if [ ! -s certs/server.crt ] || [ ! -s certs/server.key ]; then
  echo "❌ SSL certs missing!"
  exit 1
fi
ls -la certs/

echo "📦 Logging into GitHub Packages..."
echo "${GHCR_PAT}" | docker login ghcr.io -u "${GITHUB_ACTOR}" --password-stdin

echo "🧹 Pruning Docker images..."
docker image prune -af

echo "⬇️ Pulling latest Docker images..."
docker pull ghcr.io/techsoft3d/streaming-server:staging
docker pull ghcr.io/techsoft3d/node-server:staging

echo "📁 Copying public-staging into Docker volume..."
docker run --rm \
  -v public-staging:/volume \
  -v "$(pwd)/public-staging:/backup" \
  alpine sh -c "cp -r /backup/* /volume/ && ls -la /volume/"

echo "🚢 Running docker-compose..."
docker-compose -p staging_project up -d --force-recreate

echo "✅ Deployment finished!"
