ARG DOCKER_VERSION=latest
FROM docker:${DOCKER_VERSION}

ARG COMPOSE_VERSION=
ARG AWSCLI_VERSION=
ARG TERRAFORM_VERSION=
ARG NO_ROOT_MODE=
ARG DOCKER_VERSION

ENV NO_ROOT_MODE=${NO_ROOT_MODE:-0}

RUN apk add --update --no-cache py-pip python-dev libffi-dev openssl-dev gcc libc-dev make jq curl openssl git openssh su-exec

RUN pip install --upgrade pip

RUN pip install "docker-compose${COMPOSE_VERSION:+==}${COMPOSE_VERSION}"

RUN pip install "awscli${AWSCLI_VERSION:+==}${AWSCLI_VERSION}"

RUN echo "${TERRAFORM_VERSION}"

RUN if [ "${TERRAFORM_VERSION}" == "" ]; then \
    tfVersion=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version' | tr -d v); \
    else \
    tfVersion="${TERRAFORM_VERSION}"; \
    fi && \
    wget -O terraform.zip https://releases.hashicorp.com/terraform/${tfVersion}/terraform_${tfVersion}_linux_amd64.zip && \
    unzip terraform.zip -d "/usr/bin" && rm terraform.zip

LABEL \
  org.opencontainers.image.description="This docker image installs docker-compose on top of the docker image." \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/pwbdod/docker-compose-aws-tf" \
  org.opencontainers.image.title="Docker Compose on docker base image" \
  org.opencontainers.image.vendor="BauCloud GmbH" \
  org.opencontainers.image.version="${DOCKER_VERSION} with docker-compose ${COMPOSE_VERSION}"

RUN addgroup -S -g 1000 docker && adduser -S -G docker -u 1000 docker

RUN docker --version && \
    docker-compose --version && \
    aws --version && \
    terraform --version

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
