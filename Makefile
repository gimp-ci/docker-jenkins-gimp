BASEIMAGE_JESSIE_NAME = samrocketman/baseimage-jessie
BASEIMAGE_JESSIE_VERSION = 0.0.1
BASEIMAGE_JESSIE_BASEDIR = baseimage-jessie

GIMP_DOCKER_JESSIE_NAME = samrocketman/gimp-docker-jessie
GIMP_DOCKER_JESSIE_VERSION = 0.0.2
GIMP_DOCKER_JESSIE_BASEDIR = gimp-docker-jessie

.PHONY: all test tag_latest release ssh
.PHONY: build_baseimage_jessie build_gimp_docker_jessie
.PHONY: tag_baseimage_jessie_latest tag_gimp_docker_jessie_latest

build_gimp_docker_jessie:
	- echo "Making $(GIMP_DOCKER_JESSIE_NAME)"
	docker build -t $(GIMP_DOCKER_JESSIE_NAME):$(GIMP_DOCKER_JESSIE_VERSION) $(GIMP_DOCKER_JESSIE_BASEDIR)
#	docker build -t $(GIMP_DOCKER_JESSIE_NAME):$(GIMP_DOCKER_JESSIE_VERSION) --rm $(GIMP_DOCKER_JESSIE_BASEDIR)

tag_gimp_docker_jessie_latest:
	docker tag $(GIMP_DOCKER_JESSIE_NAME):$(GIMP_DOCKER_JESSIE_VERSION) $(GIMP_DOCKER_JESSIE_NAME):latest

build_baseimage_jessie:
	- echo "Making $(BASEIMAGE_JESSIE_NAME)"
	docker build -t $(BASEIMAGE_JESSIE_NAME):$(BASEIMAGE_JESSIE_VERSION) --rm $(BASEIMAGE_JESSIE_BASEDIR)

tag_baseimage_jessie_latest:
	docker tag $(BASEIMAGE_JESSIE_NAME):$(BASEIMAGE_JESSIE_VERSION) $(BASEIMAGE_JESSIE_NAME):latest

all: build_baseimage_jessie build_gimp_docker_jessie tag_gimp_docker_jessie_latest tag_baseimage_jessie_latest

#test:
#	env NAME=$(BASEIMAGE_JESSIE_NAME) VERSION=$(BASEIMAGE_JESSIE_VERSION) ./test/runner.sh

#release: test tag_latest
#	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
#	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
#	docker push $(NAME)
#	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

ssh:
	chmod 600 $(BASEIMAGE_JESSIE_BASEDIR)/insecure_key
	@ID=$$(docker ps | grep -F "$(GIMP_DOCKER_JESSIE_NAME):$(GIMP_DOCKER_JESSIE_VERSION)" | awk '{ print $$1 }') && \
		if test "$$ID" = ""; then echo "Container is not running."; exit 1; fi && \
		IP=$$(docker inspect $$ID | grep IPAddr | sed 's/.*: "//; s/".*//') && \
		echo "SSHing into $$IP" && \
		ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $(BASEIMAGE_JESSIE_BASEDIR)/insecure_key root@$$IP
