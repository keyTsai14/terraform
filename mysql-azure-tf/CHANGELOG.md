# 变更履历（Changelog）

本文件记录对 `terraform/mysql-azure-tf` 在本次协作中的主要改动、动机与后续建议，便于审计与团队协作。

## [Unreleased]

### 结构与 Terragrunt
- 根层去除重复定义的模块来源与输入，仅保留共享参数注入：`terraform/mysql-azure-tf/terragrunt.hcl`
  - 移除 `terraform { source = ... }` 与根层 `inputs { ... }`，避免与环境层冲突。
  - 保留 `extra_arguments "common_tfvars"`，统一加载 `common.tfvars`。
- 新增集中远端状态（Azure Storage）配置模板：`remote_state { backend = "azurerm" ... }`
  - 通过环境变量覆盖：`TF_STATE_RG`、`TF_STATE_SA`、`TF_STATE_CONTAINER`；`key` 按相对路径分环境。
  - 注意：需提供真实存储后端或在环境层覆盖为本地 backend。
- 为 `stg` 环境增加根配置继承：`environments/stg/terragrunt.hcl` 添加 `include { path = find_in_parent_folders() }`。
- 为 `dev` 环境添加本地 backend 覆盖用于快速验证：`environments/dev/terragrunt.hcl` 追加 `remote_state { backend = "local" }`。

### 模块（mysql-flexible-server）
- 删除模块内写死的本地后端配置：`modules/mysql-flexible-server/main.tf`（移除 `backend "local"`），将状态交由 Terragrunt 管理。
- 参数对齐与增强：
  - 新增 `variable "tags"`（map(string)）：`modules/mysql-flexible-server/variables.tf`；资源使用 `tags = var.tags`。
  - 新增 `variable "sql_mode"`（string），替代硬编码字符串；并在配置资源中引用：`modules/.../main.tf`。
  - 新增 `variable "require_secure_transport"`（bool，默认 true），用于控制 `require_secure_transport` 配置资源 ON/OFF。
  - 去除在 azurerm v4 中不可配置的 `public_network_access_enabled` 直设（改为由 Provider/平台推导）。

### 环境配置修正
- 变量命名统一：
  - `storage_gb` / `storage_size_in_gb` → `size_gb`
  - `version` → `mysql_version`
  - 涉及文件：`environments/dev|stg|prod/terragrunt.hcl`、`common.tfvars`。
- `stg` 防火墙参数结构修正为 map：
  ```hcl
  firewall_rules = {
    bastion = {
      name             = "bastion"
      start_ip_address = "20.37.96.145"
      end_ip_address   = "20.37.96.145"
    }
  }
  ```
- `prod` 清理未使用变量并修正 SKU：
  - 移除 `database_name`（模块未声明）。
  - `sku_name` 由 `Standard_B1ms` → `B_Standard_B1ms`。
- `dev`/`stg`/`prod` 统一修正 MySQL Flexible 合法 SKU：
  - `dev`: `B_Standard_B2s`
  - `stg`: `B_Standard_B2s`
  - `prod`: `B_Standard_B1ms`

### 公共变量与 tfvars
- `common.tfvars`：
  - `storage_gb` → `size_gb`
  - 移除无用项：`ssl_enforcement_enabled`、旧格式 `sql_mode`（map）。
- 根层 `tfvars` 路径修正为父级：
  - `tfvars_file = "${get_parent_terragrunt_dir()}/common.tfvars"`，确保环境目录能正确加载公共 tfvars。

### 格式化
- 执行 `terragrunt run-all hclfmt` 统一格式。

## 影响与理由
- 避免模块与环境双重 `source`/`inputs` 冲突，简化运维心智模型。
- 将状态管理上移至 Terragrunt，便于团队协作与 CI/CD 集成。
- 变量命名统一，避免 plan/apply 因“未知变量/未生效输入”失败。
- 安全改进：支持通过变量控制 `require_secure_transport` 与 `sql_mode`；`tags` 可按环境覆盖。
- 遵循 Provider 行为变更：在 azurerm v4+ 中不再显式设置 `public_network_access_enabled`。

## 已验证
- 在 dev 环境：使用本地 backend 成功 `init`，`plan` 输出 3 个创建资源（Server + 2 条配置）。
- 修复了此前 `sku_name` 非法与后端不可达导致的报错。

## 待办与建议
- 后端：若需要使用 Azure Storage 远端状态，请在环境中设置：
  - `TF_STATE_RG`、`TF_STATE_SA`、`TF_STATE_CONTAINER` 对应实际资源后再 `terragrunt init -reconfigure`。
- 密码安全：从 HCL 中移除明文密码，改为 `TF_VAR_administrator_password` 或接入 Azure Key Vault（推荐）。
- 安全默认：
  - dev：可按需 `require_secure_transport = false` 便于联调；
  - stg/prod：建议强制 `require_secure_transport = true`，并默认关闭公网，仅白名单放通。
- 网络：若需公网直连测试，请在对应环境 `inputs` 增加 `firewall_rules`（出口 IP）。
- Provider 版本：可在根层统一生成 `versions.tf` 钉定 `azurerm` 次版本范围（如 `~> 4.x`）以减少漂移。
- 可选增强：
  - 默认数据库创建（`azurerm_mysql_flexible_database`）。
  - 变量校验（`validation`）与公共 `tags` 合并策略。
  - README 增补远端状态与凭据加载说明。

## 参考文件路径
- 根层 Terragrunt：`terraform/mysql-azure-tf/terragrunt.hcl`
- 公共变量：`terraform/mysql-azure-tf/common.tfvars`
- 模块：
  - `terraform/mysql-azure-tf/modules/mysql-flexible-server/main.tf`
  - `terraform/mysql-azure-tf/modules/mysql-flexible-server/variables.tf`
- 环境：
  - `terraform/mysql-azure-tf/environments/dev/terragrunt.hcl`
  - `terraform/mysql-azure-tf/environments/stg/terragrunt.hcl`
  - `terraform/mysql-azure-tf/environments/prod/terragrunt.hcl`
