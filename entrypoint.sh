#!/bin/sh


#set -e
#set -x

#curl -Lo /usr/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v1.7.8/argocd-linux-amd64
#chmod +x /usr/bin/argocd

# TODO: latesr comment directly on the build and block it if fail
argocd --server $INPUT_SERVER --auth-token "$INPUT_TOKEN" app diff --local $INPUT_PATH $INPUT_APP

echo $?
