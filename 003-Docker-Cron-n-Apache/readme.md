# Docker (initial into)

### Goal

Run `httpd` + `cron` simultaneity in container.

### Starting Up and Teest

```bash
# Container Build
> docker build -t devops/httpd .
> docker run -itd -v $(pwd):/var/log/ -p "8080:8080" devops/httpd

# Checking httpd
curl localhost:8080 && tail httpd-access.log

# Checking Cron
> tail -f cron.log
```

### Thanks
[muralindia](https://github.com/muralindia) for tip about `supervisord`
