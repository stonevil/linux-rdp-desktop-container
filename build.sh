echo "Stop and delete container"
limactl shell podman-amd64 podman stop rdek
limactl shell podman-amd64 podman rm rdek

echo "Delete container image"
limactl shell podman-amd64 podman image rm rdek

echo "Build container"
# --squash-all
limactl shell podman-amd64 podman build --rm --tag rdek -f Dockerfile.fedora -t rdek .
