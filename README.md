# muellplan_de

> A website/app where the next collection dates for different litter types can be checked (region Landshut in Bavaria).

### current limitations and future plans
#### limitations

- only available as web-app/website
- no responsive design

#### future plans
- responsive design
- create apps for desktop and mobile devices

## setup

### prerequisites
You need to have an instance of [muellplan_de-backend](https://github.com/TechBoltLabs/muellplan_de-backend) running.

### Docker

1. set up a docker image with the following command:

```bash
docker build -t muellplan_de:latest .
```

2. adjust the file compose.yml to your needs and start the container with:

```bash
docker-compose up -d
```

### native

1. build the app for the web:

```bash
flutter build web
```

2. start any webserver in the build/web directory

```bash
cd build/web
python3 -m http.server 8000
```


