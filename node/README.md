# otter node
## docker运行
## 构建镜像
```
docker build --no-cache=true -t otter-node:4.2.18 .
```
## 运行otter-node
## OTTER_MANAGER_ADDRESS  manager地址
## NID 提前在manager管理页面上创建，每个node节点NID唯一
```
docker run --rm -it -e NID="1" -e OTTER_MANAGER_ADDRESS="192.168.1.10:1099" otter-node:4.2.18

```
