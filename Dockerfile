ARG DOCKER_VERSION=latest
FROM docker:${DOCKER_VERSION}

ARG COMPOSE_VERSION=
ARG DOCKER_VERSION
ARG TERRAFORM_VERSION

RUN apk add --update --no-cache py-pip jq curl openssl git openssh make
RUN pip install "docker-compose${COMPOSE_VERSION:+==}${COMPOSE_VERSION}"
RUN pip install awscli
RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
      unzip terraform.zip -d "/usr/bin" && rm terraform.zip

LABEL \
  org.opencontainers.image.description="This docker image installs docker-compose on top of the docker image." \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/pwbdod/docker-compose-aws-tf" \
  org.opencontainers.image.title="Docker Compose on docker base image" \
  org.opencontainers.image.vendor="BauCloud GmbH" \
  org.opencontainers.image.version="${DOCKER_VERSION} with docker-compose ${COMPOSE_VERSION}"
