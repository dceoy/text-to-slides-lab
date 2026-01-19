# AI coding with CI/CD on GitHub

## Contents

- [Executive Summary](#executive-summary)
- [AI Coding with CI/CD](#ai-coding-with-cicd)
- [GitHub Actions](#github-actions)
- [GitHub Actions Reusable Workflows](#github-actions-reusable-workflows)
- [Dependabot Pull Request](#dependabot-pull-request)
- [Dependabot Alerts](#dependabot-alerts)
- [Static analysis for GitHub Actions and Dependabot](#static-analysis-for-github-actions-and-dependabot)
- [GitHub Copilot](#github-copilot)
- [GitHub Copilot Coding Agent](#github-copilot-coding-agent)
- [Context engineering for GitHub Copilot](#context-engineering-for-github-copilot)
- [Spec-driven Development](#spec-driven-development)
- [What's Next](#whats-next)

## Executive Summary

- AI coding と CI/CD を組み合わせ、開発効率・品質を向上
  - CI/CD: GitHub Actions + Dependabot
  - AI coding: GitHub Copilot
- コードの静的解析による誤設定・リスクの早期検出
- AGENTS.md と Agent Skills による context engineering で出力品質を最適化
- Spec Kit による Spec-driven Development (SDD) で仕様起点の開発プロセスを実現

## AI Coding with CI/CD

- AI coding
  - 確率論的な生成・推論による実装/修正/レビュー
- CI/CD
  - 決定論的な自動化による修正・検証・デプロイ
- AI coding と CI/CD で開発効率・品質を向上させる
  - GitHub サービス:
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

- 再利用可能な GitHub Actions workflows
  - 概要: workflow の共通化/標準化 (DRY) -> 再利用
  - 定義: `.github/workflows/*.yml` に置き、`on: workflow_call` を宣言
    - `inputs`/`secrets`/`outputs` でインターフェースを固定 (input type は `boolean`/`number`/`string`)
  - 呼び出し: job から `jobs.<job_id>.uses` で呼ぶ
    - `{owner}/{repo}/.github/workflows/{file}@{ref}` / `./.github/workflows/{file}`
    - `with:` で inputs、`secrets:` で secrets、`secrets: inherit` で同一 org/enterprise の secrets を継承
    - `@ref` は commit SHA pin 推奨 (安定性/サプライチェーン対策)
  - 使い分け: reusable workflow は "job/複数 job" の再利用、composite action は "step" の再利用

References:

- [https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)
- [https://docs.github.com/en/actions/reference/reusable-workflows-reference](https://docs.github.com/en/actions/reference/reusable-workflows-reference)
- [https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action)

## Dependabot Pull Request

- 依存関係の更新自動化
  - 概要: 依存関係の更新を pull request (PR) として自動提案し、CI で検証して安全にマージ
    - Version updates: 定期実行で新バージョンを検知し、更新 PR を作成
    - Security updates: 脆弱性アラートに紐づく修正 PR を作成
  - 設定: `.github/dependabot.yml` で ecosystem / directory / schedule を定義
  - PR 運用: `open-pull-requests-limit` で同時に開く PR 数を制御 (version updates)
  - ノイズ削減: `groups` で複数更新を 1 PR にまとめる (version updates / security updates)
  - クールダウン: `cooldown` で更新を一定期間抑制 (version updates)

References:

- [https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference)
- [https://docs.github.com/en/code-security/concepts/supply-chain-security/about-dependabot-version-updates](https://docs.github.com/en/code-security/concepts/supply-chain-security/about-dependabot-version-updates)
- [https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file)
- [https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/configuring-dependabot-security-updates](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/configuring-dependabot-security-updates)
- [https://docs.github.com/en/code-security/concepts/supply-chain-security/about-dependabot-on-github-actions-runners](https://docs.github.com/en/code-security/concepts/supply-chain-security/about-dependabot-on-github-actions-runners)

## Dependabot Alerts

- 依存関係の脆弱性アラート
  - 概要: 依存関係の既知の脆弱性を検知し、更新/対応を促す
  - 検知: default branch をスキャンし、GitHub Advisory Database と dependency graph を突合
    - e.g., Advisory Database に新規脆弱性が追加 / dependency graph が更新
  - 表示: repo の Security tab / dependency graph
  - アラート内容: 影響ファイルへのリンク、脆弱性詳細と severity、修正版 (fixed version) 情報
  - 対応: Dependabot security updates の PR 作成 (有効時) / 手動更新、または理由付き dismiss・reopen
  - 通知: public repo はデフォルト有効、private repo は有効化が必要
    - 通知方法: web / email / CLI / mobile、auto-triage rules や digest でノイズ削減
  - 注意: archived repo は対象外、malware は対象外、GitHub Actions は semver tag のみ対象

References:

- [https://docs.github.com/code-security/dependabot/dependabot-alerts/configuring-dependabot-alerts](https://docs.github.com/code-security/dependabot/dependabot-alerts/configuring-dependabot-alerts)
- [https://docs.github.com/en/code-security/dependabot/dependabot-alerts/configuring-notifications-for-dependabot-alerts](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/configuring-notifications-for-dependabot-alerts)
- [https://docs.github.com/en/code-security/dependabot/dependabot-alerts/viewing-and-updating-dependabot-alerts](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/viewing-and-updating-dependabot-alerts)
- [https://docs.github.com/ja/code-security/concepts/supply-chain-security/about-dependabot-alerts](https://docs.github.com/ja/code-security/concepts/supply-chain-security/about-dependabot-alerts)
- [https://github.com/marketplace/actions/aqua-security-trivy](https://github.com/marketplace/actions/aqua-security-trivy)

## Static analysis for GitHub Actions and Dependabot

- GitHub Actions の静的解析
  - 概要: 誤設定/セキュリティリスクを検出
    - リスク: supply chain attack や command injection 等
  - 静的解析ツール
    - actionlint
      - GitHub Actions lint + shellcheck + pyflakes
    - zizmor
      - security scan for GitHub Actions
    - checkov
      - Software Composition Analysis (SCA) scan for IaC
    - trivy
      - Security scan and SBOM generation for IaC
    - pinact / ratchet
      - SHA pinning for GitHub Actions

References:

- [https://github.com/rhysd/actionlint](https://github.com/rhysd/actionlint)
- [https://github.com/zizmorcore/zizmor](https://github.com/zizmorcore/zizmor)
- [https://github.com/bridgecrewio/checkov](https://github.com/bridgecrewio/checkov)
- [https://github.com/aquasecurity/trivy](https://github.com/aquasecurity/trivy)
- [https://github.com/suzuki-shunsuke/pinact](https://github.com/suzuki-shunsuke/pinact)
- [https://github.com/sethvargo/ratchet](https://github.com/sethvargo/ratchet)

## GitHub Copilot

- 複数のモデルに対応した AI 開発支援
  - 機能:
    - Inline suggestions: エディタ上でコード補完
    - Copilot Chat: コードの説明・修正提案・テスト生成などを対話で支援
    - Copilot coding agent: issue を割り当てて自律的に実装/修正/PR 作成
    - Copilot CLI: ターミナルでの質問応答・コード生成・修正提案
    - Copilot code review: 変更差分へのフィードバックを生成
    - Copilot pull request summaries: PR の要約を自動生成
    - Copilot text completion: PR 説明文のテキスト補完
    - Copilot Edits: 指示に沿って複数ファイルの変更案を作成 (Edit / Agent mode)
    - Copilot custom instructions: コーディング規約/方針を指示に組み込み
    - Copilot Memory: リポジトリ情報を記憶して出力品質を向上
    - Copilot in GitHub Desktop: GitHub Desktop 上で commit message や説明の生成
    - Copilot Spaces: コード、ドキュメント等のコンテンツを整理して context を改善
    - GitHub Spark: 自然言語プロンプトでフルスタックアプリを構築・デプロイ
  - Premium requests: AI モデルや機能毎に消費されるリクエスト枠
    - Copilot Chat / Copilot CLI ではプロンプト毎にカウント

References:

- [https://docs.github.com/en/copilot](https://docs.github.com/en/copilot)
- [https://docs.github.com/en/copilot/about-github-copilot/what-is-github-copilot](https://docs.github.com/en/copilot/about-github-copilot/what-is-github-copilot)
- [https://docs.github.com/en/copilot/about-github-copilot/github-copilot-features](https://docs.github.com/en/copilot/about-github-copilot/github-copilot-features)
- [https://docs.github.com/en/copilot/using-github-copilot/using-copilot-chat/asking-github-copilot-questions-in-your-ide](https://docs.github.com/en/copilot/using-github-copilot/using-copilot-chat/asking-github-copilot-questions-in-your-ide)
- [https://docs.github.com/en/copilot/concepts/billing/copilot-requests](https://docs.github.com/en/copilot/concepts/billing/copilot-requests)

## GitHub Copilot Coding Agent

- GitHub 上で動く自律型 coding agent
  - 機能:
    - 指示に基づき実装/修正し、PR を作成/更新してレビュー依頼まで自動化
    - PR コメントで `@copilot` をメンションして反復修正を依頼
    - 1 タスク 1 PR、同一リポジトリ内のみ
  - 実行環境: GitHub Actions を利用して独自のエフェメラル開発環境
  - 観測性: セッションログで進捗/実行内容/検証結果 (セキュリティ検知含む) を追跡
  - 統制/セキュリティ:
    - 起動/フィードバックは write 権限ユーザのみ
    - push は `copilot/` ブランチのみ (`main`/`master` へは push しない)
    - Actions workflows は自動実行されず、レビュー後に `Approve and run workflows` が必要
  - UI は違うが Anthropic Claude や OpenAI Codex にも似た機能がある
  - 将来的には Agent HQ でサードパーティ製 coding agents を使えるようになる ?

References:

- [https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)
- [https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-a-pr](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-a-pr)
- [https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/track-copilot-sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/track-copilot-sessions)
- [https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/review-copilot-prs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/review-copilot-prs)
- [https://github.blog/news-insights/company-news/welcome-home-agents/](https://github.blog/news-insights/company-news/welcome-home-agents/)

## Context engineering for GitHub Copilot

- Context engineering
  - LLM に渡す指示・根拠知識・状態・制約・ツール定義を設計/生成/配信して出力品質を最適化
    - context window に入らない情報は忘れられる
    - Lost in the middle: context の中間付近にある情報は参照されにくい
    - context の圧縮や外部化が重要
  - LLM は固定された pre-trained model であり、実務レベルの調整は prompt/context に依存
    - fine-tuning はコスト高・汎用性低・更新困難で非現実的な選択肢になりつつある
  - GitHub Copilot での実践
    - AGENTS.md
      - Agent 向けの instructions ファイル (Markdown)
      - 階層配置でき、最も近いファイルが適用 (サブディレクトリで上書き)
      - Copilot Chat / coding agent / Copilot CLI の Agent instructions (`AGENTS.md` / `CLAUDE.md` / `GEMINI.md`)
    - Agent Skills
      - タスク特化の手順・判断基準・スクリプト等をスキルとしてパッケージ化し、必要時に context へ注入
      - 置き場所: `.github/skills/<skill>/SKILL.md` または `.claude/skills/<skill>/SKILL.md`
      - 個人用: `~/.copilot/skills` または `~/.claude/skills` (coding agent / Copilot CLI のみ)
      - `SKILL.md` は YAML frontmatter (`name` / `description` 等) + 本文で定義し、Copilot が自動選択
    - MCP server
      - Model Context Protocol: agent から外部の tools/resources/prompts を呼び出すための標準プロトコル
      - ローカルまたはリモートに立てた MCP server に接続して使用
      - Agent Skills より context 消費が大きくなりやすいので注意
  - Claude Code では subagents という機能もあるがまだ標準化されていない

References:

- [https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [https://arxiv.org/abs/2307.03172](https://arxiv.org/abs/2307.03172)
- [https://agents.md/](https://agents.md/)
- [https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
- [https://code.visualstudio.com/docs/copilot/customization/agent-skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [https://docs.github.com/en/copilot/reference/custom-instructions-support](https://docs.github.com/en/copilot/reference/custom-instructions-support)
- [https://docs.github.com/en/copilot/concepts/agents/about-agent-skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
- [https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/extend-coding-agent-with-mcp](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/extend-coding-agent-with-mcp)
- [https://modelcontextprotocol.io/specification/latest](https://modelcontextprotocol.io/specification/latest)
- [https://code.visualstudio.com/api/extension-guides/ai/mcp](https://code.visualstudio.com/api/extension-guides/ai/mcp)

## Spec-driven Development

- Spec-driven Development (SDD)
  - 仕様 (Spec) を Source of Truth として扱い、コード生成・変更の起点を仕様に置く開発プロセス
    - 推測作業や予期せぬ事態は減り、コードの品質は向上する
  - Spec Kit
    - GitHub が公開した SDD 用 OSS toolkit (`github/spec-kit`)
      - Specify CLI + テンプレ/ガードレールで spec/plan/tasks を生成
      - `.specify/` に constitution とテンプレを配置し、以後の判断基準を固定 (`.specify/memory/constitution.md`)
      - `/speckit.specify` (+ `/speckit.clarify`) -> `specs/<feature>/spec.md` (requirements / user stories / acceptance criteria)
      - `/speckit.plan` -> `specs/<feature>/plan.md` + `research.md`/`data-model.md`/`contracts/`/`quickstart.md` など
      - `/speckit.tasks` -> `specs/<feature>/tasks.md` (依存関係/テスト/並列 `[P]` などを含む実行可能なタスクリスト)
      - `/speckit.implement`  ->  `tasks.md` に沿って実装を進める
  - Spec-driven Development vs Plan mode?
    - 形態: spec はリポジトリに残る成果物 (`spec.md`) / Plan は AI の動作モード (計画の生成・保存はできるが SOT ではない)
    - 役割: spec は「何を/何故」(要求・受け入れ基準) / Plan は「どう進める」(実装ステップ・未決事項の整理)
    - 粒度: spec はプロダクト/機能仕様 (レビュー対象) / Plan は特定変更の作業計画 (実行・分割が目的)
    - 位置付け: spec を起点に plan/tasks を派生 / Plan は "計画 -> 承認 -> 実装" を支援するが artifacts の体系化は必須ではない

References:

- [https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)
- [https://github.com/github/spec-kit](https://github.com/github/spec-kit)
- [https://github.github.io/spec-kit/](https://github.github.io/spec-kit/)
- [https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide](https://docs.github.com/en/copilot/using-github-copilot/asking-github-copilot-questions-in-your-ide)
- [https://code.visualstudio.com/docs/copilot/chat/chat-planning](https://code.visualstudio.com/docs/copilot/chat/chat-planning)

## What's Next

- 非同期・並列・自律的に長時間稼働
  - [Cursor での事例](https://cursor.com/blog/scaling-agents)
    - 数百の agent を同一コードベースに同時投入し、数週間スケールで自律的に開発を継続
    - 例:
      - Web ブラウザ実装: 約 1 週間で 1,000 files / 1M+ LoC
      - Solid -> React 移行: 3 週間超 (追加 +266K / 削除 -193K LoC)
      - video rendering の Rust 化: 25x 高速化
      - (進行中) Java LSP / Windows 7 emulator / Excel など、数十万〜百万 LoC 規模の生成
    - 協調の設計ポイント:
      - 共有ファイル + lock による自己調整はボトルネックになりやすく、壊れやすい
      - optimistic concurrency control (衝突したらリトライ) だけでは、難しいタスクが放置される (責任不在/リスク回避) 問題が残る
      - planner (計画) / worker (実装) / judge (継続判断) を分離し、planning 自体も並列化/階層化してスケール
    - 運用上の課題:
      - drift (逸脱) / tunnel vision (視野狭窄) 対策として periodic fresh starts (定期的に新しい agent で再開)
      - タスク完了に応じて planner を起こして再計画する仕組みが未成熟 (agent が走りすぎる問題等)
- ソフトウェア開発以外への応用
  - AI-native SaaS
  - Business Process Automation
  - Physical AI / Embodied AI

References:

- [https://cursor.com/blog/scaling-agents](https://cursor.com/blog/scaling-agents)
