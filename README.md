

### 切到根目录构建镜像
```
docker build -t eurekaserver:0.1.0 .
```

### 运行
```
// --name指定容器名；--rm容器退出时，删除该容器
// --cpus限制最大的cpu核数，--memory限制最大的内存数，-p暴露容器端口到本机端口
docker run   -p 8000:8000  --name eurekaserver --rm  -it eurekaserver:0.1.0
```

### 进入容器
```
docker exec -it eurekaserver sh
```