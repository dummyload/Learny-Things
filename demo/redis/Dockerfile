FROM redis:alpine3.8

RUN apk add --no-cache bash

ADD ./redis /redis

# CMD while true; do sleep 10; done
CMD /redis/run.sh
