VERSION="3.0"

all: opencontrail-base \
	docker-opencontrail-database \
	docker-zookeeper \
	docker-redis \
	docker-opencontrail-config \
	docker-opencontrail-control \
	docker-opencontrail-analytics

opencontrail-base:
	@echo "== Building opencontrail-base"
	docker build -t opencontrail-$(VERSION)/opencontrail-base -f docker/opencontrail-base.Dockerfile docker

docker-%:
	$(eval IMAGE_NAME := $(patsubst docker-%,%,$@))
	@echo "== Building $(IMAGE_NAME)"
	sed -i -e "s,^FROM opencontrail.*,FROM opencontrail-$(VERSION)/opencontrail-base,g" docker/$(IMAGE_NAME).Dockerfile
	docker build -t opencontrail/$(IMAGE_NAME) -f docker/$(IMAGE_NAME).Dockerfile docker

help:
	@echo "Available targets:"
	@echo "  all          build all docker images"
	@echo "  opencontrail-base   build opencontrail base image"
	@echo "  docker-%     build given docker image"
