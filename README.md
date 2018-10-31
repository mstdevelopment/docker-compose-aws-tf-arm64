
# Docker Compose Aws Tf

This docker image installs docker-compose, awscli and terraform on top of the `docker` image.
This is very useful for CI pipelines, which leverage "Docker in Docker".

## Tags explanation
 - **latest**
Include the latest version of each component `docker`, `docker-compose`, `awscli` and `terraform` when the build was made.
Actualy :
 -- `Docker version 18.06.1-ce`
 -- `docker-compose version 1.23.0`
 -- `aws-cli/1.16.44`
 -- `Terraform v0.11.10`

- **other**
The tag structure is : `dockerVersion-composeVersion-awsCliVersion-terraformVersion`
For example the tag `18.06-1.22-1.16-0.11.8` contains :
 -- `Docker version 18.06.1-ce`
 -- `docker-compose version 1.22.0`
 -- `aws-cli/1.16.44`
 -- `Terraform v0.11.8`

- **xxx-noroot**
This image is running with user "docker" (uid:1000 and gid:1000)

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