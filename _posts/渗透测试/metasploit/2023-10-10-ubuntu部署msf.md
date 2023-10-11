---
categories: [渗透测试]
tags: msf ubuntu18.04
---

# 2023.10.10

## 0x01 ubuntu 部署 msf

```bash
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
# 安装postgresql数据库
sudo apt install postgresql
sudo service postgresql status
msfconsole
```
## 0x02 配置postgresql数据库
```bash
# 安装完成后，在主机上切换到postgres用户
su - postgres
# 登录postgresql数据库，首次登录没有密码
psql 
# 修改数据库用户postgres的密码
\password postgres
```
### 2.1 msf使用数据库
```bash
# msf更新
sudo msfupdate
# msf使用数据库
msfconsole 
# 用户名
db_connect postgres:<password>@127.0.0.1/test
# 查看数据库连接状态
db_status
```
参考链接：
1. [msf使用方法](https://blog.csdn.net/qq_63844103/article/details/128801917)
2. [postgresql](https://zhuanlan.zhihu.com/p/387455070)