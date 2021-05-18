# manager配置介绍

### 安装完成后浏览器打开ip:8080 ，默认账号密码：admin admin  

## 1、配置数据源
---
## 阿里RDS到腾讯mysql

1、使用腾讯DTS做全量迁移，迁移完成后停止DTS任务

2、使用otter做双向增量同步
```
# 查看当前binlog文件
show master status

# 导出腾讯DB binlog内容
mysqlbinlog -R -P60118 -hsh-cdb-6r6he2do.sql.tencentcdb.com -umigration -p -v --base64-output=DECODE-ROWS --database=url_project ali_mysql-bin.000002 > tx_mysql-bin.000002.log

# 导出RDS binlog内容
mysqlbinlog -R -hrm-uf652jkcdcip388kv.mysql.rds.aliyuncs.com -umigration -p -v --base64-output=DECODE-ROWS --database=url_project ali_mysql-bin.001714 > ali_mysql-bin.001714.log
```

### 查看腾讯DB tx_mysql-bin.000002.log中迁移的最后一条变更记录，再根据记录去查询阿里RDS  ali_mysql-bin.001714.log中对应的gtdi和position点位信息。

# 设置点位


```
{"postion":{"gtid":"c57c9b8d-cfce-11ea-8263-00163e1893c0:83435690","included":false,"journalName":"mysql-bin.001714","position":26668415,"serverId":17805421,"timestamp":1620783609000}};
```