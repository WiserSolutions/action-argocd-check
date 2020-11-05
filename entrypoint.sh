#!/bin/sh
set -x

# TODO: latesr comment directly on the build and block it if fail
df=$(argocd --insecure --server $INPUT_SERVER --auth-token "$INPUT_TOKEN" app diff --local $INPUT_PATH $INPUT_APP 2>&1)

export res=$?

echo "Result: $res"

if [ $res -gt 0 ]; then
  echo "presenting diff"
  echo "$df"

  export pull_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")

  curl -XPOST -H "Authorization: Bearer $INPUT_GITHUB_TOKEN" \
    $GITHUB_API_URL/repos/$GITHUB_REPOSITORY/issues/$pull_number/comments --data \
    "$(jq --arg d "$df" -n '{ body: ("ArgoCD Diff\n```diff\n" + $d + "\n```") }')"
fi
