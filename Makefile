DOCKER_SOURCE := debian-testing
DOCKER_STABLE_NAME := gimp/gimp
DOCKER_STABLE_VERSION := $(shell date +%Y%m%d)
GIT_VOLUME := gimp-git-data
BIN_VOLUME := gimp-bin
OS_KERNEL := $(shell uname -s)
ifdef BIN_SUFFIX
	BIN_VOLUME := $(BIN_VOLUME)$(BIN_SUFFIX)
endif
# check out the appropriate GEGL branch
ifneq ($(GEGL_BRANCH),)
	GEGL_BRANCH := $(GEGL_BRANCH)
endif
ifndef GEGL_BRANCH
	GEGL_BRANCH := master
endif
# check out the appropriate GIMP branch
ifneq ($(GIMP_BRANCH),)
	GIMP_BRANCH := $(GIMP_BRANCH)
endif
ifndef GIMP_BRANCH
	GIMP_BRANCH := master
endif
ifeq ($(OS_KERNEL), Darwin)
	HOST_IP := $(shell ifconfig en0 | awk '$$1 == "inet" { print $$2 }')
	MAKE_DISPLAY := $(HOST_IP):0
else
	MAKE_DISPLAY := $(DISPLAY)
endif
ifdef ROOT_LOGIN
	INTERACTIVE_USER := root
else
	INTERACTIVE_USER := jenkins
endif

ifdef SKIP_TESTS
	override SKIP_TESTS := -e SKIP_MAKE_CHECK=1
endif

.PHONY: about bin-volume build-gimp build-gimp clean clean-all clean-bin-volume clean-git-volume clean-unstable clean-volumes dockerhub-publish end-to-end gimp-gui gimp-gui git-volume interactive osx-display promote release unstable volumes


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
	    make clean\n\
	        Will only delete the volume used to house internal binary artifacts\n\
	        for building.\n\n\
	    make clean-all\n\
	        Deletes all volumes and Docker images created by this repository.\n\
	        If developing the container it is also recommended to run\n\
	        \"docker image prune\"\n\n\
	    make end-to-end\n\
	        Builds everything from scratch and runs a test build of GIMP and\n\
			its dependencies.  Covers GIMP versions 2.8, 2.10, and master.\n\
	        This is meant for the CI environment to run a full container build\n\
	        pulling in the latest Debian testing packages.\n\n\
	    make promote\n\
	        Promotes the latest unstable image to stable status and tags it.\n\
	        This assumes the unstable image passed end to end testing.  This is\n\
	        meant for the CI environment to auto-promote its own images.\n\n\
	    make dockerhub-publish\n\
	        Publishes the latest stable images to the official GIMP Docker Hub\n\
	        site.  Assumes \"make promotion\" and \"docker login\" have been run.\n\
	        This target is meant to be run by the CI environment.\n\n\
	Configurable environment variables:\n\n\
	    BIN_SUFFIX\n\
	        Configures an additional suffix for the gimp-bin docker volume.\n\
	        The volume is used to hold intermediate binary artifacts.  Useful\n\
	        to customize working on multiple versions of GIMP simultaneously.\n\n\
	    GEGL_BRANCH\n\
	        Customize the git branch to build GEGL.  Useful for building\n\
	        alternate versions of GIMP.\n\n\
	    GIMP_BRANCH\n\
	        Customize the git branch to build GIMP.  Useful for building\n\
	        alternate versions of GIMP.\n\
	"
osx-display:
	set -ex; if [ "$(OS_KERNEL)" = 'Darwin' ]; then \
		open -a XQuartz; \
		defaults write org.macosforge.xquartz.X11 nolisten_tcp -boolean false; \
		xhost +$(HOST_IP); \
	fi

interactive: osx-display
	docker run -e GIMP_BRANCH=$(GIMP_BRANCH) -u $(INTERACTIVE_USER) -ite "DISPLAY=$(MAKE_DISPLAY)" -v /tmp/.X11-unix:/tmp/.X11-unix -v $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest /bin/bash

gimp-gui: osx-display
	docker run -ie DISPLAY=$(MAKE_DISPLAY) -v /tmp/.X11-unix:/tmp/.X11-unix -v $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest \
	/bin/bash -exc 'tar -C "$$PREFIX" -xzf /data/gimp-internal.tar.gz; $$(./usr/bin/gimp-[0-9]*)'

build-gimp: volumes
	docker run -iv $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest /bin/bash < $(DOCKER_SOURCE)/babl.sh
	docker run -e GEGL_BRANCH=$(GEGL_BRANCH) -iv $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest /bin/bash < $(DOCKER_SOURCE)/gegl.sh
	docker run -iv $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest /bin/bash < $(DOCKER_SOURCE)/libmypaint.sh
	docker run -iv $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest /bin/bash < $(DOCKER_SOURCE)/mypaint-brushes.sh
	docker run -e GIMP_BRANCH=$(GIMP_BRANCH) $(SKIP_TESTS) -iv $(GIT_VOLUME):/export:ro -v $(BIN_VOLUME):/data:rw --rm $(DOCKER_STABLE_NAME):latest /bin/bash < $(DOCKER_SOURCE)/gimp.sh

unstable:
	docker pull debian:testing
	docker build --no-cache -t gimp:unstable $(DOCKER_SOURCE)

end-to-end: unstable git-volume
	@ echo "Test building GIMP 2.8"
	cat debian-testing/babl.sh debian-testing/gegl.sh debian-testing/libmypaint.sh debian-testing/mypaint-brushes.sh debian-testing/gimp.sh | \
	docker run -e GEGL_BRANCH=gegl-0-2 -e GIMP_BRANCH=gimp-2-8 -iv $(GIT_VOLUME):/export:ro --rm gimp:unstable /bin/bash
	@ echo "Test building GIMP 2.10"
	cat debian-testing/babl.sh debian-testing/gegl.sh debian-testing/libmypaint.sh debian-testing/mypaint-brushes.sh debian-testing/gimp.sh | \
	docker run -e GIMP_BRANCH=gimp-2-10 -iv $(GIT_VOLUME):/export:ro --rm gimp:unstable /bin/bash
	@ echo "Test building GIMP 2.99"
	cat debian-testing/babl.sh debian-testing/gegl.sh debian-testing/libmypaint.sh debian-testing/mypaint-brushes.sh debian-testing/gimp.sh | \
	docker run -e GIMP_BRANCH=gimp-2-10 -iv $(GIT_VOLUME):/export:ro --rm gimp:unstable /bin/bash

volumes: git-volume bin-volume

git-volume:
	docker volume create $(GIT_VOLUME)
	docker run -iv $(GIT_VOLUME):/export -u root --rm $(DOCKER_STABLE_NAME):latest /bin/bash < debian-testing/update-git-reference.sh

bin-volume:
	docker volume create $(BIN_VOLUME)
	docker run -u root -v $(BIN_VOLUME):/data --rm $(DOCKER_STABLE_NAME):latest /bin/bash -c \
	'chown jenkins: /data'

clean: clean-bin-volume

clean-all: clean-unstable clean-volumes
	- docker rmi -f $(DOCKER_STABLE_NAME):latest
	@ echo "\n\n\
	You might also want to run \"docker image prune\" and\n\
	\"docker rmi -f debian:testing\".  These items are not directly covered by\n\
	this clean up"\n\

clean-volumes: clean-git-volume clean-bin-volume

clean-git-volume:
	- docker volume rm $(GIT_VOLUME)

clean-bin-volume:
	- docker volume rm $(BIN_VOLUME)

clean-unstable:
	- docker rmi -f gimp:unstable

promote:
	docker tag gimp:unstable $(DOCKER_STABLE_NAME):latest

release:
	docker tag gimp:unstable $(DOCKER_STABLE_NAME):$(DOCKER_STABLE_VERSION)

dockerhub-publish:
	docker push $(DOCKER_STABLE_NAME):$(DOCKER_STABLE_VERSION)
	docker push $(DOCKER_STABLE_NAME):latest
	git tag $(DOCKER_STABLE_VERSION)
	git push --tags
