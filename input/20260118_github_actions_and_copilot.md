# GitHub Actions と GitHub Copilot の活用

## Contents

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

## Overview of GitHub Actions

TBD

## GitHub Actions Reusable Workflows

- 目的：組織横断の標準パイプライン (build/test/release) を **再利用可能コンポーネント** として提供
- `on: workflow_call` で呼び出し可能化し、`inputs` / `secrets` を明示的に受け渡す ([GitHub Docs][3])
- 重要制約 (設計時にハマりやすい)
  - 再利用 workflow は `.github/workflows` 配下 (サブディレクトリ不可) ([GitHub Docs][3])
  - `environment` 経由の secret 受け渡しには制約がある (呼び出し側から `workflow_call` では渡せない) ([GitHub Docs][3])
- ガバナンス：チェーン上で権限は"維持 or 減らす"方向 (昇格不可) を前提に設計 ([GitHub Docs][3])

References:

- [https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)

## Static analysis for GitHub Actions

- 目的：CI 設定・IaC・依存関係の"壊れやすい/危険"ポイントを **PR 時点で機械的に潰す**
- actionlint：workflow 構文/式の静的検査＋`run:` へ shellcheck 等を適用 ([GitHub][4])
- zizmor：GitHub Actions 向けセキュリティ観点の静的解析 (典型的な危険パターン検出) ([GitHub][5])
- pinact：actions / reusable workflow を commit SHA pin に自動変換 (タグ可変リスクの低減) ([GitHub][6])
- checkov：Terraform 等の IaC misconfiguration を policy-as-code で検出 ([Checkov][7])
- 補足：GitHub 側でも SHA pinning のポリシー強化が進行 (組織統制で "強制" 可能な方向へ) ([The GitHub Blog][8])

References:

- [https://github.com/rhysd/actionlint](https://github.com/rhysd/actionlint)
- [https://github.com/zizmorcore/zizmor](https://github.com/zizmorcore/zizmor)
- [https://github.com/suzuki-shunsuke/pinact](https://github.com/suzuki-shunsuke/pinact)
- [https://github.com/bridgecrewio/checkov](https://github.com/bridgecrewio/checkov)
- [https://github.blog/changelog/2025-08-15-github-actions-policy-now-supports-blocking-and-sha-pinning-actions/](https://github.blog/changelog/2025-08-15-github-actions-policy-now-supports-blocking-and-sha-pinning-actions/)

## Dependabot Pull Request

- 目的：依存関係更新 (version updates / security updates) を PR 化し、レビュー可能な変更単位に落とす
- `dependabot.yml` は **デフォルトブランチの `.github/` 配下** に配置 (更新で即時チェックが走る) ([GitHub Docs][9])
- Best practice (運用品質を上げる)
  - update 対象 (ecosystem / directory) を明確化、頻度 (daily/weekly/monthly) をチーム運用に合わせる ([GitHub Docs][9])
  - PR ノイズを抑える：グルーピング、上限 (open PR limit) 、ignore ルール、更新窓 (運用時間) を設計 (設定項目は公式リファレンス参照) ([GitHub Docs][9])

References:

- [https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference)

## Dependabot Alerts

- 目的：脆弱な依存関係を検知し、Security タブ上で可視化・通知・トリアージ
- 重要：Alerts は `dependabot.yml` ではなく **リポジトリ/組織の Settings で有効化** ([GitHub Docs][9])
- 通知設計：ダイジェスト (daily/weekly) 等で運用負荷を最適化 ([GitHub Docs][10])
- 補完 (Trivy) ：コンテナ/IaC から SBOM を生成し、Security タブへ登録 (例：`aquasecurity/trivy-action`) ([GitHub][11])

References:

- [https://docs.github.com/code-security/dependabot/dependabot-alerts/configuring-dependabot-alerts](https://docs.github.com/code-security/dependabot/dependabot-alerts/configuring-dependabot-alerts)
- [https://docs.github.com/ja/code-security/concepts/supply-chain-security/about-dependabot-alerts](https://docs.github.com/ja/code-security/concepts/supply-chain-security/about-dependabot-alerts)
- [https://github.com/aquasecurity/trivy-action](https://github.com/aquasecurity/trivy-action)
- [https://github.com/marketplace/actions/aqua-security-trivy](https://github.com/marketplace/actions/aqua-security-trivy)

## GitHub Copilot

- 立ち位置：IDE 支援 (提案/チャット) から **PR 単位で成果物を出す"エージェント"**へ拡張
- 導入の勘所
  - チーム標準：コーディング規約・設計原則・テスト方針を "機械可読な指示" としてリポジトリに置く (後述の AGENTS.md / Skills)
  - ガードレール：CI (Actions) を AI の出力検証ラインにして"自動生成の事故"を吸収する

References:

- [https://docs.github.com/en/copilot](https://docs.github.com/en/copilot)

## GitHub Agent HQ

TBD

## GitHub Copilot Premium Requests

- Premium request は機能ごとに消費単位が異なる (例：Chat=1 prompt、Coding Agent=1 session 等、モデル倍率あり) ([GitHub Docs][12])
- コスト最適化の実務
  - "雑談" を減らし、入力を構造化 (Spec/チェックリスト/受け入れ基準を先に渡す)
  - Agent に投げる前に CI ガードレール (lint/test/security) を整備し、リトライ回数を削減

References:

- [https://docs.github.com/en/copilot/concepts/billing/copilot-requests](https://docs.github.com/en/copilot/concepts/billing/copilot-requests)

## GitHub Copilot Coding Agent

- できること：PR を新規作成/既存 PR を更新し、最終的に人間へレビュー要求 (開発フローにネイティブ統合) ([GitHub Docs][13])
- 使いどころ (エンジニア向け実務)
  - "小〜中" 粒度の変更 (リファクタ、テスト追加、ドキュメント整備、ルール適用) を **PR で受領**する
  - 変更指示は PR コメントで `@copilot` などを用いて差分駆動で反復 (レビュー効率が高い) ([GitHub Docs][14])

References:

- [https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)
- [https://docs.github.com/copilot/using-github-copilot/coding-agent/asking-copilot-to-create-a-pull-request](https://docs.github.com/copilot/using-github-copilot/coding-agent/asking-copilot-to-create-a-pull-request)

## AGENTS.md & Agent Skills

- AGENTS.md：コーディングエージェント向けの "README" という位置づけのオープンフォーマット ([エージェント.md][15])
- Agent Skills：手順/スクリプト/規約をフォルダとして提供し、Copilot が状況に応じてロードできる (VS Code 連携) ([code.visualstudio.com][16])
- Context Engineering (実務要点)
  - 指示の置き場所を分散させず、**単一の規範 (AGENTS.md + Skills) **に集約
  - 受け入れ基準 (DoD) と検証手段 (コマンド、CI ジョブ) を明記し、推論の迷走を減らす
  - 背景：長文コンテキストでは情報位置によって性能が落ちる (Lost in the Middle) ため、"重要情報を先頭/末尾に寄せる" 設計が効く ([arXiv][17])
  - "忘れる" 問題 (catastrophic forgetting) は古典的課題で、対策は外部化 (仕様/チェックリスト/状態管理) ([PubMed][18])

References:

- [https://agents.md/](https://agents.md/)
- [https://code.visualstudio.com/docs/copilot/customization/agent-skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [https://arxiv.org/abs/2307.03172](https://arxiv.org/abs/2307.03172)

## Spec Kit

- GitHub Spec Kit：Spec-Driven Development (SDD) を実装するためのツールキット (`specify` CLI、slash commands 等) ([GitHub][19])
- "複数エージェント前提" の設計 (Copilot / Gemini CLI / Codex CLI などを明示的にサポート) ([GitHub][20])
- 使い方の狙い：要件→仕様→タスク→実装→検証、を **エージェントが辿れる形**に落とす (属人的プロンプトを減らす)

References:

- [https://github.com/github/spec-kit](https://github.com/github/spec-kit)

## Spec vs Plan?

- Spec (仕様) ：**永続・レビュー可能・CIで検証可能**な成果物 (例：受け入れ基準、I/O、制約、非機能)
- Plan (計画) ：エージェントの作業手順 (揮発・状況依存) 。Plan は "仕様の代替" ではなく "仕様を実現するための手段"
- 接続 (現場の最適解)
  - SDD：Spec を先に固定し、Plan は短く回す (リトライ・改変に強い)
  - AI-DLC：AI 主導で提案→人間が承認する、という開発ライフサイクル再設計 (方法論として明文化) ([Amazon Web Services, Inc.][21])

References:

- [https://github.com/github/spec-kit](https://github.com/github/spec-kit)
- [https://aws.amazon.com/jp/blogs/news/ai-driven-development-life-cycle/](https://aws.amazon.com/jp/blogs/news/ai-driven-development-life-cycle/)

## AI coding + CI/CD

- long-running tasks：エージェントが "作業を続ける" 前提で、CI は **途中成果を細かく検証** (lint→test→security→review)
- parallel execution (Actions 側)
  - matrix：1 定義から複数ジョブを自動生成し、テスト/ビルドを並列化 ([GitHub Docs][22])
  - concurrency：同一グループの実行を抑制し、ムダな実行をキャンセル (`cancel-in-progress`) ([GitHub Docs][23])

- parallel execution (AI 側の未来) ：複数エージェントを同時に走らせて比較/統合する "オーケストレーション" が前提に (Agent HQ / mission control) ([The GitHub Blog][24])

References:

- [https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/running-variations-of-jobs-in-a-workflow](https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/running-variations-of-jobs-in-a-workflow)
- [https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs](https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs)
- [https://github.blog/news-insights/company-news/welcome-home-agents/](https://github.blog/news-insights/company-news/welcome-home-agents/)

## Application to Business Process Outsourcing

TBD
