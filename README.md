## MicroMDM (Docker)

Simple docker container for [MicroMDM][1].  MicroMDM is simple to run, as it is contained within a single binary, but I still thought there was a need to have a small docker container that had a bit of intelligence to it.

There are at least 2 folders you would want to map into the container (or use a data container for).  You can easily migrate from a dedicated instance to a dockerized version by pointing the container to your pre-existing folders.

For the `/certs` folder we expect:
```
/certs
  mdm_push_cert.pem
  ProviderPrivateKey.key
```
Rename your APNS files to match above when passing through to the container.  This folder also will contain your own TLS cert and key file if you opt to use one.  The `TLS_CERT` and `TLS_KEY` environment variable should match the name of the file(s) that you places in the `/certs` folder.

You can see the logs of the running container by using `docker logs` for example:
```
docker logs micromdm
```

### Example Usage

```
docker run -d --restart always --name micromdm \
  -e APNS_PASSWORD=secret \
  -e SERVER_URL=https://micromdm.acme.com \
  -e API_KEY=abcdef1234567890 \
  -e TLS_CERT=micromdm.acme.com.crt \
  -e TLS_KEY=micromdm.acme.com.key \
  -e TLS=true \
  -v /root/certs:/certs \
  -v /root/micromdm:/config \
  -v /root/mdmrepo:/repo \
  -p 80:80 \
  -p 443:443 \
  sphen/micromdm
```

### Environment Variables

Variable | Description
--- | ---
API_KEY | Define your API key (Optional)
APNS_PASSWORD | APNS p12 cert password
DEBUG | Set to `true` to enable `-http_debug`
SERVER_URL | Public HTTPS url of your server
TLS | Set to `true` to enable HTTPS (Defaults to False)
TLS_CERT | TLS certificate file name (within mapped /certs directory)
TLS_KEY |TLS private key file name (within mapped /certs directory)

### Mapped Volumes

Path | Description
--- | ---
/certs | Folder containing `mdm_push_cert.pem`, `ProviderPrivateKey.key` and TLS certificates (Optional)
/config | Folder containing micromdm configuration
/repo | Folder for http file repo

### Ports

80, 443, 8080

Ports 80/443 used if TLS enabled.  Otherwise serves on port 8080.

### Ideas

Throw a caddy container in front! :)

[1]: https://micromdm.io
