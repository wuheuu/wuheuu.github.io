---
categories: [一些知识]
tags: Python subprocess.run(...)
---
# 2023.10.23
参考视频:[Python Tutorial: Calling External Commands Using the Subprocess Module](https://www.youtube.com/watch?v=2Fp1N6dof0Y)
##  0x01 函数原型
`run(*popenargs,input=None, capture_output=False, timeout=None, check=False, **kwargs):`
##  0x02 重要的是使用
### 2.1 subprocess各个参数
```python
import subprocess
##following commands with subprocess.run() are not capturing the stdout
#linux/mac
subprocess.run('ls') 
subprocess.run('ls -la', shell=True)
subprocess.run(['ls','-la'])
#windows
subprocess.run('dir', shell=True)

p1 = subprocess.run(['ls','-la'])
print(p1)
print(p1.args)
print(p1.returncode)# 0 means it ran successfully

## if we want to capture the stdout
p1 = subprocess.run(['ls','-la'], capture_output=True)
print(p1.stdout)# stdout was captured as bytes
print(p1.stdout.decode())
p1 = subprocess.run(['ls','-la'], capture_output=True, text=True)
p1 = subprocess.run(['ls','-la'], stdout=subprocess.PIPE, text=True)# 把输出导向至subprocess这个管道
# we can also redirect the stdout to a file
with open('output.txt', 'w') as f:
    p1 = subprocess.run(['ls','-la'], stdout=f, text=True)
```
![2023-10-23-10-15-02.png](https://s2.loli.net/2023/10/27/qhmt6KTWFD7pYEC.png)
### 2.2 subprocess出错情况
```python
import subprocess
p1 = subprocess.run(['ls','-la', 'does_not_exist'], capture_output=True, text=True)
print(p1.returncode) # 1
print(p1.stderr) # ls : does_not_exist : No such file or directory 
# let python throw out an exception，进程执行返回非0状态码将抛出CalledProcessError异常
p1 = subprocess.run(['ls','-la', 'does_not_exist'], capture_output=True, text=True,check=True)
print(p1.stderr)
# do not display or capture the error
p1 = subprocess.run(['ls','-la', 'does_not_exist'], stderr=subprocess.DEVNULL)
print(p1.stderr)# None
```

### 2.3 多个subprocess协作
```python
import subprocess
p1 = subprocess.run(['cat','test.txt'], capture_output=True, text=True)
p2 = subprocess.run(['grep', '-n', 'test'], capture_output=True, text=True, input=p1.stdout) #grep -n：显示行号
print(p2.stdout)
```