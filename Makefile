DOCKER_STABLE_NAME = gimp/gimp
DOCKER_STABLE_VERSION = $$(date +%Y%d%m)
DOCKER_SOURCE = debian-testing
GIT_VOLUME = gimp-git-data
BIN_VOLUME = gimp-bin

unstable:
	docker pull debian:testing
	docker build --no-cache -t gimp:unstable $(DOCKER_SOURCE)

end-to-end: unstable git-volume
	cat debian-testing/babl.sh debian-testing/gegl.sh debian-testing/libmypaint.sh debian-testing/mypaint-brushes.sh debian-testing/gimp.sh | \
	docker run -iv $(GIT_VOLUME):/export:ro --rm gimp:latest /bin/bash

volumes: git-volume bin-volume

git-volume:
	docker volume create $(GIT_VOLUME)
	docker run -iv $(GIT_VOLUME):/export -u root --rm gimp:latest /bin/bash < debian-testing/update-git-reference.sh

bin-volume:
	docker volume create $(BIN_VOLUME)
	docker run -u root -v $(BIN_VOLUME):/data --rm $(DOCKER_STABLE_NAME):latest /bin/bash -c \
	'chown jenkins: /data'

clean-all: clean-unstable clean-volumes

clean-volumes:
	- docker volume rm $(GIT_VOLUME) $(BIN_VOLUME)

clean-unstable:
	- docker rmi -f gimp:unstable

promote:
	docker tag gimp:unstable $(DOCKER_STABLE_NAME):$(GIMP_STABLE_VERSION)
	docker tag gimp:unstable $(DOCKER_STABLE_NAME):latest

push:
	docker push $(DOCKER_STABLE_NAME):$(GIMP_STABLE_VERSION)
	docker push $(DOCKER_STABLE_NAME):latest
