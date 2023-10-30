---
categories: [Kubernetes]
tags: Kubernetes APIServer
---
# 2023.10.24
参考链接：[API Server简介](https://blog.csdn.net/u010453704/article/details/110701789)
##  0x01 概念理解
k8s API Server提供了k8s各类资源对象（pod，RC，Service等）的增删改查及watch等HTTP Rest接口，是整个系统的数据总线和数据中心。
![2023-10-24-17-21-50.png](https://s2.loli.net/2023/10/27/QK6f18H4CahIuOS.png)
### 1.1 功能
1. 提供了集群管理的REST API接口(包括认证授权、数据校验以及集群状态变更)；
2. 提供其他模块之间的数据交互和通信的枢纽（其他模块通过API Server查询或修改数据，只有API Server才直接操作etcd）;
3. 提供准入控制的功能；
4. 拥有完备的集群安全机制.
![2023-10-24-17-38-55.png](https://s2.loli.net/2023/10/27/VHeqYuZBWDOG3cE.png)
