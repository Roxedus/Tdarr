BASE_IMAGE?=ubuntu@sha256:3013b0d761d4bad6ff16dd2805887a2f2c3fc140d6206086698b5c3e44e0f7fe
#VERSION?=v1.109-Beta
IMAGE?=base
tag?=final
label=--label='maintainer=<Roxedus,me@roxedus.dev>'
base=--build-arg BASE_IMAGE=$(BASE_IMAGE) $(label)

master: binaries release
	docker build -f Dockerfile -t $(IMAGE):final --label tdarr.version=$(VERSION) $(base) .

dev:
	docker build -f Dockerfile -t $(IMAGE):$(tag) --label tdarr.version=$(VERSION) $(base) .

bintest: binaries
	docker build -f test/Dockerfile.bintest -t $(IMAGE):test $(base) .

release:
	docker build -f Dockerfile.release -t $(IMAGE):bundle --build-arg VERSION=$(VERSION) $(base) .

bundle:
	docker build -f Dockerfile.build -t $(IMAGE):bundle $(base) $(label) ..

binaries:
	docker build -f Dockerfile.binaries -t $(IMAGE):binaries $(base) .

clear:
	docker system prune -f --filter label=maintainer=<Roxedus,me@roxedus.dev>