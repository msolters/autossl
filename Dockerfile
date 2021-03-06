FROM openresty/openresty:1.15.8.3-xenial

RUN luarocks install lua-resty-auto-ssl
RUN mkdir -p /etc/resty-auto-ssl

RUN chown nobody -R /etc/resty-auto-ssl
RUN chown nobody -R /usr/local/openresty/nginx
# Ensure the nginx binary can bind to low ports even as a non-root user
RUN setcap CAP_NET_BIND_SERVICE=+eip /usr/local/openresty/nginx/sbin/nginx

# Generate a fallback self-signed certificate
# This is necessary just for nginx to start up!
RUN \
  openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
  -subj '/CN=sni-support-required-for-valid-ssl' \
  -keyout /etc/ssl/resty-auto-ssl-fallback.key \
  -out /etc/ssl/resty-auto-ssl-fallback.crt

EXPOSE 80
EXPOSE 443
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
