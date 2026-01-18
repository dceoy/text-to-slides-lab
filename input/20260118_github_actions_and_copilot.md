# AI coding with CI/CD on GitHub

## Contents

- [Executive Summary](#executive-summary)
- [AI Coding with CI/CD](#ai-coding-with-cicd)
- [GitHub Actions](#github-actions)
- [GitHub Actions Reusable Workflows](#github-actions-reusable-workflows)
- [Static analysis for GitHub Actions](#static-analysis-for-github-actions)
- [Dependabot Pull Request](#dependabot-pull-request)
- [Dependabot Alerts](#dependabot-alerts)
- [GitHub Copilot](#github-copilot)
- [GitHub Agent HQ](#github-agent-hq)
- [GitHub Copilot Premium Requests](#github-copilot-premium-requests)
- [GitHub Copilot Coding Agent](#github-copilot-coding-agent)
- [AGENTS.md & Agent Skills](#agentsmd--agent-skills)
- [Spec Kit](#spec-kit)
- [Spec vs Plan?](#spec-vs-plan)
- [AI coding + CI/CD](#ai-coding--cicd)
- [Application to Business Process Outsourcing](#application-to-business-process-outsourcing)

## Executive Summary

- GitHub を使った CI/CD + AI coding
  - GitHub Actions
  - Dependabot
  - GitHub Copilot
- この先の AI coding agents
  - 自律的に長時間稼働
  - 非同期・並列実行
- 開発生産性向上の先
  - Business process automation

## AI Coding with CI/CD

- AI coding
  - 確率論的な生成・推論による実装/修正/レビュー
- CI/CD
  - 決定論的な自動化による修正・検証・デプロイ
- AI coding と CI/CD で開発効率と品質を向上させる
  - 利用できる GitHub サービス
    - GitHub Actions
    - Dependabot
    - GitHub Copilot

## GitHub Actions

- GitHub リポジトリ内でワークフローを自動化する CI/CD プラットフォーム
  - Workflow: `.github/workflows/*.yml` に定義 (YAML)
  - Trigger: `push` / `pull_request` / `workflow_dispatch` / `schedule` など
  - Job/Step/Action: job を runner 上で実行し、Marketplace などの action を組み合わせる
  - Runner: GitHub-hosted runners / self-hosted runners を選べる
  - データ共有: artifacts (成果物) / cache (依存キャッシュ) で高速化・受け渡し
  - Secrets: secret を暗号化して管理し、必要な範囲だけに渡す
  - Environments: デプロイ先ごとに保護ルール (承認など) と secrets を分離
  - セキュリティ: `GITHUB_TOKEN` の最小権限化 + OIDC でクラウドへ安全に連携

References:

- [https://docs.github.com/en/actions/about-github-actions/understanding-github-actions](https://docs.github.com/en/actions/about-github-actions/understanding-github-actions)
- [https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows)
- [https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners)
- [https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners)
- [https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/storing-and-sharing-data-from-a-workflow](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/storing-and-sharing-data-from-a-workflow)
- [https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/caching-dependencies-to-speed-up-workflows](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/caching-dependencies-to-speed-up-workflows)
- [https://docs.github.com/en/actions/security-for-github-actions/security-guides/about-secrets](https://docs.github.com/en/actions/security-for-github-actions/security-guides/about-secrets)
- [https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect)

## GitHub Actions Reusable Workflows

- 目的: 共通パイプラインを再利用
- `workflow_call` で inputs/secrets を受け渡す ([GitHub Docs][3])
- 使い分け
  - Composite Action: step をまとめる ([GitHub Docs][25])
  - Reusable Workflow: job 群をまとめる
- 制約
  - `.github/workflows` 直下のみ ([GitHub Docs][3])
  - environment secrets は渡せない ([GitHub Docs][3])
- 権限は昇格不可 ([GitHub Docs][3])
- `.github` リポで標準化
- Rulesets で必須チェックを強制 ([GitHub Docs][26])

References:

- [https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)
- [https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action)
- [https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)

## Static analysis for GitHub Actions

- 目的: 危険ポイントを PR で潰す
- リスク: expressions×shell でインジェクション
- リスク: action の supply chain → SHA pin
- actionlint: YAML/式 + shellcheck ([GitHub][4])
- zizmor: Actions セキュリティ lint ([GitHub][5])
- pinact: SHA pin へ変換 ([GitHub][6])
  - 更新は Dependabot/Renovate で回す
- checkov: IaC ポリシー検査 ([Checkov][7])
- GitHub でも pin 強制が進行 ([The GitHub Blog][8])

References:

- [https://github.com/rhysd/actionlint](https://github.com/rhysd/actionlint)
- [https://github.com/zizmorcore/zizmor](https://github.com/zizmorcore/zizmor)
- [https://github.com/suzuki-shunsuke/pinact](https://github.com/suzuki-shunsuke/pinact)
- [https://github.com/bridgecrewio/checkov](https://github.com/bridgecrewio/checkov)
- [https://github.blog/changelog/2025-08-15-github-actions-policy-now-supports-blocking-and-sha-pinning-actions/](https://github.blog/changelog/2025-08-15-github-actions-policy-now-supports-blocking-and-sha-pinning-actions/)

## Dependabot Pull Request

- 目的: 依存更新を PR にする
- `dependabot.yml` は `.github/` (default branch) ([GitHub Docs][9])
- Best practice
  - 対象と頻度を決める ([GitHub Docs][9])
  - grouping / limit / ignore / 更新窓を設計 ([GitHub Docs][9])
- `github-actions` で `uses:` も更新

References:

- [https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference)

## Dependabot Alerts

- 目的: 脆弱性を検知して通知
- Alerts は Settings で有効化 ([GitHub Docs][10])
- 通知はダイジェストで運用 ([GitHub Docs][10])
- Trivy: SBOM を登録 ([GitHub][11])
- 対応は PR + required checks で回す

References:

- [https://docs.github.com/code-security/dependabot/dependabot-alerts/configuring-dependabot-alerts](https://docs.github.com/code-security/dependabot/dependabot-alerts/configuring-dependabot-alerts)
- [https://docs.github.com/ja/code-security/concepts/supply-chain-security/about-dependabot-alerts](https://docs.github.com/ja/code-security/concepts/supply-chain-security/about-dependabot-alerts)
- [https://github.com/aquasecurity/trivy-action](https://github.com/aquasecurity/trivy-action)
- [https://github.com/marketplace/actions/aqua-security-trivy](https://github.com/marketplace/actions/aqua-security-trivy)

## GitHub Copilot

- 目的: AI pair programmer として開発を支援 (補完/チャット/レビュー/自動編集)
- Inline suggestions: エディタ上でコード補完
- Copilot Chat: コードの説明・修正提案・テスト生成などを対話で支援
- Copilot Edits: 指示に沿って複数ファイルの変更案を作成 (Edit / Agent mode)
- Copilot in GitHub.com: PR summaries などでレビュー/把握を補助
- Copilot code review: 変更差分へのフィードバックを生成
- Custom instructions: コーディング規約/方針を指示に組み込み
- プラン/管理: Individual / Business / Enterprise で利用 (ポリシー管理や請求を組織で統制)

References:

- [https://docs.github.com/en/copilot](https://docs.github.com/en/copilot)
- [https://docs.github.com/en/copilot/about-github-copilot/what-is-github-copilot](https://docs.github.com/en/copilot/about-github-copilot/what-is-github-copilot)
- [https://docs.github.com/en/copilot/about-github-copilot/github-copilot-features](https://docs.github.com/en/copilot/about-github-copilot/github-copilot-features)
- [https://docs.github.com/en/copilot/about-github-copilot/plans-for-github-copilot](https://docs.github.com/en/copilot/about-github-copilot/plans-for-github-copilot)
- [https://docs.github.com/en/copilot/using-github-copilot/using-copilot-chat/asking-github-copilot-questions-in-your-ide](https://docs.github.com/en/copilot/using-github-copilot/using-copilot-chat/asking-github-copilot-questions-in-your-ide)

## GitHub Agent HQ

- 複数エージェントを統合管理 (Agent HQ)
- Mission control: 割当/介入/ログ/レビュー
- サードパーティも統合へ
- Custom agents を共有
- Plan Mode で手順を可視化

References:

- [https://github.blog/news-insights/company-news/welcome-home-agents/](https://github.blog/news-insights/company-news/welcome-home-agents/)

## GitHub Copilot Premium Requests

- 機能ごとに消費が違う ([GitHub Docs][12])
- 増える原因: 高性能モデル / 大タスク / 曖昧仕様
- コスト対策
  - 入力を構造化 (Spec/基準)
  - CI でリトライ削減
  - Premium は難題に集中

References:

- [https://docs.github.com/en/copilot/concepts/billing/copilot-requests](https://docs.github.com/en/copilot/concepts/billing/copilot-requests)

## GitHub Copilot Coding Agent

- PR を作り、レビューを依頼 ([GitHub Docs][13])
- 使いどころ
  - 小〜中変更を PR で受ける
  - コメントで差分指示 ([GitHub Docs][14])
- コツ
  - DoD と検証コマンドを明示
  - 境界を AGENTS.md に書く

References:

- [https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)
- [https://docs.github.com/copilot/using-github-copilot/coding-agent/asking-copilot-to-create-a-pull-request](https://docs.github.com/copilot/using-github-copilot/coding-agent/asking-copilot-to-create-a-pull-request)

## AGENTS.md & Agent Skills

- AGENTS.md: エージェント用 README ([agents.md][15])
- Agent Skills: 手順/規約をフォルダ化 (VS Code) ([code.visualstudio.com][16])
- AGENTS.md に書くこと
  - Persona / Tech stack
  - Commands (build/test/lint)
  - Boundaries (禁止/破壊的変更)
- Context engineering
  - 指示は 1 箇所に集約
  - DoD と検証を明記
  - 重要情報は先頭/末尾 ([arXiv][17])
  - 仕様/状態はファイルで管理
  - 忘却対策も外部化 ([PubMed][18])

References:

- [https://agents.md/](https://agents.md/)
- [https://code.visualstudio.com/docs/copilot/customization/agent-skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [https://arxiv.org/abs/2307.03172](https://arxiv.org/abs/2307.03172)

## Spec Kit

- Spec Kit: SDD のツール ([GitHub][19])
- 複数エージェント対応 ([GitHub][20])
- 要件→仕様→タスク→実装→検証を揃える
- 4 フェーズ: Specify / Plan / Task / Implement
- 交渉不可ルールは別ファイル化

References:

- [https://github.com/github/spec-kit](https://github.com/github/spec-kit)

## Spec vs Plan?

- Spec: 永続で CI 検証できる
- Plan: 手順 (状況依存)
- 使い分け
  - Spec を先に固める (SDD)
  - AI 提案→人間承認 (AI-DLC) ([Amazon Web Services, Inc.][21])
  - 仕様 + 検証で揺らぎを吸収

References:

- [https://github.com/github/spec-kit](https://github.com/github/spec-kit)
- [https://aws.amazon.com/jp/blogs/news/ai-driven-development-life-cycle/](https://aws.amazon.com/jp/blogs/news/ai-driven-development-life-cycle/)

## AI coding + CI/CD

- 長期タスクは段階検証 (lint→test→security→review)
- Actions 側の並列化
  - matrix で並列 ([GitHub Docs][22])
  - concurrency で重複抑止 ([GitHub Docs][23])
- 自律ループ例
  - 検知: zizmor
  - 制約: AGENTS.md / Spec
  - 実行: Agent が PR
  - 検証: Actions + Rulesets
  - 判断: Copilot for PRs + 人間
- AI 側も並列化へ (Agent HQ) ([The GitHub Blog][24])

References:

- [https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/running-variations-of-jobs-in-a-workflow](https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/running-variations-of-jobs-in-a-workflow)
- [https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs](https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs)
- [https://github.blog/news-insights/company-news/welcome-home-agents/](https://github.blog/news-insights/company-news/welcome-home-agents/)

## Application to Business Process Outsourcing

- BPO を Spec 化して自動化
- 例
  - 定型レポート: Actions 定期実行 + PR レビュー
  - 手順書: AGENTS.md/Skills 化 + Agent 更新
  - 依存/セキュリティ: Dependabot + 必須チェック
- ガバナンス
  - 自動承認範囲を Rulesets/環境で定義
  - Premium を可視化し ROI に集中
