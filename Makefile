IMAGE_DIRS = $(wildcard services/* bases/*)
ROOT_FOLDER = ${PWD}

ifndef GIT_COMMIT
	GIT_COMMIT = $(shell git rev-parse --verify HEAD )
endif
ifndef GIT_SHORT_COMMIT
	GIT_SHORT_COMMIT = $(shell git rev-parse --verify --short HEAD )
endif
ifndef GIT_BRANCH
	GIT_BRANCH = $(shell git branch --show-current)
endif

DEFAULT_PLATFORMS = linux/amd64,linux/arm64
DEFAULT_REGISTRY = 067421297632.dkr.ecr.us-east-1.amazonaws.com
DEFAULT_TAGS = ${GIT_SHORT_COMMIT}
MANIFEST_FILE = MANIFEST

export GIT_COMMIT
export GIT_SHORT_COMMIT
export GIT_BRANCH
export DEFAULT_REGISTRY
export MANIFEST_FILE
export ROOT_FOLDER
export DEFAULT_PLATFORMS
export DEFAULT_TAGS

# All targets are `.PHONY` ie allways need to be rebuilt
.PHONY: all ${IMAGE_DIRS}

# Build all images
all:
	@make ${IMAGE_DIRS}

# Build and tag a single image
${IMAGE_DIRS}:
	$(eval IMAGE_NAME := $(word 2,$(subst /, ,$@)))
	$(eval FOLDER := $@)
	@./scripts/process_folder.sh $(FOLDER)

# Specify dependencies between images
bases/golang-1.17.2: bases/tools