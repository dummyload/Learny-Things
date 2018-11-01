FROM alpine:3.7

RUN apk add --no-cache redis bash

ADD ./redis /redis

# CMD while true; do sleep 10; done
CMD /redis/run.sh
