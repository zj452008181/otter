# otter node
## docker运行
## 构建镜像
```
docker build --no-cache=true -t otter-node:4.2.18 .
```
## 运行otter-node
## OTTER_MANAGER_ADDRESS  manager地址
## NID 提前在manager管理页面上创建，每个node节点NID唯一
## node端口已manager上配置为准。如manager配置node节点信息为端口：12088，node使用docker启动端口映射需要配置为12088:12088，其他端口同理。
```
docker run --rm -it -e NID="3" -e OTTER_MANAGER_ADDRESS="10.0.7.36:1099" registry.cn-shanghai.aliyuncs.com/huanjutang/otter-node:4.2.18-v2

```
