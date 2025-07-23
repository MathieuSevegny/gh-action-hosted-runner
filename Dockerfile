FROM ubuntu:22.04

ARG RUNNER_VERSION="2.326.0"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y
RUN apt install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

RUN useradd -m -d /home/runner -s /bin/bash runner \
    && mkdir -p /home/runner/actions-runner \
    && chown -R runner:runner /home/runner/actions-runner

USER runner

WORKDIR /home/runner/actions-runner

RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

USER root
RUN chmod +x ./bin/installdependencies.sh \
    && ./bin/installdependencies.sh
USER runner

COPY start.sh ./start.sh

ENTRYPOINT [ "bash", "start.sh" ]
