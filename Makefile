default_target: all
.PHONY : default_target

SHELL = /bin/zsh -i

ARCH ?= amd64
CONTAINER_NAME = rdek
PODMAN_COMMAND = limactl shell podman-$(ARCH) podman

arch:
	$(info Current architecture is: $(ARCH))
.PHONY : arch

build: arch
	 $(PODMAN_COMMAND) build --squash-all --rm --tag $(CONTAINER_NAME) -f Dockerfile.openbox -t $(CONTAINER_NAME) .
.PHONY : build

start: arch
	$(PODMAN_COMMAND) start $(CONTAINER_NAME)
	$(PODMAN_COMMAND) exec -it $(CONTAINER_NAME) bash -c 'cat /remote'
.PHONY : start

stop: arch
	$(PODMAN_COMMAND) stop $(CONTAINER_NAME)
.PHONY : stop

remove: arch
	$(PODMAN_COMMAND) rm -f $(CONTAINER_NAME)
.PHONY : remove

clean: arch
	$(PODMAN_COMMAND) image rm -f localhost/$(CONTAINER_NAME)
.PHONY : clean

halt: arch
	limactl stop -f podman-amd64
.PHONY : halt

reset: arch
	limactl factory-reset podman-amd64
.PHONY : reset

all: build start
.PHONY : all
