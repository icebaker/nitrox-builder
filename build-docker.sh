cp "docker/${PLATFORM}.Dockerfile" temp/Dockerfile
sed -i "s/{SERVICE}/$SERVICE/g" temp/Dockerfile

if [ -d "temp/nitrox-$SERVICE/data" ]
then
  rm -rf "temp/nitrox-$SERVICE/data"
fi

cd temp && docker build . -t "nitrox-${SERVICE}" && cd ..

rm -rf temp

docker tag "nitrox-${SERVICE}:latest" "${DOCKER_REGISTRY}/nitrox-${SERVICE}"
docker push  "${DOCKER_REGISTRY}/nitrox-${SERVICE}"

echo "Docker image created: nitrox-$SERVICE"
