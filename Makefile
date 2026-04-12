default_target: all
.PHONY : default_target

SHELL = /bin/zsh -i

# Define system architecture. Options: arm64 AND amd64. Example: ARCH=amd64 make build
ARCH ?= arm64
# rd - Remote Desktop, base container. Example: NAME=dm make build
NAME ?= rd
COMMAND ?= limactl shell $(ARCH) podman

# Build and manage containers
arch:
	$(info Current architecture is: $(ARCH))
.PHONY : arch

build: arch
	 $(COMMAND) build --squash-all --rm --tag $(NAME) -f Dockerfile.$(NAME) -t $(NAME) .
.PHONY : build

run: arch rmall
	$(COMMAND) run -d --shm-size="1gb" --memory="4gb" --name="$(NAME)" -p 3389:3389 -e PUID=${UID} -e PGID=${GID} localhost/$(NAME)
	$(COMMAND) exec -it $(NAME) bash -c 'cat /remote'
.PHONY : start

pw: arch
	$(COMMAND) exec -it $(NAME) bash -c 'cat /remote' | pbcopy
.PHONY : pw

stop: arch
	$(COMMAND) stop $(NAME)
.PHONY : stop

logs: arch
	$(COMMAND) logs $(NAME)
.PHONY : stop

rm: arch
	$(COMMAND) rm --force $(NAME)
.PHONY : rm

rmall: arch
	$(COMMAND) rm --force --all
.PHONY : rmall

clean: arch
	$(COMMAND) image rm -f localhost/$(NAME)
.PHONY : clean

save: arch
	rm -f $(NAME).{tar,tar.xz}
	$(COMMAND) image save $(NAME) > $(NAME).tar && xz $(NAME).tar
.PHONY : save

all: clean build start
.PHONY : all


# Manage Lima ENV
create: arch
	limactl delete --yes --force $(ARCH)
	limactl create --yes --name=$(ARCH) template:$(ARCH)
.PHONY : halt

boot: arch
	limactl start $(ARCH)
.PHONY : halt

halt: arch
	limactl stop --force $(ARCH)
.PHONY : halt

shell: arch
	limactl shell $(ARCH)
.PHONY : shell

reset: arch
	limactl factory-reset $(ARCH)
.PHONY : reset
