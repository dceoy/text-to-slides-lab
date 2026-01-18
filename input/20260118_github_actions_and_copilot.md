# AI Coding & CI/CD using GitHub

## Contents

- [Executive Summary](#executive-summary)
- [Overview of GitHub Actions](#overview-of-github-actions)
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

- GitHub Actions: CI/CD を中心とした決定論的な自動化基盤 (再現性・強制力)
- GitHub Copilot: 実装/修正/レビューを加速する確率論的な生成・推論エンジン
- 重要な設計原則: Copilot の出力を「信頼」するのではなく、Actions で検証・拘束して安全に運用する
  - security hardening: インジェクション/サプライチェーン対策 (静的解析 + SHA pin + 最小権限)
  - context engineering: AGENTS.md / Skills / Spec を "永続成果物" として外部化し、迷走を防ぐ

## Overview of GitHub Actions

- build/test/deploy を自動化する CI/CD
- 構成: event → workflow → job → step → artifact
- 設計
  - permissions は最小限
  - secrets / environment / OIDC を使い分け
  - cache / matrix / concurrency で高速化
- Copilot の差分は CI で検証

## GitHub Actions Reusable Workflows

- 目的: 共通パイプラインを再利用
- `workflow_call` で inputs/secrets を受け渡す（[GitHub Docs][3]）
- 使い分け
  - Composite Action: step をまとめる（[GitHub Docs][25]）
  - Reusable Workflow: job 群をまとめる
- 制約
  - `.github/workflows` 直下のみ（[GitHub Docs][3]）
  - environment secrets は渡せない（[GitHub Docs][3]）
- 権限は昇格不可（[GitHub Docs][3]）
- `.github` リポで標準化
- Rulesets で必須チェックを強制（[GitHub Docs][26]）

References:

- [https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)
- [https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action)
- [https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)

## Static analysis for GitHub Actions

- 目的: 危険ポイントを PR で潰す
- リスク: expressions×shell でインジェクション
- リスク: action の supply chain → SHA pin
- actionlint: YAML/式 + shellcheck（[GitHub][4]）
- zizmor: Actions セキュリティ lint（[GitHub][5]）
- pinact: SHA pin へ変換（[GitHub][6]）
  - 更新は Dependabot/Renovate で回す
- checkov: IaC ポリシー検査（[Checkov][7]）
- GitHub でも pin 強制が進行（[The GitHub Blog][8]）

References:

- [https://github.com/rhysd/actionlint](https://github.com/rhysd/actionlint)
- [https://github.com/zizmorcore/zizmor](https://github.com/zizmorcore/zizmor)
- [https://github.com/suzuki-shunsuke/pinact](https://github.com/suzuki-shunsuke/pinact)
- [https://github.com/bridgecrewio/checkov](https://github.com/bridgecrewio/checkov)
- [https://github.blog/changelog/2025-08-15-github-actions-policy-now-supports-blocking-and-sha-pinning-actions/](https://github.blog/changelog/2025-08-15-github-actions-policy-now-supports-blocking-and-sha-pinning-actions/)

## Dependabot Pull Request

- 目的: 依存更新を PR にする
- `dependabot.yml` は `.github/`（default branch）（[GitHub Docs][9]）
- Best practice
  - 対象と頻度を決める（[GitHub Docs][9]）
  - grouping / limit / ignore / 更新窓を設計（[GitHub Docs][9]）
- `github-actions` で `uses:` も更新

References:

- [https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference)

## Dependabot Alerts

- 目的: 脆弱性を検知して通知
- Alerts は Settings で有効化（[GitHub Docs][10]）
- 通知はダイジェストで運用（[GitHub Docs][10]）
- Trivy: SBOM を登録（[GitHub][11]）
- 対応は PR + required checks で回す

References:

- [https://docs.github.com/code-security/dependabot/dependabot-alerts/configuring-dependabot-alerts](https://docs.github.com/code-security/dependabot/dependabot-alerts/configuring-dependabot-alerts)
- [https://docs.github.com/ja/code-security/concepts/supply-chain-security/about-dependabot-alerts](https://docs.github.com/ja/code-security/concepts/supply-chain-security/about-dependabot-alerts)
- [https://github.com/aquasecurity/trivy-action](https://github.com/aquasecurity/trivy-action)
- [https://github.com/marketplace/actions/aqua-security-trivy](https://github.com/marketplace/actions/aqua-security-trivy)

## GitHub Copilot

- IDE 支援から PR エージェントへ
- 導入
  - 規約/方針をリポジトリに置く（AGENTS.md / Skills）
  - CI をガードレールにする
- Spec/DoD を先に渡す

References:

- [https://docs.github.com/en/copilot](https://docs.github.com/en/copilot)

## GitHub Agent HQ

- 複数エージェントを統合管理（Agent HQ）
- Mission control: 割当/介入/ログ/レビュー
- サードパーティも統合へ
- Custom agents を共有
- Plan Mode で手順を可視化

References:

- [https://github.blog/news-insights/company-news/welcome-home-agents/](https://github.blog/news-insights/company-news/welcome-home-agents/)

## GitHub Copilot Premium Requests

- 機能ごとに消費が違う（[GitHub Docs][12]）
- 増える原因: 高性能モデル / 大タスク / 曖昧仕様
- コスト対策
  - 入力を構造化（Spec/基準）
  - CI でリトライ削減
  - Premium は難題に集中

References:

- [https://docs.github.com/en/copilot/concepts/billing/copilot-requests](https://docs.github.com/en/copilot/concepts/billing/copilot-requests)

## GitHub Copilot Coding Agent

- PR を作り、レビューを依頼（[GitHub Docs][13]）
- 使いどころ
  - 小〜中変更を PR で受ける
  - コメントで差分指示（[GitHub Docs][14]）
- コツ
  - DoD と検証コマンドを明示
  - 境界を AGENTS.md に書く

References:

- [https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)
- [https://docs.github.com/copilot/using-github-copilot/coding-agent/asking-copilot-to-create-a-pull-request](https://docs.github.com/copilot/using-github-copilot/coding-agent/asking-copilot-to-create-a-pull-request)

## AGENTS.md & Agent Skills

- AGENTS.md: エージェント用 README（[agents.md][15]）
- Agent Skills: 手順/規約をフォルダ化（VS Code）（[code.visualstudio.com][16]）
- AGENTS.md に書くこと
  - Persona / Tech stack
  - Commands（build/test/lint）
  - Boundaries（禁止/破壊的変更）
- Context engineering
  - 指示は 1 箇所に集約
  - DoD と検証を明記
  - 重要情報は先頭/末尾（[arXiv][17]）
  - 仕様/状態はファイルで管理
  - 忘却対策も外部化（[PubMed][18]）

References:

- [https://agents.md/](https://agents.md/)
- [https://code.visualstudio.com/docs/copilot/customization/agent-skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [https://arxiv.org/abs/2307.03172](https://arxiv.org/abs/2307.03172)

## Spec Kit

- Spec Kit: SDD のツール（[GitHub][19]）
- 複数エージェント対応（[GitHub][20]）
- 要件→仕様→タスク→実装→検証を揃える
- 4 フェーズ: Specify / Plan / Task / Implement
- 交渉不可ルールは別ファイル化

References:

- [https://github.com/github/spec-kit](https://github.com/github/spec-kit)

## Spec vs Plan?

- Spec: 永続で CI 検証できる
- Plan: 手順（状況依存）
- 使い分け
  - Spec を先に固める（SDD）
  - AI 提案→人間承認（AI-DLC）（[Amazon Web Services, Inc.][21]）
  - 仕様 + 検証で揺らぎを吸収

References:

- [https://github.com/github/spec-kit](https://github.com/github/spec-kit)
- [https://aws.amazon.com/jp/blogs/news/ai-driven-development-life-cycle/](https://aws.amazon.com/jp/blogs/news/ai-driven-development-life-cycle/)

## AI coding + CI/CD

- 長期タスクは段階検証（lint→test→security→review）
- Actions 側の並列化
  - matrix で並列（[GitHub Docs][22]）
  - concurrency で重複抑止（[GitHub Docs][23]）
- 自律ループ例
  - 検知: zizmor
  - 制約: AGENTS.md / Spec
  - 実行: Agent が PR
  - 検証: Actions + Rulesets
  - 判断: Copilot for PRs + 人間
- AI 側も並列化へ（Agent HQ）（[The GitHub Blog][24]）

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

<!-- Reference-style links (not rendered) -->

[3]: https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows
[4]: https://github.com/rhysd/actionlint
[5]: https://github.com/zizmorcore/zizmor
[6]: https://github.com/suzuki-shunsuke/pinact
[7]: https://github.com/bridgecrewio/checkov
[8]: https://github.blog/changelog/2025-08-15-github-actions-policy-now-supports-blocking-and-sha-pinning-actions/
[9]: https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference
[10]: https://docs.github.com/code-security/dependabot/dependabot-alerts/configuring-dependabot-alerts
[11]: https://github.com/aquasecurity/trivy-action
[12]: https://docs.github.com/en/copilot/concepts/billing/copilot-requests
[13]: https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent
[14]: https://docs.github.com/copilot/using-github-copilot/coding-agent/asking-copilot-to-create-a-pull-request
[15]: https://agents.md/
[16]: https://code.visualstudio.com/docs/copilot/customization/agent-skills
[17]: https://arxiv.org/abs/2307.03172
[18]: https://pubmed.ncbi.nlm.nih.gov/?term=catastrophic+forgetting
[19]: https://github.com/github/spec-kit
[20]: https://github.com/github/spec-kit
[21]: https://aws.amazon.com/jp/blogs/news/ai-driven-development-life-cycle/
[22]: https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/running-variations-of-jobs-in-a-workflow
[23]: https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs
[24]: https://github.blog/news-insights/company-news/welcome-home-agents/
[25]: https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action
[26]: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets
