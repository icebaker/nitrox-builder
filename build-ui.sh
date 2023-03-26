if [ ! -f ".env" ]; then
  cp .env.example .env
fi

APP=ui SERVICE=ui ./build-svelte.sh
