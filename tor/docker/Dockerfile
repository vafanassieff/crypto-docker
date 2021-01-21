FROM alpine

RUN apk update && \
    apk add tor su-exec shadow bash

RUN addgroup --system tor && \
    addgroup tor tor && \
    userdel guest && \
    groupdel users

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 9050 9051

USER tor

VOLUME [ "/var/lib/tor" ]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "tor" ]
