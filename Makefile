GIMP_UNSTABLE_NAME = samrocketman/gimp-unstable
GIMP_UNSTABLE_VERSION = 0.1
GIMP_UNSTABLE_BASEDIR = docker-gimp-unstable

.PHONY: all tag build
.PHONY: build_gimp_unstable tag_gimp_unstable_latest

#easily typed targets (default target: build)
build: build_gimp_unstable
all: build tag
tag: tag_gimp_unstable_latest

#long name targets
build_gimp_unstable:
	- echo "Making $(GIMP_UNSTABLE_NAME)"
	docker build -t $(GIMP_UNSTABLE_NAME):latest --rm $(GIMP_UNSTABLE_BASEDIR)
tag_gimp_unstable_latest:
	docker tag $(GIMP_UNSTABLE_NAME):latest $(GIMP_UNSTABLE_NAME):$(GIMP_UNSTABLE_VERSION)



#test:
#	env NAME=$(BASEIMAGE_JESSIE_NAME) VERSION=$(BASEIMAGE_JESSIE_VERSION) ./test/runner.sh
#release: test tag_latest
#	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
#	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
#	docker push $(NAME)
#ssh:
#	chmod 600 $(BASEIMAGE_JESSIE_BASEDIR)/insecure_key
#	@ID=$$(docker ps | grep -F "$(GIMP_DOCKER_JESSIE_NAME):$(GIMP_DOCKER_JESSIE_VERSION)" | awk '{ print $$1 }') && \
#		if test "$$ID" = ""; then echo "Container is not running."; exit 1; fi && \
#		IP=$$(docker inspect $$ID | grep IPAddr | sed 's/.*: "//; s/".*//') && \
#		echo "SSHing into $$IP" && \
#		ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $(BASEIMAGE_JESSIE_BASEDIR)/insecure_key root@$$IP
