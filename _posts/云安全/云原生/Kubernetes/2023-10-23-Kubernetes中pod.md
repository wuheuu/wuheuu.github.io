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
## 0x02 详解pause容器
参考链接:[Kubernetes中的Pause容器到底是干嘛的](https://blog.csdn.net/zfw_666666/article/details/133927653)
### 2.1 前言
在k8s集群内部各个节点上，使用`docker images`查看拉取的镜像会发现存在一个镜像名为`k8s.gcr.io/pause`,如下图：
![2023-11-17-10-14-46.png](https://s2.loli.net/2023/11/17/ghNkJxvjTH9V5BW.png)

使用`docker ps -a`也可以发现每个节点上都有一个名为pause的容器进程。
![2023-11-17-10-19-36.png](https://s2.loli.net/2023/11/17/q6sL2xeB3tZfgi7.png)

这就是pause容器，也称为infra容器，pause容器使用的镜像文件非常小，由于它总是处于pause状态，因此起名为pause

### 2.2 pause容器的作用
1. 网络命名空间隔离：Pod是Kubernetes中最小的调度单元，可以包含一个或多个容器。为了实现容器之间的网络隔离，每个Pod都有自己独立的网络命名空间。Pause容器负责创建并维护这个网络命名空间，其他容器共享这个网络命名空间，使它们能够相互通信，而不会与其他Pod中的容器发生冲突。

2. 进程隔离：Pause容器保持一个轻量级的进程运行，即使Pod中的其他容器都停止了。这个进程实际上不执行任何有用的工作，但它的存在确保了Pod不会在没有容器运行的情况下被删除。当其他容器停止时，Pause容器仍在运行，以维持Pod的生命周期。

3. 资源隔离：尽管Pause容器通常不分配大量的CPU和内存资源，但它可以配置以使用一些资源。这有助于确保即使Pod中没有其他容器运行时，Kubernetes仍然可以监控和管理Pod的资源使用情况。这也有助于防止Pod被其他具有相同资源要求的Pod占用。

4. IP地址维护：Pause容器负责维护Pod的IP地址。Pod的IP地址通常是动态分配的，但由于Pause容器一直在运行，它可以维护Pod的IP地址，以便其他容器可以通过该地址进行通信。这有助于确保Pod的IP地址在整个Pod的生命周期内保持一致。

5. 生命周期管理：Pause容器的生命周期与Pod的生命周期相同。当Pod创建时，Pause容器被创建；当Pod删除时，Pause容器也会被删除。这确保了Pod的整个生命周期都由Kubernetes进行管理，包括创建、扩展、缩放和删除。
### 2.3 pause容器工作原理
![2023-11-17-10-23-02.png](https://s2.loli.net/2023/11/17/Lb1UoGFe2mSa3zh.png)
比如说现在有一个 Pod，其中包含了一个容器 A 和一个容器 B，它们两个就要共享 Network Namespace。在 Kubernetes 里的解法是这样的：它会在每个 Pod 里，额外起一个 Infra container 小容器来共享整个 Pod 的 Network Namespace。Infra container 是一个非常小的镜像，大概 683kB，是一个C语言写的、永远处于“暂停”状态的容器。由于有了这样一个 Infra container 之后，其他所有容器都会通过 Join Namespace 的方式加入到 Infra container 的 Network Namespace 中。所以说一个 Pod 里面的所有容器，它们看到的网络视图可以说是完全一样的。即：它们看到的网络设备、IP地址、Mac地址等等，跟网络相关的信息，其实全是一份，这一份都来自于 Pod 第一次创建的这个 Infra container。这就是 Pod 解决网络共享的一个解法。在 Pod 里面，一定有一个 IP 地址，是这个 Pod 的 Network Namespace 对应的地址，也是这个 Infra container 的 IP 地址。所以大家看到的都是一份，而其他所有网络资源，都是一个 Pod 一份，并且被 Pod 中的所有容器共享。这就是 Pod 的网络实现方式。由于需要有一个相当于说中间的容器存在，所以整个 Pod 里面，必然是 Infra container 第一个启动。并且整个 Pod 的生命周期是等同于 Infra container 的生命周期的，与容器 A 和 B 是无关的。这是非常重要的一个设计。kubernetes的pause容器主要为每个业务容器提供两个核心功能：

第一，它提供整个pod的Linux命名空间的基础。

第二，启用PID命名空间，它在每个pod中都作为PID为1的进程，并回收僵尸进程。