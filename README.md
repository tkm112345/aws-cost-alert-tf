# AWS Cost Alert System - Learning Project

This project builds an AWS cost monitoring system using Terraform that sends email alerts when monthly costs are projected to exceed a specified amount ($8.00 USD ≈ 1000 yen).

このプロジェクトは、Terraformを使ってAWSの月次コストが指定した金額（$8.00 USD ≈ 1000円）を超えそうになった時にメールアラートを送信するシステムを構築する学習用プロジェクトです。

## 🌟 Features

- ✅ **Monthly Budget Monitoring**: Automatically tracks AWS spending
- 📧 **Email Notifications**: Sends alerts when thresholds are reached
- 🔧 **Terraform Infrastructure**: Infrastructure as Code approach
- 💰 **Cost Effective**: Minimal operational costs (~$0.50/month)
- 🎯 **Learning Focused**: Step-by-step learning approach

## 📋 作成されるAWSリソース

### 1. SNS Topic (`aws_sns_topic`)
- **名前**: cost-alert-topic
- **役割**: コストアラートの通知を配信するトピック
- **コスト**: 月間 ~$0.50 USD（通知数により変動）

### 2. SNS Topic Subscription (`aws_sns_topic_subscription`)
- **プロトコル**: Email
- **役割**: 指定されたメールアドレスにアラートを送信
- **コスト**: 無料（Email通知）

### 3. AWS Budget (`aws_budgets_budget`)
- **予算タイプ**: COST（コスト監視）
- **期間**: MONTHLY（月次）
- **上限**: $8.00 USD
- **アラート条件**:
  - 80%予測到達時（月中頃）
  - 100%実績到達時（予算超過時）
- **コスト**: 無料（最初の2つの予算まで）

## 📁 プロジェクト構成

```
aws-cost-alert-terraform/
├── main.tf                      # Main resource definitions
├── variables.tf                 # Variable definitions and validation
├── outputs.tf                   # Output definitions
├── terraform.tfvars.example     # Example configuration file
├── .gitignore                   # Git ignore patterns
└── README.md                    # This file

# Files you'll create locally (not in git):
├── terraform.tfvars             # Your actual configuration (sensitive)
├── terraform.tfstate            # Terraform state (sensitive)
└── .terraform/                  # Terraform cache directory
```

### ファイルの役割

| ファイル | 役割 | 説明 |
|----------|------|------|
| `main.tf` | リソース定義 | 実際に作成するAWSリソースを定義 |
| `variables.tf` | 変数宣言 | 設定可能な変数の型とデフォルト値を定義 |
| `outputs.tf` | 出力定義 | 作成後に表示したい情報を定義 |
| `terraform.tfvars` | 設定値 | 実際に使用する値を記述（機密情報含む） |

## ⚙️ 設定項目

### variables.tf で定義されている変数

```hcl
# メールアドレス（必須）
email_address = "your-email@example.com"

# 月次予算上限（USD）
budget_amount = "8.00"

# プロジェクト名（リソース名のプレフィックス）
project_name = "aws-cost-watch"

# 環境名
environment = "personal"

# SNSトピック名
sns_topic_name = "cost-alert-topic"
```

### 💡 設定値の変更方法

**重要**: `variables.tf` に記載されているデフォルト値を変更する場合は、`terraform.tfvars` ファイルに記載してください。

例：コストの上限を $15.00 に変更したい場合

```hcl
# terraform.tfvars に記載
budget_amount = "15.00"  # デフォルトの $8.00 から変更
```

- ✅ **推奨**: `terraform.tfvars` で値を上書き
- ❌ **非推奨**: `variables.tf` のデフォルト値を直接変更

これにより、設定とコードを分離でき、異なる環境（dev/staging/prod）での使い回しが可能になります。

## 🚀 セットアップ手順

### 1. 前提条件の確認

```bash
# Terraform のバージョン確認
terraform version

# AWS CLI の設定確認
aws configure list

# 現在のディレクトリを確認
pwd
```

### 2. 設定ファイルの編集

`terraform.tfvars` を編集して、あなたの設定に合わせます：

```bash
nano terraform.tfvars
```

**重要**: メールアドレスを必ず変更してください！

```hcl
email_address = "your-actual-email@gmail.com"  # ← ここを変更
budget_amount = "8.00"
project_name = "aws-cost-watch"
environment = "personal"
sns_topic_name = "cost-alert-topic"
```

### 3. Terraform の実行

```bash
# Step 1: 初期化（プロバイダーのダウンロード）
terraform init

# Step 2: 構文チェック
terraform validate

# Step 3: 実行計画の確認
terraform plan

# Step 4: リソースの作成
terraform apply
```

### 4. メール確認の設定

デプロイ後、登録したメールアドレスに **SNS subscription confirmation** メールが送信されます。

**⚠️ 重要**: メール内の「Confirm subscription」リンクをクリックして、アラートを有効化してください。

## 📊 出力情報

`terraform apply` 実行後、以下の情報が表示されます：

```bash
# 出力例
Outputs:

aws_account_id = "123456789012"
aws_region = "ap-northeast-1"
budget_name = "aws-cost-watch-monthly-budget"
sns_topic_arn = "arn:aws:sns:ap-northeast-1:123456789012:cost-alert-topic"
sns_topic_name = "cost-alert-topic"
subscription_arn = "arn:aws:sns:ap-northeast-1:123456789012:cost-alert-topic:xxxxx"
```

後から確認したい場合：

```bash
terraform output
```

## 🔍 動作確認とテスト

### 1. AWS コンソールでの確認

- **Budget**: [AWS Budgets Console](https://console.aws.amazon.com/billing/home#/budgets)
- **SNS**: [SNS Console](https://console.aws.amazon.com/sns/v3/home?region=ap-northeast-1)
- **コスト**: [Cost Explorer](https://console.aws.amazon.com/cost-reports/home)

### 2. メール受信テスト

実際のアラートをテストするには、意図的にAWSサービスを使用してコストを発生させる必要があります（推奨しません）。

代わりに、予算の設定が正しく行われているかAWSコンソールで確認してください。

## 🛠 管理コマンド

```bash
# 現在の状態を確認
terraform show

# 特定の出力だけ表示
terraform output sns_topic_arn

# 設定を変更して再適用
terraform apply

# リソースを完全に削除
terraform destroy
```

## ⚠️ 重要な注意事項

### コストについて
- **このシステム自体のコスト**: 月間 ~$0.50 USD（SNS通知料金のみ）
- **Budget機能**: 無料（最初の2つまで）

### タイミングについて
- **予算アラート**: 作成後24時間で有効になります
- **予測アラート**: 月の中頃から後半に送信
- **実績アラート**: ほぼリアルタイムで送信
