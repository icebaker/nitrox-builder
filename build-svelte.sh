export $(grep -v '^#' .env | xargs)

PLATFORM="Svelte" APP=$APP SERVICE=$SERVICE ./build-prepare.sh

cp -R "../nitrox-$SERVICE" "temp/nitrox-$SERVICE"

PLATFORM="Svelte" SERVICE=$SERVICE DOCKER_REGISTRY=$DOCKER_REGISTRY ./build-docker.sh
