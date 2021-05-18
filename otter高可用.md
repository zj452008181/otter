## manager
### manager挂掉不影响otter双向同步
---

## node高可用
### otter-4.2.18版本，manager界面无法选择多个node，要满足node高可用需要手动修改数据库。如现有两个node，ID为1，2；创建双向同步pipeline时，select节点选择只能二选一，load节点选择也只能二选一，先任选一个节点，创建好两个pipeline后，数据库PIPELINE_NODE_RELATION表插入数据。

```
INSERT into PIPELINE_NODE_RELATION VALUES('null','1','1','SELECT',NOW(),NOW());
INSERT into PIPELINE_NODE_RELATION VALUES('null','2','1','SELECT',NOW(),NOW());
INSERT into PIPELINE_NODE_RELATION VALUES('null','1','1','EXTRACT',NOW(),NOW());
INSERT into PIPELINE_NODE_RELATION VALUES('null','2','1','EXTRACT',NOW(),NOW());
INSERT into PIPELINE_NODE_RELATION VALUES('null','1','1','LOAD',NOW(),NOW());
INSERT into PIPELINE_NODE_RELATION VALUES('null','2','1','LOAD',NOW(),NOW());
INSERT into PIPELINE_NODE_RELATION VALUES('null','1','2','SELECT',NOW(),NOW());
INSERT into PIPELINE_NODE_RELATION VALUES('null','2','2','SELECT',NOW(),NOW());
INSERT into PIPELINE_NODE_RELATION VALUES('null','1','2','EXTRACT',NOW(),NOW());
INSERT into PIPELINE_NODE_RELATION VALUES('null','2','2','EXTRACT',NOW(),NOW());
INSERT into PIPELINE_NODE_RELATION VALUES('null','1','2','LOAD',NOW(),NOW());
INSERT into PIPELINE_NODE_RELATION VALUES('null','2','2','LOAD',NOW(),NOW());
```
### 修改后结果如下，每个pipeline的select、load、extract都对应两个node
```
SELECT * FROM PIPELINE_NODE_RELATION WHERE PIPELINE_ID=1;

+----+---------+-------------+----------+---------------------+---------------------+
| ID | NODE_ID | PIPELINE_ID | LOCATION | GMT_CREATE          | GMT_MODIFIED        |
+----+---------+-------------+----------+---------------------+---------------------+
| 19 |       1 |           1 | SELECT   | 2021-04-27 07:32:54 | 2021-04-27 07:32:54 |
| 20 |       2 |           1 | SELECT   | 2021-04-27 07:33:36 | 2021-04-27 07:33:36 |
| 21 |       1 |           1 | EXTRACT  | 2021-04-27 07:36:06 | 2021-04-27 07:36:06 |
| 22 |       2 |           1 | EXTRACT  | 2021-04-27 07:36:11 | 2021-04-27 07:36:11 |
| 23 |       1 |           1 | LOAD     | 2021-04-27 07:36:58 | 2021-04-27 07:36:58 |
| 24 |       2 |           1 | LOAD     | 2021-04-27 07:36:58 | 2021-04-27 07:36:58 |
+----+---------+-------------+----------+---------------------
```