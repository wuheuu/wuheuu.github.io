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
