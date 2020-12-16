#!/bin/bash
#set -x

export KUBECTL_EXTERNAL_DIFF="diff -u"

# first request is to establish 
info=$(argocd --insecure --server $INPUT_SERVER --auth-token "$INPUT_TOKEN" app get $INPUT_APP -ojson)

local_path=$(jq -r .spec.source.path <<< $info)

# TODO: latesr comment directly on the build and block it if fail
df=$(argocd --insecure --server $INPUT_SERVER --auth-token "$INPUT_TOKEN" app diff --local $local_path $INPUT_APP 2>&1)

export res=$?

echo "Result: $res"

export pull_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")

if [ $res -eq 20 ]; then
  echo "argocd failed $df"

  curl -XPOST -H "Authorization: Bearer $INPUT_GITHUB_TOKEN" \
    $GITHUB_API_URL/repos/$GITHUB_REPOSITORY/issues/$pull_number/comments --data \
    "$(jq --arg d "$df" -n '{ body: ("**ArgoCD Failure**\n```\n" + $d + "\n```") }')"

  # exit with error to prevent merging
  exit 1
fi

if [ $res -eq 1 ]; then
  echo "presenting diff"
  echo "$df"

  curl -XPOST -H "Authorization: Bearer $INPUT_GITHUB_TOKEN" \
    $GITHUB_API_URL/repos/$GITHUB_REPOSITORY/issues/$pull_number/comments --data \
    "$(jq --arg d "$df" -n '{ body: ("**ArgoCD Diff**\n```diff\n" + $d + "\n```") }')"
fi
