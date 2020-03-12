FROM alpine

RUN apk update && \
    apk add tor su-exec shadow

RUN addgroup --system tor && \
    addgroup tor tor && \
    userdel guest && \
    groupdel users

RUN echo $'SOCKSPort 9050\n\
Log notice stdout\n\
ControlPort 9051\n\
CookieAuthentication 1' > /etc/tor/torrc

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 9050 9051

VOLUME [ "/var/lib/tor" ]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "tor" ]
