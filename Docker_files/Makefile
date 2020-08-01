BASE_IMAGE?=ubuntu@sha256:60f560e52264ed1cb7829a0d59b1ee7740d7580e0eb293aca2d722136edb1e24
#VERSION?=v1.109-Beta
IMAGE?=base
tag?=final
label=--label='maintainer=<Roxedus,me@roxedus.dev>'
base=--build-arg BASE_IMAGE=$(BASE_IMAGE) $(label)
bld=--build-arg bin_stage=$(IMAGE):binaries --build-arg bundle=$(IMAGE):bundle

master: release
	docker build -f Dockerfile -t $(IMAGE):final --label tdarr.version=$(version) $(base) $(bld) .

dev: bundle
	docker build -f Dockerfile -t $(IMAGE):$(tag) --label tdarr.version=$(version) $(base) $(bld) .

local_master: release binaries master

local_dev: bundle binaries dev

bintest: binaries
	docker build -f test/Dockerfile.bintest -t $(IMAGE):test $(base) .

release:
	docker build -f Dockerfile.release -t $(IMAGE):bundle --build-arg version=$(version) $(base) .

bundle:
	docker build -f Dockerfile.build -t $(IMAGE):bundle $(base) ..

binaries:
	docker build -f Dockerfile.binaries -t $(IMAGE):binaries $(base) --cache-from $(IMAGE):binaries .

clear:
	docker system prune -f --filter label=maintainer=<Roxedus,me@roxedus.dev>