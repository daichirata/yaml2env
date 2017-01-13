VERSION := v0.1.1

GOFILES := $(shell find . -type f -name *.go -not -path */vendor/*)
GOPKG_NOVENDOR := glide nv

all: bin/yaml2env

build-cross: $(GOFILES)
	GOOS=linux GOARCH=amd64 go build -o out/yaml2env-$(VERSION)-Linux-amd64 .
	GOOS=darwin GOARCH=amd64 go build -o out/yaml2env-$(VERSION)-Darwin-amd64 .

bin/yaml2env: $(GOFILES)
	go build -o $@ .

deps:
	glide install

fmt:
	@echo $(GOPKG_NOVENDOR) | xargs go fmt

check:
	go test $(GOPKG_NOVENDOR)

clean:
	rm -rf bin/*
	rm -rf out/*
