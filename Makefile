DOCKER_SOURCE := debian-testing
DOCKER_STABLE_NAME := gimp/gimp
DOCKER_STABLE_VERSION := $(shell date +%Y%m%d)
GIT_VOLUME := gimp-git-data
BIN_VOLUME := gimp-bin
OS_KERNEL := $(shell uname -s)
# check out the appropriate GIMP branch
ifneq ($(GIMP_BRANCH),)
	GIMP_BRANCH := $(GIMP_BRANCH)
endif
ifndef GIMP_BRANCH
	GIMP_BRANCH := gimp-2-10
endif
ifeq ($(OS_KERNEL), Darwin)
	HOST_IP := $(shell ifconfig en0 | awk '$$1 == "inet" { print $$2 }')
	MAKE_DISPLAY := $(HOST_IP):0
else
	MAKE_DISPLAY := $(DISPLAY)
endif

.PHONY: about bin-volume build-gimp build-gimp clean-all clean-unstable clean-volumes dockerhub-publish end-to-end gimp-gui gimp-gui git-volume interactive osx-display promote unstable volumes

about:
	@ echo "\
	GIMP Development Environment\n\
	============================\n\n\
	Welcome to developing GIMP within Docker!  Here are some helpful make commands\n\
	which simplify using Docker to develop GIMP.\n\n\
	Start the GUI of the latest development version.\n\n\
	    make build-gimp\n\
	    make gimp-gui\n\n\
	Start an interactive terminal which also supports starting the GUI.\n\n\
	    make interactive\n\n\
	Other supported make targets:\n\n\
	    make clean-all\n\
	        Deletes all volumes and Docker images created by this repository.\n\
	        If developing the container it is also recommended to run\n\
	        \"docker image prune\"\n\n\
	    make end-to-end\n\
	        Builds everything from scratch and runs a test build of GIMP and\n\
	        its dependencies.  This is meant for the CI environment to run a\n\
	        full container build pulling in the latest Debian testing packages.\n\n\
	    make promote\n\
	        Promotes the latest unstable image to stable status and tags it.\n\
	        This assumes the unstable image passed end to end testing.  This is\n\
	        meant for the CI environment to auto-promote its own images.\n\n\
	    make dockerhub-publish\n\
	        Publishes the latest stable images to the official GIMP Docker Hub\n\
	        site.  Assumes \"make promotion\" and \"docker login\" have been run.\n\
	        This target is meant to be run by the CI environment.\n\
	"
osx-display:
	set -ex; if [ "$(OS_KERNEL)" = 'Darwin' ]; then \
		open -a XQuartz; \
		defaults write org.macosforge.xquartz.X11 nolisten_tcp -boolean false; \
		xhost +$(HOST_IP); \
	fi

interactive: osx-display
	docker run -e GIMP_BRANCH=$(GIMP_BRANCH) -ite DISPLAY=$(MAKE_DISPLAY) -v /tmp/.X11-unix:/tmp/.X11-unix -v $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest /bin/bash

gimp-gui: osx-display
	docker run -ie DISPLAY=$(MAKE_DISPLAY) -v /tmp/.X11-unix:/tmp/.X11-unix -v $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest \
	/bin/bash -c 'tar -C "$$PREFIX" -xzf /data/gimp-internal.tar.gz && gimp'

build-gimp: volumes
	docker run -iv $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest /bin/bash < $(DOCKER_SOURCE)/babl.sh
	docker run -iv $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest /bin/bash < $(DOCKER_SOURCE)/gegl.sh
	docker run -iv $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest /bin/bash < $(DOCKER_SOURCE)/libmypaint.sh
	docker run -iv $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest /bin/bash < $(DOCKER_SOURCE)/mypaint-brushes.sh
	docker run -e GIMP_BRANCH=$(GIMP_BRANCH) -e SKIP_MAKE_CHECK=1 -iv $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest /bin/bash < $(DOCKER_SOURCE)/gimp.sh

unstable:
	docker pull debian:testing
	docker build --no-cache -t gimp:unstable $(DOCKER_SOURCE)

end-to-end: unstable git-volume
	cat debian-testing/babl.sh debian-testing/gegl.sh debian-testing/libmypaint.sh debian-testing/mypaint-brushes.sh debian-testing/gimp.sh | \
	docker run -iv $(GIT_VOLUME):/export:ro --rm gimp:unstable /bin/bash

volumes: git-volume bin-volume

git-volume:
	docker volume create $(GIT_VOLUME)
	docker run -iv $(GIT_VOLUME):/export -u root --rm $(DOCKER_STABLE_NAME):latest /bin/bash < debian-testing/update-git-reference.sh

bin-volume:
	docker volume create $(BIN_VOLUME)
	docker run -u root -v $(BIN_VOLUME):/data --rm $(DOCKER_STABLE_NAME):latest /bin/bash -c \
	'chown jenkins: /data'

clean-all: clean-unstable clean-volumes
	- docker rmi -f $(DOCKER_STABLE_NAME):latest
	@ echo "\n\n\
	You might also want to run \"docker image prune\" and\n\
	\"docker rmi -f debian:testing\".  These items are not directly covered by\n\
	this clean up"\n\

clean-volumes:
	- docker volume rm $(GIT_VOLUME) $(BIN_VOLUME)

clean-unstable:
	- docker rmi -f gimp:unstable

promote:
	docker tag gimp:unstable $(DOCKER_STABLE_NAME):$(DOCKER_STABLE_VERSION)
	docker tag gimp:unstable $(DOCKER_STABLE_NAME):latest

dockerhub-publish:
	docker push $(DOCKER_STABLE_NAME):$(DOCKER_STABLE_VERSION)
	docker push $(DOCKER_STABLE_NAME):latest
