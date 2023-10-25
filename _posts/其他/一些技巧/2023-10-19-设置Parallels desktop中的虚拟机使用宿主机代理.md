---
categories: [一些技巧]
tags: 代理 虚拟机 ParallelsDesktop
---
# 2023.10.19
参考链接：[设置Parallels Desktop中的虚拟机使用宿主机代理](https://blog.csdn.net/u011195398/article/details/85791354)
## 原理

[{Post:虚拟机三种网络模式]({% post_url 2023-10-19-虚拟机三种网络模式 %})

## 设置代理
### Ubuntu主机
- 系统为MacOS，使用的代理软件为[MonoProxy](https://storage.monocloud.co/client/MacOS/MonoProxyMac%200.7.2.dmg)，参考使用手册:[使用手册](https://mymonocloud.com/knowledgebase/11)。其他代理软件的设置也类似。
1. 在宿主机上设置代理客户端**允许局域网访问**
   1. 设置HTTP代理监听地址为`0.0.0.0`，端口不需要更改。
   2. 设置SOCKS5代理监听地址为`0.0.0.0`，端口不需要更改。
   ![2023-10-19-11-44-51.png](https://s2.loli.net/2023/10/19/BiCw5tcbQXVzjyF.png)
2. 设置虚拟机的网络连接模式为`桥接模式`，让虚拟机和宿主机近似连接在同一个交换机上，处于同一个LAN中。
    ![2023-10-19-11-50-15.png](https://s2.loli.net/2023/10/19/3bs9Y7ujUgc2d4Q.png)
3. 查看虚拟机IP地址
    ![2023-10-19-11-50-59.png](https://s2.loli.net/2023/10/19/EJ3kR2pgbHsxSho.png)
4. 核对宿主机IP地址
    ![2023-10-19-11-51-32.png](https://s2.loli.net/2023/10/19/5swFknB1lyGjiIh.png)
5. 设置虚拟机网络代理
    ![2023-10-19-11-56-23.png](https://s2.loli.net/2023/10/19/hYcLORJZrdDvQbS.png)
6. 大功告成！
    ![2023-10-19-11-57-13.png](https://s2.loli.net/2023/10/19/zHM6i43AlSFqTga.png)

### Windows主机
原理与上类似，需要再次确认monoProxy客户端中的config中监听地址是否仍为0.0.0.0，若发生改变，需要更改回这个值。

前往该页面，将代理服务器相关设置改为如图，即可完成代理设置。
![](2023-10-25-10-11-48.png)