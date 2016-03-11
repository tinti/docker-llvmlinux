all: build

build:
	docker build -t tinti/llvmlinux:0.0.1 .
