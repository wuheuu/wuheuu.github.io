---
categories: [一些技巧]
tags: socks5 代理 apt-get
---
# 2023.10.30
##  0x01 如何配置apt-get使用socks5代理？
参考链接：
1. [apt-get 使用 socks5 代理](https://linzhanyu.github.io/linux/2019/11/12/apt-proxy.html)
2. [How can i configure a http proxy for apt-get?](https://stackoverflow.com/questions/25322280/how-can-i-configure-a-http-proxy-for-apt-get)

### 1.1 仅命令行一次性使用代理
```bash
sudo apt -o Acquire::socks::proxy="socks5://127.0.0.1:1080/" update
```
### 1.2 一次配置永远享受
```bash
# 添加此行内容至/etc/apt/apt.conf.d/12proxy文件
Acquire::socks::proxy "socks5://127.0.0.1:1080/";
```
> **_Note:_**此处的`127.0.0.1:1080`可更改为相应的`代理服务器:端口号`,如`myproxy.com:10888`
### 1.3 配置国内源和本地源
使用代理的后果就是速度很慢,解决这个问题的方案还是得使用国内源或者自己搭建本地镜像