# autossl
This repo provides a containerized implementation of the [lua-resty-auto-ssl](https://github.com/GUI/lua-resty-auto-ssl) plugin.  The `Dockerfile` builds a version of `openresty` which has that plugin added.

The end result is an `nginx` container which provides the ability to automatically acquire TLS certs for incoming requests on-the-fly.

Included is also a skeleton example of how to create a barebones k8s deployment that uses the reverse proxy correctly.

## Building
The `autossl` image itself can be built and released with:

```
make build
make release
```

Note that you must update `base` variable inside the `Makefile`.
