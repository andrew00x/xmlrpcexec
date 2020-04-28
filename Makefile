GO_VERSION=1.12.5
ARCH=$(shell go env GOARCH)

SRC_DIR=cmd
OUTPUT_DIR=bin
OUTPUT=xmlrpc

PKG=github.com/andrew00x/xmlrpcexec

build-rpi3: ARCH=arm

clean:                ## Remove build results
	@rm -rf $(OUTPUT_DIR)

build: clean          ## Build
	@go build -v -installsuffix "static" -o $(OUTPUT_DIR)/$(ARCH)/$(OUTPUT) $(addprefix ./, $(addsuffix /..., $(SRC_DIR)))

build-rpi3: clean     ## Build binaries for Raspberry PI 3 architecture
                      ## Note: docker is required
	@docker run \
		--rm \
		-e GOOS=linux \
		-e GOARCH=$(ARCH) \
		-e GOARM=7 \
		-e GO111MODULE=on \
		-v "$$(pwd):/go/src/$(PKG)" \
		-w "/go/src/$(PKG)" \
		golang:$(GO_VERSION) \
		/bin/bash -c "go build -v -installsuffix "static" -o $(OUTPUT_DIR)/$(ARCH)/$(OUTPUT) $(addprefix ./, $(addsuffix /..., $(SRC_DIR)))"

help:                 ## Print this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/##//'
