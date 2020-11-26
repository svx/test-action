FROM alpine:3.12

# hadolint ignore=DL3018
RUN apk add --no-cache git bash

RUN addgroup -S ocld && adduser -S ocld -G ocld

WORKDIR /find-trailing-whitespace
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
USER ocld
ENTRYPOINT [ "bash" ]
#ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]