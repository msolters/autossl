.PHONY: all build release

repo=auto-ssl
shorthash=`git rev-parse --short HEAD`
base=us.gcr.io/kube-sandbox-181504/$(repo)
branch=$${BRANCH_NAME:-`git rev-parse --abbrev-ref HEAD`}
image=$(base):$(shorthash)

all: build release

build:
	docker build -t $(image) .
	docker tag $(image) $(base):$(branch)

release:
	docker push $(image)
	docker push $(base):$(branch)
