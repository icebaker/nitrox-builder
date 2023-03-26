if [ ! -f ".env" ]; then
  cp .env.example .env
fi

APP=baseline SERVICE=discovery ./build-ruby.sh
APP=baseline SERVICE=connector ./build-ruby.sh
APP=baseline SERVICE=proxy ./build-ruby.sh
