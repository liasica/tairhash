FROM alpine as builder
RUN apk --no-cache add git cmake clang clang-dev make gcc g++ libc-dev linux-headers
RUN git clone https://github.com/tair-opensource/TairHash.git && \
    mkdir TairHash/build && \
    cd TairHash/build && \
    cmake -DSLAB_MODE=yes ../ && \
    make -j

FROM redis:alpine
COPY --from=builder /TairHash/lib/tairhash_module.so /var/lib/redis/tairhash_module.so
COPY redis.conf /usr/local/etc/redis/redis.conf
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
