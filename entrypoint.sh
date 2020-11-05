#!/bin/sh


#set -e
set -x

#curl -Lo /usr/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v1.7.8/argocd-linux-amd64
#chmod +x /usr/bin/argocd

# TODO: latesr comment directly on the build and block it if fail
df=$(argocd --insecure --server $INPUT_SERVER --auth-token "$INPUT_TOKEN" app diff --local $INPUT_PATH $INPUT_APP)

if [ $? -gt 0 ]; then
  echo "presenting diff"
  echo "$df"

  pull_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")

  curl -XPOST -H "Authorization: Bearer $INPUT_GITHUB_TOKEN" $GITHUB_API_URL/repos/$GITHUB_REPOSITORY/issues/$pull_number/comments --data "{\"body\": \"ArgoCD Diff: \n\`\`\`diff\n$df\n\`\`\`\"}"
fi
