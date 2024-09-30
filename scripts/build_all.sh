#!/bin/sh

for DOCKERFILE in Dockerfile.*
do
	IMAGE_NAME="$(echo "$DOCKERFILE" | cut -d'.' -f2):$(date '+%d.%m.%Y')"

	docker build --build-arg ECON_CLIENTS="$ECON_CLIENTS" -f "$DOCKERFILE" -t "$IMAGE_NAME" .

	if [ -n "$CONTAINER_REGISTRY" ]
	then
		docker tag "$IMAGE_NAME" "$CONTAINER_REGISTRY/$IMAGE_NAME"
		docker push "$CONTAINER_REGISTRY/$IMAGE_NAME"
	fi
done
