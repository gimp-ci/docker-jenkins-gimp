BASEIMAGE_JESSIE_NAME = samrocketman/baseimage-jessie
BASEIMAGE_JESSIE_VERSION = 0.0.1
BASEIMAGE_JESSIE_BASEDIR = baseimage-jessie

.PHONY: all build test tag_latest release ssh

all: build-baseimage-jessie

build_baseimage_jessie:
	docker build -t $(BASEIMAGE_JESSIE_NAME):$(BASEIMAGE_JESSIE_VERSION) --rm $(BASEIMAGE_JESSIE_BASEDIR)

#test:
#	env NAME=$(BASEIMAGE_JESSIE_NAME) VERSION=$(BASEIMAGE_JESSIE_VERSION) ./test/runner.sh

tag_baseimage_jessie_latest:
	docker tag $(BASEIMAGE_JESSIE_NAME):$(BASEIMAGE_JESSIE_VERSION) $(BASEIMAGE_JESSIE_NAME):latest

#release: test tag_latest
#	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
#	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
#	docker push $(NAME)
#	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

ssh_baseimage_jessie:
	chmod 600 image/insecure_key
	@ID=$$(docker ps | grep -F "$(BASEIMAGE_JESSIE_NAME):$(BASEIMAGE_JESSIE_VERSION)" | awk '{ print $$1 }') && \
		if test "$$ID" = ""; then echo "Container is not running."; exit 1; fi && \
		IP=$$(docker inspect $$ID | grep IPAddr | sed 's/.*: "//; s/".*//') && \
		echo "SSHing into $$IP" && \
		ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i shared/insecure_key root@$$IP
