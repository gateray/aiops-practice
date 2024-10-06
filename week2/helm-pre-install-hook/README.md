# 在template目录下添加pre-install-job.yaml
```
.
├── demo
│   ├── Chart.lock
│   ├── charts
│   │   ├── postgresql-ha-11.9.0.tgz
│   │   └── redis-17.16.0.tgz
│   ├── Chart.yaml
│   ├── templates
│   │   ├── pre-install-job.yaml
│   │   ├── result-deployment.yaml
│   │   ├── result-service.yaml
│   │   ├── vote-deployment.yaml
│   │   ├── vote-service.yaml
│   │   └── worker-deployment.yaml
│   └── values.yaml
└── README.md
```

# 安装helm demo
```
helm upgrade --install --namespace test --create-namespace my-demo demo

Release "my-demo" does not exist. Installing it now.
NAME: my-demo
LAST DEPLOYED: Sat Oct  5 23:03:40 2024
NAMESPACE: test
STATUS: deployed
REVISION: 1
TEST SUITE: None

```

# 验证pre-install-job执行情况
```
kubectl -n test logs my-demo-pre-install-xnvk9 
Start to execute pre install job:
* Chart: vote
* Chart version: 0.1.0
* App version: 0.1.0
* Release: my-demo
```
