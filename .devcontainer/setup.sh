#!/usr/bin/env bash
set -e

echo "📦 Instalando suiup..."
curl -sSfL https://raw.githubusercontent.com/Mystenlabs/suiup/main/install.sh | sh

echo "📦 Instalando sui..."
suiup install sui -y
