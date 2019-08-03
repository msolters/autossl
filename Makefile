repo=auto-ssl
shorthash=$(SHORT_SHA)
registry=gcr.io/$(PROJECT_ID)
projectID=$(PROJECT_ID)
base=$(registry)/$(repo)
branch=$${BRANCH_NAME:-`git rev-parse --abbrev-ref HEAD`}
image=$(base):$(shorthash)

all: build release

skaffold-run:
	DOCKER_REPO=$(registry) PROJECT_ID=$(projectID) bash templateSkaffold.sh
	DOCKER_REPO=$(registry) GIT_HASH=$(shorthash) bash templateKustomization.sh
	DOCKER_REPO=$(registry) GIT_HASH=$(shorthash) skaffold run

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
