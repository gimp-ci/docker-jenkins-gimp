DOCKER_STABLE_NAME = gimp/gimp
DOCKER_STABLE_VERSION = $$(date +%Y%d%m)
DOCKER_SOURCE = debian-testing
GIT_VOLUME = gimp-data

unstable:
	docker build -t gimp:unstable $(DOCKER_SOURCE)

end-to-end: unstable
	cat debian-testing/babl.sh debian-testing/gegl.sh debian-testing/libmypaint.sh debian-testing/mypaint-brushes.sh debian-testing/gimp.sh | \
	docker run -iv $(GIT_VOLUME):/export:ro --rm gimp:latest /bin/bash

clean-unstable:
	- docker rmi -f gimp:unstable

promote:
	docker tag gimp:unstable $(DOCKER_STABLE_NAME):$(GIMP_STABLE_VERSION)
	docker tag gimp:unstable $(DOCKER_STABLE_NAME):latest

push:
	docker push $(DOCKER_STABLE_NAME):$(GIMP_STABLE_VERSION)
	docker push $(DOCKER_STABLE_NAME):latest
