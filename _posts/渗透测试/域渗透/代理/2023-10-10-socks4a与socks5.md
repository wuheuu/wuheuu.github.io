---
categories: [渗透测试]
tags: 代理 SOCKS
---

# 2023.10.10

## 0x01 SOCKS4、SOCKS4a与SOCKS5
SOCKS和socks（袜子）一样，用来代替客户端和服务端进行连接，即代理协议

> **_Note:_**[ref-link](https://zhuanlan.zhihu.com/p/439451917?utm_id=0)

SOCKS在OSI七层协议的第五层，也就是Session layer（会话层）中，它处于Presentation layer（表示层）和Transport layer（传输层）的中间。传输层的主要协议是TCP/UDP，因此SOCKS底层就是TCP和UDP协议。
![2023-10-12-10-20-39.png](https://s2.loli.net/2023/10/27/vNcSBaDjXHrYRzo.png)
作为一个代理协议，SOCKS可以提供**基于TCP和UDP的代理**，相较于HTTP的代理而言，SOCKS的代理更加底层，所以应用场景也会更多。

> **_Note:_**由于SOCKS运行在会话层上，因此能代理**TCP、UDP本身**以及**基于它们之上的协议，例如`http/https over tcp，http3 over udp(quic)`**，但无法代理**icmp协议**，因为icmp协议是网络层协议（3层），因此通过SOCKS无法ping通谷歌，不要觉得是代理软件或节点的问题，是你的问题!!!!

通常来说，SOCKS的标准端口是1080。

> **_Note:_**SOCKS最为广泛使用的两个协议版本：4和5。
> - SOCKS4：没有关于安全方面的约定
> - SOCKS5：最初是一种使防火墙和其他安全产品更易于管理的安全协议。

### 1.1 SOCKS4
#### 请求包
VER|CMD|DSTPORT|DSTIP|ID
|-|-|-|-|-|
- VER：占用1个字节，表示的是SOCKS协议的版本号，对于SOCKS4来说，这个值是0x04。
- CMD：占用1个字节，表示的是要执行命令的代码，有两个选择，其中0x01 表示建立一个TCP/IP 流连接，0x02表示建立一个TCP/IP端口绑定。
- DSTPORT：占用2个字节，表示目标端口号。
- DESTIP：占用4个字节，表示的是IPv4地址。
- ID：占用字节不定，表示的是用户ID。
#### 返回数据包
VN|REP|DSTPORT|DSTIP
|-|-|-|-|
- VN：0个字节，表示是返回的消息的版本。
- REP：1个字节，表示返回的code(0x5A、0x5B、0x5C、0x5D)：
    code|含义
    |-|-|
- DSTPORT：两个字节，表示目的地的端口，如果没有绑定的话，则为空。
- DSTIP：4个字节，表示客户端绑定的目的地的IP地址。
> **_Note:_**eg：客户端想使用SOCKS4从Fred连接到66.102.7.99:80，请求如下:
> 0x04 | 0x01 | 0x00 0x50 | 0x42 0x66 0x07 0x63 | 0x46 0x72 0x65 0x64 0x00
> |-|-|-|-|-|
> 
> 最后一个字段表示Fred的ASCII编码
> 如果客户端回复**OK**，则响应包如下：
>  0x00 | 0x5A | 0xXX 0xXX | 0xXX 0xXX 0xXX 0xXX
> |-|-|-|-|
>
> 当连接建立完毕，所有的SOCKS客户端到SOCKS服务器端的请求都会转发到66.102.7.99。

### 1.2 SOCKS4a
SOCKS4只能指定**目的服务器的IP地址**，这对应服务器有多个IP的情况下会有很严重的限制。所以SOCK4a对SOCK4进行了扩展，可以支持目标服务器的域名。
#### 请求包
在SOCKS4请求包最后加入了**DOMAIN**字段。
VER|CMD|DSTPORT|DSTIP|ID|DOMAIN
|-|-|-|-|-|-|

DOMAIN表示的是要连接到的目标服务器的域名。使用null (0x00)来结尾。对应的DSTIP的前三个字节设置为NULL，最后一个字节设置成一个非0的值。

服务端响应与SOCK4相同。

### 1.3 SOCKS5
虽然SOCKS5是SOCKS的最新版本，但是SOCKS5和SOCKS4是不兼容的。SOCKS5支持认证，并且提供了对IPv6和UDP的支持。其中UDP可以用来进行DNS lookups。它的交互流程如下所示：
1. 客户端和服务器端进行连接，并发送一个greeting消息，同时包含了支持的认证方法列表。
2. 服务器端选择一个支持的认证方法，如果都不支持，则发送失败响应。
3. 根据选中的认证方法，客户端和服务器进行后续的认证交互，交互流程跟选中的认证方法相关。
4. 客户端以SOCKS4相似的方式发送连接请求。
5. 服务器端发送和SOCKS4相似的响应。

#### greeting消息格式

VER|NAUTH|AUTH
|-|-|-|
- VER：1个字节表示SOCKS的版本号，这里是0x05。
- NAUTH：1个字节，表示支持的认证方法的个数。
- AUTH：可变字节，表示的是支持的认证方法。一个字节表示一个方法，支持的方法如下：
  ```
  0x00: 没有认证
    0x01: GSSAPI 
    0x02: 用户名/密码 (RFC 1929)
    0x03–0x7F: methods assigned by IANA
        0x03: Challenge-Handshake Authentication Protocol
        0x04: 未分配
        0x05: Challenge-Response Authentication Method
        0x06: Secure Sockets Layer
        0x07: NDS Authentication
        0x08: Multi-Authentication Framework
        0x09: JSON Parameter Block
        0x0A–0x7F: 未分配
    0x80–0xFE: 内部使用的保留方法
  ```
#### 响应包
VER|CAUTH
|-|-|
- VER：1个字节，表示的是版本号。对于SOCKS5来说，它的值是0x05。
- CAUTH：1个字节，表示选中的认证方法。如果没有被选中，则设置为0xFF。

选好认证方法之后，接下来就是客户端和服务器端的认证交互了，这里我们选择最基本的用户名和密码0x02认证为例。

##### 认证请求
VER|IDLEN|ID|PWLEN|PW
|-|-|-|-|-|
- VER：1个字节表示当前用户名和密码认证的版本。
- IDLEN：1个字节，表示用户名的长度。
- ID：1到255个字节，表示用户名。
- PWLEN：1个字节，表示密码的长度。
- PW：密码。

##### 服务端响应
VER|STATUS
|-|-|
- VER：1个字节，表示版本号。
- STATUS：1个字节，表示服务器的响应状态。

接下来，客户端就可以和服务器端发送建立连接消息了：
##### 客户端发送建立连接消息
VER|CMD|RSV|DSTADDR|DSTPORT
|-|-|-|-|-|

- CMD：连接可选的命令，0x01表示建立TCP/IP流连接，表示建立TCP/IP端口绑定，0x03表示连接一个UDP端口。
- RSV：保留字节，必须是0x00。
- DSTADDR：SOCKS5的地址。地址的定义是这样的：
  TYPE|ADDR
  |-|-|

  - TYPE：地址的类型，0x01是IPv4地址，0x03是域名，0x04是IPv6地址。
  - ADDR：地址，如果是IPv4，则使用4个字节，如果是域名，则第一个字节表示长度，后面字节表示域名。如果是IPv6地址，则使用16个字节。
##### 服务端响应
VER|STATUS|RSV|BNDADDR|BNDPORT
|-|-|-|-|-|

***
## 0x02 总结
### 2.1 SOCKS代理用途
参考链接：[内网渗透-隐藏通信隧道技术(下)](https://bbs.huaweicloud.com/blogs/400552)

1. 服务器在内网中，可以任意访问外部网络
2. 服务器在内网中，可以访问外部网络，但服务器安装了防火墙来拒绝敏感端口的连接。
3. 服务器在内网中，对外开放了部分端口，且服务器不能访问外部网络。

### 2.2 常用SOCKS代理工具
1. EarthWorm
2. reGEorg
3. sSocks
4. SocksCap64
5. Proxifier：Proxifier是一款全局代理客户端，它可以让应用程序通过代理服务器连接到互联网。
6. ProxyChains：遵循GNU协议的一款适用于linux系统的网络代理设置工具。
7. Stowaway：Stowaway是一个利用go语言编写、专为渗透测试工作者制作的多级代理工具