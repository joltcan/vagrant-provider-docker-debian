CONTAINER	:= vagrant-debian-stable-slim
HUB_USER	:= ${USER}
IMAGE_NAME	:= ${HUB_USER}/${CONTAINER}
VERSION		:= v0.1
EXPOSEPORT	:= 22
PUBLISHPORT := 2222

build:
#	git checkout master
#	git branch -f tag-${VERSION}
#	git checkout tag-${VERSION}
	docker \
		build \
		--rm --tag=${IMAGE_NAME}:${VERSION} .
	@echo Image tag: ${VERSION}

start: run

run:
	docker \
		run \
		--detach \
		--interactive \
		--tty \
		--hostname=${CONTAINER} \
		--name=${CONTAINER} \
		-p ${PUBLISHPORT}:${EXPOSEPORT} \
		$(CONTAINER)

shell:
	docker \
		run \
		--rm \
		--interactive \
		--tty \
		--hostname=${CONTAINER} \
		--name=${CONTAINER} \
		-p ${PUBLISHPORT}:${EXPOSEPORT} \
		--entrypoint "/bin/bash" \
		$(CONTAINER) 

exec:
	docker exec \
		--interactive \
		--tty \
		${CONTAINER} \
		/bin/bash

stop:
	-docker kill ${CONTAINER}
	-docker rm ${CONTAINER}

rm:
	docker \
		rm ${CONTAINER}

history:
	docker \
		history ${CONTAINER}

clean:
	docker rm ${CONTAINER}
	docker rmi ${CONTAINER}:${VERSION}
	git checkout master
	git branch -d ${VERSION}

push:
	docker tag ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:latest
	docker push ${IMAGE_NAME}:${VERSION} && docker push ${IMAGE_NAME}:latest

restart: stop clean run
