---
categories: [靶场]
tags: PWNEDLABS
---
# 2023-11-14 11:33:03
## 0x01 学到的知识
1. jq命令行工具可以用来格式化json文件
2. `grep -A 10`：显示捕获到的字符串后十行
3. `curl ipinfo.io/<ip-addr>`：显示ip地址地域信息。
4. `grep xxx | wc -l`：匹配包含`xxx`的行并计算行数。
## 0x02 aws相关的一些简称
1. IAM:Identity and Access Management (IAM)
2. STS:Security Token Service
3. AWS:Amazon Web Services
### 0x03 附录
```
Purpose: This document provides a reference to essential credentials and steps to be taken during a disaster recovery scenario

---------------------
Date of Last Update: 8/26
Updated By: Jose
---------------------

--- On-Premise Systems ---

1. System Name: ERP System
   - Access URL/Endpoint: http://erpsystem.hugelogistics.local
   - Username: admin_erp
   - Password: dem0Passw0rd!ERP
   - Recovery Steps:
     1. Access the ERP System administrative console through the provided URL.
     2. Check system status and logs for any anomalies.
     3. Restore from the most recent backup if data corruption is detected.

2. System Name: Warehouse Management System
   - Access URL/Endpoint: http://warehouse.hugelogistics.local
   - Username: admin_warehouse
   - Password: dem0Passw0rd!WMS
   - Recovery Steps:
     1. Verify physical server integrity in the on-premise server room.
     2. Restart services related to the warehouse system.
     3. Confirm synchronization with other integrated systems.

--- Cloud Systems ---

1. System Name: Cloud-based Customer Portal
   - Cloud Provider: AWS
   - Access URL/Endpoint: http://customerportal.hugelogistics.com
   - IAM Role ARN: arn:aws:iam::accountID:role/DR_Role
   - Access Key: AKIAD3M0EX4MPL3DEMO
   - Secret Key: wJalrXUtnFEMI/K7MDENG/dem0accessKEY
   - Recovery Steps:
     1. Log into AWS Management Console with the provided IAM role.
     2. Navigate to EC2 Dashboard and verify the health of customer portal instances.
     3. Inspect CloudWatch Logs for any suspicious activities or system errors.

2. System Name: Cloud-based Tracking System
   - Cloud Provider: Azure
   - Access URL/Endpoint: http://tracking.hugelogistics.com
   - Service Principal ID: c2569dc2-eg1f-11ea-adc1-DEMOPRINCIPAL
   - Client Secret: 12345678-abcd-1234-efgh-56789abcdef01
   - Recovery Steps:
     1. Access Azure Portal and navigate to the Tracking System's Resource Group.
     2. Review the Application Insights associated with the tracking system.
     3. Perform a failover if primary region is experiencing issues.

```
***