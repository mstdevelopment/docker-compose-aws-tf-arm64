# Docker Compose

This docker image installs docker-compose, awscli and terraform on top of the `docker` image.
This is very useful for CI pipelines, which leverage "Docker in Docker".

## Docker versions supported

There are versions based on different docker versions, e.g. `latest`, `18.06`.

docker-compose matches the latest minor version available when the docker release was made. Eg, `18.06` includes docker-compose 1.22.0. The `latest` tag always includes the latest docker-compose build.

AwsCli match the latest version available when the build was made.
Terraform is actualy at the version 0.11.8

## Usage instructions for GitLab CI

You may use it like this in your `.gitlab-ci.yml` file.

```yaml
image: pwbdod/docker-compose-aws-tf:latest

services:
  - docker:dind

before_script:
  - docker info
  - docker-compose --version

build image:
  stage: build
  script:
    - docker-compose build
```