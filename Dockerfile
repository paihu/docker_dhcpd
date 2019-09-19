FROM alpine:3.10.2 as build

WORKDIR /
RUN apk add gcc make autoconf file musl-dev linux-headers git

RUN git clone https://gitlab.isc.org/isc-projects/dhcp
WORKDIR /dhcp

RUN ./configure
RUN make 
RUN make install

FROM alpine:3.10.2
RUN  apk add --no-cache  libgcc
COPY --from=build /usr/local/  /usr/local/
RUN mkdir /var/db/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 67/udp

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

