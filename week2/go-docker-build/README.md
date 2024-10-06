# 目录结构：
```
.
├── client
│   ├── Dockerfile
│   └── tcp_client.go
├── Makefile
├── README.md
└── server
    ├── Dockerfile
    └── tcp_server.go
```

# 构建docker镜像
```
# 构建所有镜像
make docker-build
# 构建tcp_server镜像
make docker-build-server
# 构建tcp_client镜像
make docker-build-client
# 构建镜像时指定tag
DOCKER_TAG=v1.0 make docker-build
```
