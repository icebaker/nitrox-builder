if [ ! -f ".env" ]; then
  cp .env.example .env
fi

rm -rf temp
mkdir temp

echo "[{$PLATFORM}] Building nitrox:$APP/$SERVICE..."
