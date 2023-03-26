export $(grep -v '^#' .env | xargs)

PLATFORM="Ruby" APP=$APP SERVICE=$SERVICE ./build-prepare.sh

cp -R "../nitrox-$APP/nitrox-$SERVICE" "temp/nitrox-$SERVICE"
cp -R ../nitrox-core temp/nitrox-core
cp -R ../../lighstorm temp/lighstorm
cp docker/*.Gemfile temp/

PLATFORM="Ruby" SERVICE=$SERVICE DOCKER_REGISTRY=$DOCKER_REGISTRY ./build-docker.sh
