#!/usr/bin/env bash
# Instala Flutter dentro del build de Vercel (Vercel no lo trae instalado).
set -euo pipefail

command -v unzip >/dev/null || dnf install -y unzip

if [ -d flutter ]; then
  git -C flutter pull
else
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

flutter/bin/flutter config --enable-web --no-analytics
flutter/bin/flutter pub get
