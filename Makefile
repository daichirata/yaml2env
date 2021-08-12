VERSION := v0.1.2

GOFILES := $(shell find . -type f -name *.go -not -path */vendor/*)

all: bin/yaml2env

build-cross: $(GOFILES)
	GOOS=linux GOARCH=amd64 go build -o out/yaml2env-$(VERSION)-Linux-amd64 .
	GOOS=linux GOARCH=arm go build -o out/yaml2env-$(VERSION)-Linux-arm .
	GOOS=linux GOARCH=arm64 go build -o out/yaml2env-$(VERSION)-Linux-arm64 .
	GOOS=linux GOARCH=386 go build -o out/yaml2env-$(VERSION)-Linux-i386 .
	GOOS=darwin GOARCH=amd64 go build -o out/yaml2env-$(VERSION)-Darwin-amd64 .
	GOOS=darwin GOARCH=arm64 go build -o out/yaml2env-$(VERSION)-Darwin-arm64 .

bin/yaml2env: $(GOFILES)
	go build -o $@ .

deps:
	glide install

fmt:
	@echo $(GOFILES) | xargs go fmt

clean:
	rm -rf bin/*
	rm -rf out/*
