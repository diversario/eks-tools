FROM alpine:3.9

RUN apk update \
        && apk add --no-cache \
        curl ca-certificates su-exec py-pip \
        && update-ca-certificates 2>/dev/null || true && \
        curl -L https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 -o /usr/local/bin/gosu && \
        chmod +x /usr/local/bin/gosu && \
        pip install yq awscli

COPY ./get-binaries.sh /get-binaries.sh

RUN /get-binaries.sh

COPY ./exec.sh /exec.sh

ENTRYPOINT ["/exec.sh"]