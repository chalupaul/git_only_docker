# git-core
A docker container that builds git into a single /git-core directory. Useful for CICD

### Git Kinda Sucks
![ye olde fashioned xkcd Dependency image (https://xkcd.com/2347)](https://raw.githubusercontent.com/chalupaul/git_only_docker/refs/heads/main/assets/xkcdgit.jpg)

It may be the best source control system we've imagined so far, but its history as a patchwork set of bash and perl scripts really shows. 

Raise your hand if you've got container images with git installed just so you can do things like "go get foo" or uv/pip install packages from github repos.

It's actually prohibitively difficult to get git into a container build environment without installing it through a package manager. And because of that, it's not easy to get all of git into one location so you can mount it into a container and do the things you need.

## Usage

Easiest way to show it is through a Dockerfile snippet example:

```
FROM docker.io/chalupaul/git_core:latest AS git-core
FROM public.ecr.aws/amazonlinux/amazonlinux:minimal AS builder
ENV PATH="/git-core/bin:$PATH"
RUN --mount=from=git-core,source=/git-core,target=/git-core \
    uv pip install -r requirements.txt # or whatever your build command is
```

I'm using [Finch](https://runfinch.com/), so I have to use COPY statements instead:

```
FROM docker.io/chalupaul/git-core:latest AS git-core
FROM public.ecr.aws/amazonlinux/amazonlinux:minimal AS builder
ENV PATH="/git-core/bin:$PATH"
COPY --from=git-core /git-core /git-core/
RUN uv pip install -r requirements.txt && rm -rf /git-core

```

### Caveat Emptor

This image is built off of public.ecr.aws/amazonlinux/amazonlinux:minimal, which is the "latest" version (currently AL2023). This is because that's what their lambda python runtime images are based off.