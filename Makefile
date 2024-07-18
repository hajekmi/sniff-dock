help:
	echo "=== Targets ==="
	@grep '^[^#[:space:]].*:' Makefile

build:
	podman build -t ghcr.io/hajekmi/sniff-dock -f Dockerfile --platform linux/amd64 .

auth:
	podman login ghcr.io

push:
	podman push ghcr.io/hajekmi/sniff-dock:latest

clean:
	podman container exists sniff-dock && podman container stop -t 3 sniff-dock || echo
	podman image exists ghcr.io/hajekmi/sniff-dock:latest && podman image rm ghcr.io/hajekmi/sniff-dock:latest || echo 
