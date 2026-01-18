# GitHub Actions と GitHub Copilot の活用

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

- GitHub Actions: CI/CD を中心とした **決定論的な自動化基盤** (再現性・強制力)
- GitHub Copilot: 実装/修正/レビューを加速する **確率論的な生成・推論エンジン**
- 重要な設計原則: Copilot の出力を「信頼」するのではなく、Actions で **検証・拘束** して安全に運用する
  - security hardening: インジェクション/サプライチェーン対策 (静的解析 + SHA pin + 最小権限)
  - context engineering: AGENTS.md / Skills / Spec を "永続成果物" として外部化し、迷走を防ぐ
  - コスト最適化: Premium Requests を「難しいタスク」に集中投下 (入力の構造化 / CI ガードレール)

## Overview of GitHub Actions

- GitHub 上で build/test/deploy を自動実行する CI/CD プラットフォーム
- 基本要素: event → workflow (YAML) → jobs (runner) → steps (run/uses) → artifacts
- 実務での設計ポイント
  - **最小権限**: `permissions:` を workflow/job 単位で絞る (不要な write 権限を持たせない)
  - secrets: `secrets` / `environment` / OIDC の使い分け (fork PR への露出に注意)
  - フィードバック速度: cache / matrix / concurrency で待ち時間を削減
- Copilot と組み合わせるときの役割: AI が作った差分を **決定論的に検証するゲート** として CI を設計する

## GitHub Actions Reusable Workflows

- 目的: 組織横断の標準パイプライン (build/test/release) を **再利用可能コンポーネント** として提供
- `on: workflow_call` で呼び出し可能化し、`inputs` / `secrets` を明示的に受け渡す ([GitHub Docs][3])
- 使い分け (現場で効く粒度の分離)
  - Composite Action: 複数 step を 1 つの action として配布 (セットアップ等の共通化) ([GitHub Docs][25])
  - Reusable Workflow: ジョブ群 (ビルド/テスト/スキャン/デプロイ) をテンプレ化して呼び出す
- 重要制約 (設計時にハマりやすい)
  - 再利用 workflow は `.github/workflows` 配下 (サブディレクトリ不可) ([GitHub Docs][3])
  - `environment` 経由の secret 受け渡しには制約がある (呼び出し側から `workflow_call` では渡せない) ([GitHub Docs][3])
- ガバナンス: チェーン上で権限は"維持 or 減らす"方向 (昇格不可) を前提に設計 ([GitHub Docs][3])
- 運用パターン: `.github` リポジトリに標準 workflow/action を集約し、各リポジトリの設定ドリフトを抑える
- Rulesets: required checks やマージ条件を組織横断で強制し、標準パイプラインの遵守を担保 ([GitHub Docs][26])

References:

- [https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)
- [https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action)
- [https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)

## Static analysis for GitHub Actions

- 目的: CI 設定・IaC・依存関係の"壊れやすい/危険"ポイントを **PR 時点で機械的に潰す**
- 背景: Expressions と shell 展開の境界で **インジェクション** が起きやすい (Issue/PR タイトル等の入力を `run:` に埋め込むなど)
- もう一つの主要リスク: サードパーティ action の **サプライチェーン** (mutable tag) → SHA pinning が効く
- actionlint: workflow 構文/式の静的検査＋`run:` へ shellcheck 等を適用 ([GitHub][4])
- zizmor: GitHub Actions 向けセキュリティ観点の静的解析 (典型的な危険パターン検出、persona で感度調整) ([GitHub][5])
- pinact: actions / reusable workflow を commit SHA pin に自動変換 (タグ可変リスクの低減) ([GitHub][6])
  - 運用メモ: SHA pin は「更新のパラドックス」を生むため、Dependabot/Renovate 等で更新 PR を回す
- checkov: Terraform 等の IaC misconfiguration を policy-as-code で検出 ([Checkov][7])
- 補足: GitHub 側でも SHA pinning のポリシー強化が進行 (組織統制で "強制" 可能な方向へ) ([The GitHub Blog][8])

References:

- [https://github.com/rhysd/actionlint](https://github.com/rhysd/actionlint)
- [https://github.com/zizmorcore/zizmor](https://github.com/zizmorcore/zizmor)
- [https://github.com/suzuki-shunsuke/pinact](https://github.com/suzuki-shunsuke/pinact)
- [https://github.com/bridgecrewio/checkov](https://github.com/bridgecrewio/checkov)
- [https://github.blog/changelog/2025-08-15-github-actions-policy-now-supports-blocking-and-sha-pinning-actions/](https://github.blog/changelog/2025-08-15-github-actions-policy-now-supports-blocking-and-sha-pinning-actions/)

## Dependabot Pull Request

- 目的: 依存関係更新 (version updates / security updates) を PR 化し、レビュー可能な変更単位に落とす
- `dependabot.yml` は **デフォルトブランチの `.github/` 配下** に配置 (更新で即時チェックが走る) ([GitHub Docs][9])
- Best practice (運用品質を上げる)
  - update 対象 (ecosystem / directory) を明確化、頻度 (daily/weekly/monthly) をチーム運用に合わせる ([GitHub Docs][9])
  - PR ノイズを抑える: グルーピング、上限 (open PR limit) 、ignore ルール、更新窓 (運用時間) を設計 (設定項目は公式リファレンス参照) ([GitHub Docs][9])
- 補足: `package-ecosystem: github-actions` で Actions の `uses:` も更新対象にできる (pinact 併用時は特に重要)

References:

- [https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference)

## Dependabot Alerts

- 目的: 脆弱な依存関係を検知し、Security タブ上で可視化・通知・トリアージ
- 重要: Alerts は `dependabot.yml` ではなく **リポジトリ/組織の Settings で有効化** ([GitHub Docs][10])
- 通知設計: ダイジェスト (daily/weekly) 等で運用負荷を最適化 ([GitHub Docs][10])
- 補完 (Trivy) : コンテナ/IaC から SBOM を生成し、Security タブへ登録 (例: `aquasecurity/trivy-action`) ([GitHub][11])
- 運用の勘所: アラート対応を「人の判断」だけにせず、security updates PR + required checks で機械的に回す

References:

- [https://docs.github.com/code-security/dependabot/dependabot-alerts/configuring-dependabot-alerts](https://docs.github.com/code-security/dependabot/dependabot-alerts/configuring-dependabot-alerts)
- [https://docs.github.com/ja/code-security/concepts/supply-chain-security/about-dependabot-alerts](https://docs.github.com/ja/code-security/concepts/supply-chain-security/about-dependabot-alerts)
- [https://github.com/aquasecurity/trivy-action](https://github.com/aquasecurity/trivy-action)
- [https://github.com/marketplace/actions/aqua-security-trivy](https://github.com/marketplace/actions/aqua-security-trivy)

## GitHub Copilot

- 立ち位置: IDE 支援 (提案/チャット) から **PR 単位で成果物を出す"エージェント"**へ拡張
- 導入の勘所
  - チーム標準: コーディング規約・設計原則・テスト方針を "機械可読な指示" としてリポジトリに置く (後述の AGENTS.md / Skills)
  - ガードレール: CI (Actions) を AI の出力検証ラインにして"自動生成の事故"を吸収する
- 使い分けの基本: 雑な自然言語のまま「Vibe Coding」しない (Spec/DoD/チェックリストを先に渡す)

References:

- [https://docs.github.com/en/copilot](https://docs.github.com/en/copilot)

## GitHub Agent HQ

- GitHub 上で、複数のコーディングエージェントを単一の統合ワークフローとして扱う構想 (Agent HQ)
- Mission control で、タスク割当・途中介入 (steer) ・進捗/セッションログ追跡・PRレビューを一元管理 (GitHub / Mobile / CLI / VS Code 横断)
- Copilot 有償サブスクリプションの枠内で、Copilot に加えてサードパーティ製エージェントも同一プラットフォームに統合していく (オープン・エコシステム)
- Custom agents で、用途別にプロンプト/ツール/コンテキストを最適化したエージェントを作成し、チーム共有可能
- VS Code の Plan Mode で、コード生成前にステップ分解した実装計画を作り、可視性と制御性を確保

References:

- [https://github.blog/news-insights/company-news/welcome-home-agents/](https://github.blog/news-insights/company-news/welcome-home-agents/)

## GitHub Copilot Premium Requests

- Premium request は機能ごとに消費単位が異なる (例: Chat=1 prompt、Coding Agent=1 session 等、モデル倍率あり) ([GitHub Docs][12])
- Premium Request が増える典型パターン
  - 高性能モデルの多用 / 大きすぎるタスク / 仕様が曖昧で往復が増える
- コスト最適化の実務
  - "雑談" を減らし、入力を構造化 (Spec/チェックリスト/受け入れ基準を先に渡す)
  - Agent に投げる前に CI ガードレール (lint/test/security) を整備し、リトライ回数を削減
  - 難しい問題だけに Premium を投下し、単純作業は標準モデル + Actions 自動化で吸収する

References:

- [https://docs.github.com/en/copilot/concepts/billing/copilot-requests](https://docs.github.com/en/copilot/concepts/billing/copilot-requests)

## GitHub Copilot Coding Agent

- できること: PR を新規作成/既存 PR を更新し、最終的に人間へレビュー要求 (開発フローにネイティブ統合) ([GitHub Docs][13])
- 使いどころ (エンジニア向け実務)
  - "小〜中" 粒度の変更 (リファクタ、テスト追加、ドキュメント整備、ルール適用) を **PR で受領**する
  - 変更指示は PR コメントで `@copilot` などを用いて差分駆動で反復 (レビュー効率が高い) ([GitHub Docs][14])
- 成功率を上げるコツ
  - 受け入れ基準 (DoD) と検証コマンド (`npm test` 等) を明示し、CI と一致させる
  - 変更範囲の境界 (触ってよい/悪いディレクトリ、互換性制約) を AGENTS.md に固定する

References:

- [https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)
- [https://docs.github.com/copilot/using-github-copilot/coding-agent/asking-copilot-to-create-a-pull-request](https://docs.github.com/copilot/using-github-copilot/coding-agent/asking-copilot-to-create-a-pull-request)

## AGENTS.md & Agent Skills

- AGENTS.md: コーディングエージェント向けの "README" という位置づけのオープンフォーマット ([エージェント.md][15])
- Agent Skills: 手順/スクリプト/規約をフォルダとして提供し、Copilot が状況に応じてロードできる (VS Code 連携) ([code.visualstudio.com][16])
- 推奨する AGENTS.md の中身 (例)
  - Persona: 役割/優先順位 (例: セキュリティ優先、互換性維持)
  - Tech Stack: 言語/フレームワーク/バージョン、依存関係の前提
  - Operational Commands: ビルド/テスト/リントのコマンド
  - Boundaries: 触れてはいけない領域、禁止事項 (secrets/破壊的変更)
- Context Engineering (実務要点)
  - 指示の置き場所を分散させず、**単一の規範 (AGENTS.md + Skills)** に集約
  - 受け入れ基準 (DoD) と検証手段 (コマンド、CI ジョブ) を明記し、推論の迷走を減らす
  - 背景: 長文コンテキストでは情報位置によって性能が落ちる (Lost in the Middle) ため、"重要情報を先頭/末尾に寄せる" 設計が効く ([arXiv][17])
  - 対策: 会話ログに埋め込まず、仕様/チェックリスト/状態を **ファイルに外部化** して参照させる (必要なら要約＝compaction)
  - "忘れる" 問題 (catastrophic forgetting) は古典的課題で、対策は外部化 (仕様/チェックリスト/状態管理) ([PubMed][18])

References:

- [https://agents.md/](https://agents.md/)
- [https://code.visualstudio.com/docs/copilot/customization/agent-skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [https://arxiv.org/abs/2307.03172](https://arxiv.org/abs/2307.03172)

## Spec Kit

- GitHub Spec Kit: Spec-Driven Development (SDD) を実装するためのツールキット (`specify` CLI、slash commands 等) ([GitHub][19])
- "複数エージェント前提" の設計 (Copilot / Gemini CLI / Codex CLI などを明示的にサポート) ([GitHub][20])
- 使い方の狙い: 要件→仕様→タスク→実装→検証、を **エージェントが辿れる形**に落とす (属人的プロンプトを減らす)
- 4 フェーズのイメージ
  - Specify: 曖昧さを質問で潰し、仕様 (Spec) を固める
  - Plan: 技術設計/作業手順を作り、人間がレビューして承認する
  - Task: 小さい単位に分割し、検証コマンドと紐づける
  - Implement: タスクごとに実装→検証を回す
- 補足: 交渉不可能なルール (例: 外部ライブラリ禁止、必須テスト) を "憲法" として別ファイル化すると強い

References:

- [https://github.com/github/spec-kit](https://github.com/github/spec-kit)

## Spec vs Plan?

- Spec (仕様) : **永続・レビュー可能・CIで検証可能**な成果物 (例: 受け入れ基準、I/O、制約、非機能)
- Plan (計画) : エージェントの作業手順 (揮発・状況依存) 。Plan は "仕様の代替" ではなく "仕様を実現するための手段"
- 接続 (現場の最適解)
  - SDD: Spec を先に固定し、Plan は短く回す (リトライ・改変に強い)
  - AI-DLC: AI 主導で提案→人間が承認する、という開発ライフサイクル再設計 (方法論として明文化) ([Amazon Web Services, Inc.][21])
  - Vibe Coding から脱却: 仕様と検証を先に置き、生成の揺らぎを吸収する

References:

- [https://github.com/github/spec-kit](https://github.com/github/spec-kit)
- [https://aws.amazon.com/jp/blogs/news/ai-driven-development-life-cycle/](https://aws.amazon.com/jp/blogs/news/ai-driven-development-life-cycle/)

## AI coding + CI/CD

- long-running tasks: エージェントが "作業を続ける" 前提で、CI は **途中成果を細かく検証** (lint→test→security→review)
- parallel execution (Actions 側)
  - matrix: 1 定義から複数ジョブを自動生成し、テスト/ビルドを並列化 ([GitHub Docs][22])
  - concurrency: 同一グループの実行を抑制し、ムダな実行をキャンセル (`cancel-in-progress`) ([GitHub Docs][23])
- ツールチェーン統合の到達点 (自律ループの例)
  - 検知: zizmor 等が危険パターンを検知
  - 参照: AGENTS.md / Spec を読み、制約を理解
  - 実行: Coding Agent が修正 PR を作成
  - 検証: Actions が必須チェックを実行 (Rulesets で強制)
  - レビュー: Copilot for PRs + 人間が最終判断
- parallel execution (AI 側の未来) : 複数エージェントを同時に走らせて比較/統合する "オーケストレーション" が前提に (Agent HQ / mission control) ([The GitHub Blog][24])

References:

- [https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/running-variations-of-jobs-in-a-workflow](https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/running-variations-of-jobs-in-a-workflow)
- [https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs](https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs)
- [https://github.blog/news-insights/company-news/welcome-home-agents/](https://github.blog/news-insights/company-news/welcome-home-agents/)

## Application to Business Process Outsourcing

- BPO の「手順化された作業」を、Spec (要件/入力/出力/禁止事項) として定義し、AI+自動化で再現性を上げる
- 典型ユースケース
  - 定型レポート生成・集計: 入力データ→変換→検証→出力 (Actions で定期実行、差分は PR でレビュー)
  - 運用手順書/ドキュメント整備: AGENTS.md/Skills にテンプレ化し、変更は Coding Agent に委譲
  - ルール更新 (依存関係/セキュリティ) : Dependabot + 必須チェックで "自動提案→人間承認" の流れへ
- ガバナンスの勘所
  - 「何を自動承認してよいか」を Rulesets/環境保護で定義し、例外は人間が判断する
  - コストは Premium Requests を可視化し、ROI が出る領域に集中投下する

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
