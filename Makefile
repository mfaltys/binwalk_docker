IMAGE_NAME=binwalk
OS_PERMS=sudo

all: build

build:
	$(OS_PERMS) docker build -t $(IMAGE_NAME) .
