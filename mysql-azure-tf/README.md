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

## 远端状态配置与运行指南

本仓库使用 Terragrunt 统一生成 Terraform 的后端配置（backend）。默认在根层配置了 Azure Storage 作为远端状态存储；你也可以在单个环境（如 dev）覆盖为本地后端用于快速验证。

### 方案 A：使用 Azure Storage 远端状态（推荐）

1) 准备后端资源（首次）：

- 创建资源组与存储账号/容器（示例）：

      az group create -n <TF_STATE_RG> -l japaneast
      az storage account create -g <TF_STATE_RG> -n <TF_STATE_SA> -l japaneast --sku Standard_LRS
      az storage container create --account-name <TF_STATE_SA> -n <TF_STATE_CONTAINER>

2) 在 shell 或 CI 中导出环境变量（根 `terragrunt.hcl` 会读取）：

      export TF_STATE_RG=<TF_STATE_RG>
      export TF_STATE_SA=<TF_STATE_SA>   # 全小写、全局唯一
      export TF_STATE_CONTAINER=tfstate

3) 初始化并运行：

      cd environments/<env>
      terragrunt init -reconfigure
      terragrunt plan

> 远端状态 key 将按 `mysql-azure-tf/<相对环境路径>/terraform.tfstate` 组织。

### 方案 B：使用本地后端（仅用于本地验证）

dev 环境已在 `environments/dev/terragrunt.hcl` 覆盖为本地 backend：

```hcl
remote_state {
  backend  = "local"
  generate = { path = "backend.tf", if_exists = "overwrite" }
  config   = { path = "./terraform.tfstate" }
}
```

其它环境可按需仿照覆盖（不建议提交到生产分支）。

### 凭据与敏感信息

- 管理员密码请通过环境变量提供，不要写入 HCL 文件：

      export TF_VAR_administrator_password='<你的强密码>'

- Azure 身份：使用 Azure CLI 或服务主体任一方式。

  - Azure CLI：

        az login
        az account set --subscription <SUBSCRIPTION_ID>

  - 服务主体（CI 常用）：

        export ARM_TENANT_ID=...
        export ARM_SUBSCRIPTION_ID=...
        export ARM_CLIENT_ID=...
        export ARM_CLIENT_SECRET=...

完成以上后，在对应环境目录执行 `terragrunt init -reconfigure` 与 `terragrunt plan/apply` 即可。
