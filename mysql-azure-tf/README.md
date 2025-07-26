## 部署步骤

### login
az login

### 为特定环境初始化
cd environments/dev
terragrunt init

### 查看执行计划
terragrunt plan

### 部署资源
terragrunt apply

### 对其他环境重复相同步骤
