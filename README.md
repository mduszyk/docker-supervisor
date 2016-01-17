
## Examples:
- centos supervisor container with sshd
```bash
docker run \
     --name supervisor-centos \
     --hostname supervisor-centos \
     -e "SSHD=true" \
     -e "ROOT_PASS=secret123" \
     -p 2222:22 \
     -v `pwd`/log:/var/log \
     -v `pwd`/data:/mnt/data \
     -d mdevel/supervisor-centos
```

- ubuntu supervisor container with sshd and cron
```bash
docker run \
     --name supervisor-ubuntu \
     --hostname supervisor-ubuntu \
     -e "SSHD=true" \
     -e "CRON=true" \
     -e "ROOT_PASS=secret123" \
     -p 2222:22 \
     -v `pwd`/log:/var/log \
     -v `pwd`/data:/mnt/data \
     -d mdevel/supervisor-ubuntu
```
