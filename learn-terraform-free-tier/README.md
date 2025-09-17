# AWS Free Tier with Terragrunt

## 项目概述
使用Terragrunt管理AWS免费套餐资源的完整解决方案，包含：
- 自动预算监控
- 免费资源部署模板
- 成本控制机制

## 前置要求
- Terraform \u2265 1.5
- AWS Provider 版本约束：`~> 6.0`
- Terragrunt 已安装
- 已配置 AWS CLI 凭证（使用 `AWS_PROFILE` 切换）
- 提交 `.terraform.lock.hcl` 锁定 Provider 版本（本仓库已取消忽略）

## 当前示例实现
- 状态后端（S3 + DynamoDB）
- 预算监控（AWS Budgets + SNS）
- S3 示例资源（SSE、版本化、Public Access Block、BucketOwnerEnforced）

## 部署指南
开始前，建议先阅读下方的“[为什么要有 bootstrap（避免“鸡生蛋”）](#为什么要有-bootstrap避免鸡生蛋)”一节，理解先后顺序。
开始前，建议先阅读下方的“[为什么要有 bootstrap（避免“鸡生蛋”）](#为什么要有-bootstrap避免鸡生蛋)”一节，理解先后顺序。
1. 初始化远程状态（每个账号一次）
   - `cd _bootstrap/state && AWS_PROFILE=dev terragrunt apply`
2. 计划/部署 dev 预算
   - `cd environments/dev/_globals/budget && AWS_PROFILE=dev terragrunt plan --terragrunt-non-interactive`
   - 需要应用时：`terragrunt apply`，应用后到邮箱确认 SNS 订阅（主题通常为“AWS Notification - Subscription Confirmation”）
3. 计划/部署 dev S3 示例
   - `cd environments/dev/storage/s3 && AWS_PROFILE=dev terragrunt plan --terragrunt-non-interactive`

### 删除/销毁指南
- 每个 AWS 账户需分别执行 dev/prod 的销毁步骤，务必使用对应的 `AWS_PROFILE`（如 dev/prod）。
- 按环境删除资源（先删业务栈，最后删状态后端）
  1) 删除 dev 预算：`cd environments/dev/_globals/budget && AWS_PROFILE=dev terragrunt destroy`
  2) 删除 dev S3：`cd environments/dev/storage/s3 && AWS_PROFILE=dev terragrunt destroy`
  3) 删除状态后端（最后）：`cd _bootstrap/state && AWS_PROFILE=dev terragrunt destroy`
  4) 删除 prod 预算：`cd environments/prod/_globals/budget && AWS_PROFILE=prod terragrunt destroy`
  5) 删除 prod S3：`cd environments/prod/storage/s3 && AWS_PROFILE=prod terragrunt destroy`
  6) 删除状态后端（最后，prod 账号）：`cd _bootstrap/state && AWS_PROFILE=prod terragrunt destroy`
     - 如提示因版本化导致 S3 桶无法删除，临时在 `_bootstrap/state/terragrunt.hcl` 的 inputs 加上 `force_destroy = true` 再执行 destroy，完成后可移除。
- 注意：销毁前确认已在邮箱中完成 SNS 订阅的取消或忽略后续邮件。
流程示意（ASCII）：

  [本地 state 引导栈]
          |
          v
  创建 S3 远程状态桶 + DynamoDB 锁表
          |
          v
  各环境栈使用 S3 后端（按目录生成独立 state key）
   - 需要应用时：`terragrunt apply`

## 为什么要有 bootstrap（避免“鸡生蛋”）
- 远程状态循环依赖：要把 Terraform 状态放进 S3，但一开始 S3 桶还没创建，直接 init 会失败。
- Terragrunt 还要求 Terraform 代码内存在 backend 块（哪怕是空的），否则无法注入远程状态配置。
- 解决：先在 `_bootstrap/state` 用本地 state 引导创建“远程状态所需”的 S3 状态桶和 DynamoDB 锁表。
- 之后各环境目录才切换到 S3 远程状态，并通过 `path_relative_to_include()` 生成独立的 state key，互不影响。
- 多账号需分别在各自 `AWS_PROFILE` 下引导一次（桶/表名中带账号 ID 以避免冲突）。
- 快速示例：
  - `cd _bootstrap/state && AWS_PROFILE=dev terragrunt apply`
  - `cd environments/dev/_globals/budget && AWS_PROFILE=dev terragrunt plan --terragrunt-non-interactive`
  - `cd environments/dev/storage/s3 && AWS_PROFILE=dev terragrunt plan --terragrunt-non-interactive`
## 维护建议
1. 每月检查预算通知
2. 定期运行cleanup.sh脚本
3. 使用前验证AWS免费套餐政策更新

## 目录说明
- `terragrunt.hcl`: 仓库根 Terragrunt 配置，统一远程状态（S3+DynamoDB）、Provider 版本与默认标签，并把环境 `env.hcl` 中的参数下发给各模块。
- `_bootstrap/state`: 仅用于“首次”在账号内创建远程状态所需的 S3 桶和 DynamoDB 表；此阶段使用本地 state，避免依赖未创建的远程 state。
- `environments/`: 各环境资源入口（按环境隔离）
  - `<env>/env.hcl`: 该环境的基础参数（`aws_region`、`aws_profile`、通用 `tags`、`budget_limit`/`budget_email`）。
  - `<env>/_globals/budget`: 全局（环境维度）预算与告警，基于 AWS Budgets + SNS 订阅。
  - `<env>/storage/s3`: 示例 S3 资源栈，演示如何按环境复用模块。
- `modules/`: 可复用 Terraform 模块
  - `state-backend`: 远程状态后端（S3 桶、DynamoDB 锁表），开启版本化、加密与公有访问阻断，并支持 `prevent_destroy` 保护。
  - `free-s3`: 标准加固 S3 桶（SSE、版本化、Public Access Block、BucketOwnerEnforced 所有权），支持 `prevent_destroy`。
  - `budget-monitor`: AWS 月度预算与 SNS 邮件告警（需在邮箱确认订阅）。
- `.gitignore`: 忽略缓存与本地 state；允许提交 `.terraform.lock.hcl` 以锁定 Provider 版本。

## 费用与清理
- Plan 不收费；已创建的状态后端（S3+DynamoDB）读写极少，成本基本为 0（Free Tier 内）。
- S3 开启版本化，建议添加生命周期：清理非当前版本（如 90 天），避免长期累计。
- 预算与 SNS 邮件几乎无成本；超支有提醒。
