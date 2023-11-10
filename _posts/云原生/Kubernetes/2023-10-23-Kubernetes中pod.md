---
categories: [Kubernetes]
tags: Kubernetes pod 云原生
---
# 2023.10.23
参考链接：[Kubernetes中Pod介绍](https://blog.csdn.net/faoids/article/details/130678297)
## 0x01 Pod是什么
- K8s中的最小管理单元
- 容器在Pod中，pod只是一个逻辑上的概念，实际由一个或多个容器组成（多个容器：当多个容器之间需要共享存储、网络等时使用）
> **_Note:_**可以将pod看作虚拟机，每个容器相当于运行在虚拟机的进程
### 1.1 pod如何管理多个容器
- 同一个pod中的容器会自动被分配到同一个node上
- 同一个pod中的容器共享资源、网络环境
#### 1.1.1 k8s容器类型
参考链接：[Kubernetes容器类型Init-pause-sidecar-app容器](https://blog.csdn.net/lpfstudy/article/details/131620791)
1. Init初始化容器
   
   与常规应用容器相同，但必须在应用容器启动前运行完成
2. Pause基础容器

    作为init pod存在，其他pod都会从pause容器中fork出来。这是在创建一个pod时，最先创建的容器。
    > 1. 每个Pod里运行着一个特殊的被称之为Pause的容器，其他容器则为业务容器，这些业务容器共享Pause容器的网络栈和Volume挂载卷
    > 2. 因此他们之间通信和数据交换更为高效，在设计时我们可以充分利用这一特性将一组密切相关的服务进程放入同一个Pod中。
    > 3. 同一个Pod里的容器之间仅需通过localhost就能互相通信。
    > **_Note:_**pause容器作用：
    1. 在单个Pod中协调多个容器之间的生命周期。当一个Pod中有多个容器时，这些容器可以通过"Pause"容器来实现同步启动、重启和关闭等操作。"Pause"容器的运行状态会直接影响整个Pod的生命周期
    2. 通过"Pause"容器实现网络和命名空间的共享。Kubernetes中的Pod共享相同的网络和命名空间，这要求容器在同一个网络和命名空间中运行。"Pause"容器充当了这个角色，确保Pod中的其他容器能够正确地共享网络和命名空间。
3. sidecar容器：与应用容器共享同一个pod的辅助容器（app容器的配角），提供额外的功能和资源，以增强或扩展主要应用容器的功能
   1. 日志收集和处理
   2. 监控和指标收集
   3. 身份验证和授权
   4. 代理和负载均衡
4. app容器：跑业务代码的容器
## 0x02 pod网络
pod有ip地址，可以在初始化k8s集群时通过`--cluster-cidr`参数控制pod ip cidr网段，所有动态分配的ip都会落在此网段内。
## 0x03 Pod生命周期
1. Pending(挂起)：apiserver已经创建了pod资源对象，但它尚未被调度完成或者仍处于下载镜像的过程中
2. Running(运行中)：pod已经被调度至某节点，并且所有容器都已经被kubelet创建完成
3. Succeded(成功)：pod中的所有容器都已经成功终止并且不会被重启
4. Failed(失败)：所有容器都已经终止，但至少有一个容器终止失败，即容器返回了非0值的退出状态
5. Unknown(未知)：apiserver无法正常获取到pod对象的状态信息，通常由网络通信失败所导致