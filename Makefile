default_target: all
.PHONY : default_target

SHELL = /bin/zsh -i

ARCH ?= amd64
CONTAINER_NAME = rdek
COMMAND ?= limactl shell podman-$(ARCH) podman

arch:
	$(info Current architecture is: $(ARCH))
.PHONY : arch

build: arch
	 $(COMMAND) build --squash-all --rm --tag $(CONTAINER_NAME) -f Dockerfile.openbox -t $(CONTAINER_NAME) .
.PHONY : build

start: arch
	$(COMMAND) start $(CONTAINER_NAME)
	$(COMMAND) exec -it $(CONTAINER_NAME) bash -c 'cat /remote'
.PHONY : start

stop: arch
	$(COMMAND) stop $(CONTAINER_NAME)
.PHONY : stop

remove: arch
	$(COMMAND) rm -f $(CONTAINER_NAME)
.PHONY : remove

clean: arch
	$(COMMAND) image rm -f localhost/$(CONTAINER_NAME)
.PHONY : clean

halt: arch
	limactl stop -f podman-$(ARCH)
.PHONY : halt

reset: arch
	limactl factory-reset podman-$(ARCH)
.PHONY : reset

all: build start
.PHONY : all
