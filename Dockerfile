FROM alpine:edge

# Add the testing repository where 'gost' and 'wgcf' are available
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Install wireguard-tools, gost, and wgcf from the testing repository
RUN apk update && apk add --no-cache wireguard-tools gost wgcf ip6tables

VOLUME /etc/wireguard

# Set the entrypoint to create wg0.conf using wgcf if it doesn't exist, and bypass the interactive prompt
ENTRYPOINT ["/bin/sh", "-c", "if [ ! -f /etc/wireguard/wg0.conf ]; then echo 'yes' | wgcf register && wgcf generate && mv wgcf-profile.conf /etc/wireguard/wg0.conf && echo 'wg0.conf generated'; fi && wg-quick up wg0 && gost -L=:8080"]

