FROM alpine:3.3

ENV MICROMDM_VERSION=1.6.0
ENV PATH="/:${PATH}"

COPY run.sh /run.sh

RUN apk --no-cache add curl && \
    curl -L https://github.com/micromdm/micromdm/releases/download/v${MICROMDM_VERSION}/micromdm_v${MICROMDM_VERSION}.zip -o /micromdm.zip && \
    unzip /micromdm.zip && \
    rm -f /micromdm.zip && \
    mv /build/linux/micromdm / && \
    rm -r /build && \
    chmod a+x /micromdm && \
    apk del curl && \
    mkdir /config /certs /repo && \
    chmod a+x /run.sh

EXPOSE 80 443 8080

VOLUME ["/config","/certs","/repo"]

CMD ["/run.sh"]
