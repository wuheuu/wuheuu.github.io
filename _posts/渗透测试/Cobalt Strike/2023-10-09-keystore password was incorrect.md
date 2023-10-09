---
categories: [Cobalt Strike]
tags: [keystore]
---
# 2023.10.09
## SSL证书中的keystore是什么
### SSL协议
SSL安全协议：Secure socket layer(SSL)，用来提供对用户和服务器的认证，对传送的数据进行**加密和隐藏**，确保数据在传输中不被改变，即**数据的完整性**
#### SSL证书
SSL证书是数字证书的一种，类似于驾驶证、护照和营业执照的电子副本。因为配置在服务器上，也称为SSL服务器证书。

SSL证书就是遵守 SSL协议，由受信任的数字证书颁发机构CA，在验证服务器身份后颁发，具有服务器身份验证和数据传输加密功能。

> **_Note:_** SSL证书在客户端浏览器和web服务器之间建立一条SSL安全通道

### keystore
java密钥库，用来进行通信加密，比如数字签名。keystore用来保存密钥对，比如公钥与私钥。

#### keystore中包含两种数据
- 密钥实体(key entity)： 密钥(secret key)和私钥与与之配对的公钥(采用非对称加密)
- alias(别名)：每个keystore都关联这一个独一无二的alias，这个alias通常不区分大小写

[JDK中keytool常用命令参考](https://blog.csdn.net/wecloud1314/article/details/123042277)

***