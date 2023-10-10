---
categories: [渗透测试]
tags: msf ubuntu18.04
---

# 2023.10.10

## ubuntu 部署 msf

```bash
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
# 安装postgresql数据库
sudo apt install postgresql
sudo service postgresql status
msfconsole
```
参考链接：[msf使用方法](https://blog.csdn.net/qq_63844103/article/details/128801917)