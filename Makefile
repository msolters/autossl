repo=auto-ssl
shorthash=$(SHORT_SHA)
registry=gcr.io/$(PROJECT_ID)
projectID=$(PROJECT_ID)
base=$(registry)/$(repo)
branch=$${BRANCH_NAME:-`git rev-parse --abbrev-ref HEAD`}
image=$(base):$(shorthash)

all: build release

export DOCKER_REPO=$(registry)
export PROJECT_ID=$(projectID)
export GIT_HASH=$(shorthash)
skaffold-run:
	bash templateSkaffold.sh
	bash templateKustomization.sh
	skaffold run

build:
	docker build -t $(image) .
	docker tag $(image) $(base):$(branch)

release:
	docker push $(image)
	docker push $(base):$(branch)

local-docker: build
	docker run -p80:80 -p443:443 $(image)

exec: build
	docker run -it -p80:80 -p443:443 $(image) bash
