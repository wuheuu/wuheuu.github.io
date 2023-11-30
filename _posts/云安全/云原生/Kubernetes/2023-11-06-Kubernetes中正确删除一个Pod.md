---
categories: [Kubernetes]
tags: Kubernetes 云原生
---
# 2023.11.06
## 0x01 Kubernetes删除pod
```bash
# 删除pod
kubectl delete pod <pod-name> -n <namespace>
# 删除deployment
kubectl delete deployment <deployment-name> -n <namespace>
```