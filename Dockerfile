FROM alpine:3 AS downloader
ARG BUILDARCH
WORKDIR /tmp
# RUN sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirrors.aliyun.com/alpine#g' /etc/apk/repositories
RUN apk --no-cache add tar gzip
RUN url="https://istore.istoreos.com/repo/x86_64/nas/istoreenhance_0.2.6-x86_64-1_x86_64.ipk" && \
    if [ "$BUILDARCH" == "arm64" ]; then \
        url="https://istore.istoreos.com/repo/aarch64_cortex-a53/nas/istoreenhance_0.2.6-aarch64-1_aarch64_cortex-a53.ipk"; \
    fi && \
    wget -O istoreenhance.ipk "$url"
RUN tar -xzvf istoreenhance.ipk && \
    mkdir -p /target && \
    tar -C /target -xzvf data.tar.gz ./usr/sbin

FROM alpine:3
WORKDIR /usr/sbin
COPY --from=downloader /target/usr/sbin/ .
RUN mkdir -p /usr/share/iStoreEnhance
ENV ADMIN_ADDR=:5003
ENV CACHE_PATH=/usr/share/iStoreEnhance
ENV LOCAL_ADDR=:5443
CMD [ "sh", "-c", "iStoreEnhance -adminAddr ${ADMIN_ADDR} -cachePath ${CACHE_PATH} -localAddr ${LOCAL_ADDR}" ]
EXPOSE 5003 5443
VOLUME [ "/usr/share/iStoreEnhance" ]
