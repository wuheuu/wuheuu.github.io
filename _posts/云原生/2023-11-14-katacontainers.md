---
categories: [云原生]
tags: katacontainers
---

# 2023-11-14 17:03:29

参考链接：[kata-container 介绍与原理](https://blog.csdn.net/zhonglinzhang/article/details/86489695)

参考视频：[Escaping Virtualized Containers](https://www.youtube.com/watch?v=0hrv0qyOEd0)

## 0x01 为什么使用 katacontainers?

弥补了传统容器技术安全性的缺点，Kata Containers 通过使用硬件虚拟化来达到容器隔离的目的。每一个 container/pod 都是基于一个独立的 kernel 实例来作为一个轻量级的虚拟机。自从每一个 container/pod 运行与独立的虚拟机上，他们不再从宿主机内核上获取相应所有的权限。

## 0x02 什么是 katacontainers?

是一种安全容器的体现，能够将虚拟机的强隔离性和容器的轻量级和富生态结合起来，，核心思想是为每一个容器运行一个虚拟机，避免与宿主机共享内核。从 docker 架构上看，katacontainer 和原本的 runc 是平级的，因此可以作为 docker 的插件使用，启动 katacontainer 也可以通过 docker 命令。使用此命令指定 katacontainer: `docker run --runtime=kata ubuntu bash`。具体流程如下：
![2023-11-14-17-48-59.png](https://s2.loli.net/2023/11/17/7C9eH8cIPxDNAQ4.png)

特点如下：

1. Virtualized Containers
2. Encapsulates each container inside a lightweight VM
3. Simple way to sandbox containers
   1. compatible runtime for docker & kubernetes

![2023-11-14-17-35-23.png](https://s2.loli.net/2023/11/17/H5nzEapdheAPZku.png)

### 2.1 在什么情况下使用 kata containers?

1. untrusted or targeted workloads
2. multi-tenant environments(多租户环境)
3. cloud service providers

## 0x03 katacontainers 组件及架构

![2023-11-14-18-02-35.png](https://s2.loli.net/2023/11/17/1OkyUSIaVEPvnlJ.png)

1. runtime：容器运行时，负责处理来字 docker 引擎或 Kubernetes 等上层命令，以及启动 kata-shim，程序名称为**kata-runtime**。
2. agent：运行在虚拟机中，与 runtime 交互，用于管理容器及容器内进程，程序名为**kata-agent**。
3. proxy：负责宿主机与虚拟机之间的通信(对 shim、runtime 及 agent 之间的 I/O 流及信号进行路由)，如果宿主机内核支持 vsock，则 proxy 是非必要的，程序名为**kata-proxy**。
4. shim：容器进程收集器，用来监控容器进程并收集、转发 I/O 流及信号，程序名为**kata-shim**。
5. hypervisor：虚拟机监视器，负责虚拟机的创建、运行、销毁等管理，有多种选择，如 QEMU、Cloud Hypervisor 等
6. 虚拟机：由高度优化过的内核和文件系统镜像文件创建而来，负责为容器提供一个更强的隔离环境。

## 0x04 容器逃逸
### 4.1 常见的脆弱点
![2023-11-15-09-37-35.png](https://s2.loli.net/2023/11/17/qZkdHMKGYn4lLJI.png)
在创建容器的过程中，一般存在以上流程，其中第一步为引擎(如docker)生成将所需的安全配置发送给运行时,运行时根据此引擎创建容器，最终执行容器。容器逃逸的关键点就在于这整个过程中。主要存在以下两个问题：
1. 【容器运行时的问题】容器化进程的初始化,容器运行时可能使用不受信任的变量来初始化容器，如不受信任的容器镜像，或者创建容器时执行的命令。
2. 【容器引擎的问题】运行容器的权限没有足够的限制，可能会出现新的突破技巧来进行逃逸
### 4.2 kata会修改容器配置
![2023-11-15-10-14-53.png](https://s2.loli.net/2023/11/17/eVjCkZhOrN6mQsY.png)
1. kata会舍弃某些cgroup
   1. 宿主机和虚拟机存在不同的硬件资源
   2. 有一些cgroup对虚拟机来说没有意义，如blkio.device
2. cgroup主要是防止拒绝服务攻击，针对虚拟机的容器拒绝服务攻击并不是一个问题
### 4.3 Device Cgroup
#### 4.3.1
1. 限制容器对虚拟机设备的访问
2. Kata没有限制这一点
3. 关键点出现：硬盘！
#### 4.3.2 怎样访问硬盘设备？
![2023-11-15-10-28-46.png](https://s2.loli.net/2023/11/17/87OpkeBWqydNoHl.png)
