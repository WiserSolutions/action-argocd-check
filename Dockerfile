#FROM alpine:3.9
FROM argoproj/argocd:v1.7.8

#RUN apk add --no-cache curl

RUN apt-get update && apt-get install -y curl

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
