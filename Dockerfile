#FROM alpine:3.9
FROM argoproj/argocd

USER 0

RUN apt-get update && apt-get install -y curl jq

USER 999

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
