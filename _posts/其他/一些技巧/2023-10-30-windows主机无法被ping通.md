---
categories: [一些技巧]
tags: windows ping
---
# 2023-10-30 17:00:06
## 无法ping通
起因是申请了一台公司内网的虚拟机，在其中准备搭建两台ubuntu虚拟机用于metarget测试，但是今天下午才突然发现我的主机ping这台内网虚拟机无法ping通。
### ping超时
![2023-10-30-17-01-59.png](https://s2.loli.net/2023/11/02/GCcvuIy1BwbEhOm.png)
查了很久，说ping超时就是防火墙的问题，但是在查到这些结果之前我就已经将防火墙入站规则中的“文件和打印机共享”ICMP回显打开了。还是不知道为什么会有这个问题。找了很久，发现了这个回答。

参考链接：[解决 ping命令-请求超时 问题](https://blog.csdn.net/Hello_ChenLiYan/article/details/107070460?depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-4-107070460-blog-110955047.235%5Ev38%5Epc_relevant_sort)

一打开立马就可以ping了。！！！
![2023-10-30-17-05-02.png](https://s2.loli.net/2023/11/02/KdGRzJyxN5qPbZ1.png)