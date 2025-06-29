#!/bin/bash

ORG=$ORG
ACCESS_TOKEN=$TOKEN

cd /home/runner/actions-runner

REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/orgs/${ORG}/actions/runners/registration-token | jq .token --raw-output)

./config.sh --unattended --url https://github.com/${ORG} --token ${REG_TOKEN} || $true

cleanup() {
echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!