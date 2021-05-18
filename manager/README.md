# otter manager
## docker运行
## 构建镜像
```
docker build --no-cache=true -t otter-manager:4.2.18 .
```
## OTTER_DOMAINNAME otter-manager访问地址
## OTTER_DATABASE_URL 数据库地址及库名，提前创建并赋权
```
执行manager定义sql
wget https://raw.github.com/alibaba/otter/master/manager/deployer/src/main/resources/sql/otter-manager-schema.sql
source otter-manager-schema.sql
```
## OTTER_ZOOKEEPER_CLUSTER   zk集群地址，集群提前创建
```
docker run --rm -it -e OTTER_ZOOKEEPER_CLUSTER="192.168.1.10:2181" -e OTTER_DOMAINNAME="192.168.1.10" -e OTTER_DATABASE_URL="192.168.1.10:3306/otter" -e OTTER_DATABASE_USERNAME="root" -e OTTER_DATABASE_PASSWORD="hello123" otter-manager:4.2.18

```