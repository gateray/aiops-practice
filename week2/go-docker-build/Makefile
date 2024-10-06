DOCKER ?= docker
DOCKER_BUILD ?= $(DOCKER) build
BUILD_TAG := v0.1

docker-build-server:
	$(DOCKER_BUILD) -t tcp_server:$(BUILD_TAG) server 

docker-build-client:
	$(DOCKER_BUILD) -t tcp_client:$(BUILD_TAG) client 


docker-build: \
	docker-build-server \
	docker-build-client 
