---
marp: true
title: GitHub Copilot Enterprise のAI関連機能カタログ
description: Copilot Chat / Copilot CLI / Copilot cloud agent ほか、GitHub Copilot Enterpriseで利用可能な機能を公式ドキュメントベースで整理 (2026-04-09時点)
footer: GitHub Copilot Enterprise AI Features (2026-04-09)
paginate: true
size: 16:9
theme: gradient
---

# GitHub Copilot Enterprise

## AI関連機能カタログ (公式Docs準拠)

- 対象：GitHub Enterprise Cloud + GitHub Copilot Enterprise
- 目的：利用可能な機能を**網羅的に棚卸し**し、導入・運用設計に使える粒度で整理
- 参照：GitHub公式ドキュメント (末尾にリンク集)

---

## この資料の読み方 (重要)

- **「Copilot Enterpriseで利用可能」＝ Enterpriseプランに含まれる/有効化できる機能**  
  (一部は _public preview_ / _technical preview_ を含む)
- 機能は「どこで使うか (Surface)」と「何ができるか (Capability)」で整理
- 同名・改称を明示
  - _Copilot coding agent_ は **Copilot cloud agent** に改称 (旧称としてドキュメントに併記)

---

## エグゼクティブサマリ (1枚で)

Copilot Enterpriseで押さえるべき柱は以下：

1. **開発支援 (IDE)**：補完、Chat、Edit/Agent mode、コード参照、インデクシング
2. **GitHub上の自律エージェント**：Copilot cloud agent (Issue→PR、@copilotでPR修正)
3. **レビュー自動化**：Copilot code review / PR summary (英語のみの制約あり)
4. **端末 (Copilot CLI)**：ターミナル常駐＋エージェント、MCP/Skills/Hooksで拡張
5. **コンテキスト戦略**：Spaces / Repository indexing / Custom instructions / Prompt files
6. **ガバナンス**：AI Controls、ポリシー、監査ログ、利用状況メトリクス
7. **拡張エコシステム**：MCP、Custom agents/skills、Third-party agents、Copilot SDK
8. **周辺AI機能**：Spark (プレビュー)、Copilot Autofix (Code Security連携)

---

## 目次

1. Surface (利用場所) マップ
2. コア機能 (Chat / IDE補完)
3. Agents (cloud agent / agent mode / third-party agents)
4. Code Review / PR Summaries
5. Copilot CLI (ターミナル)
6. Context & Customization (Spaces / MCP / instructions / prompt files / skills / hooks)
7. 管理・統制 (AI Controls / ポリシー / 監査 / メトリクス / モデル)
8. 付録：公式リンク集

---

# 1. Surfaceマップ

---

## Copilotを使う場所 (Surface)

Copilotは以下のSurfaceで利用される (機能・制約が異なる)：

- **IDE** (VS Code / JetBrains / Visual Studio / Xcode / Eclipse ほか)
- **GitHub.com** (Copilot Chat、cloud agent、code review、PR summaries 等)
- **Copilot CLI** (ターミナル：対話＋自律実行)
- **GitHub Mobile** (Chat/agentセッション)
- **Windows Terminal (Canary)** (Terminal Chat)
- **GitHub Desktop** (コミットメッセージ生成)

---

## 主要機能の配置 (概念図)

| 領域    | 主な機能                                             | 主なSurface                          |
| ------- | ---------------------------------------------------- | ------------------------------------ |
| Chat    | Copilot Chat、Slash commands、画像入力 (対応箇所)    | IDE / GitHub.com / Mobile / Terminal |
| Coding  | Inline suggestions、Next edit suggestions、Edit mode | IDE                                  |
| Agents  | cloud agent、agent mode、third-party agents          | GitHub.com / IDE / Mobile            |
| Review  | Copilot code review、PR summaries                    | GitHub.com / IDE (プラグイン)        |
| Context | Spaces、Repo indexing、Code referencing、MCP         | GitHub.com / IDE / CLI / agent       |
| Admin   | AI Controls、Policies、Audit logs、Usage metrics     | GitHub.com (管理画面/API)            |

---

# 2. コア機能 (Chat / IDE補完)

---

## IDE：コード補完 (Inline suggestions)

- エディタ内で**リアルタイムにコード提案** (言語/拡張機能に依存)
- 関連機能：
  - **Next edit suggestions** (次に編集すべき候補を提示)
  - **Code referencing** (リポジトリ内の類似コードの参照)
  - **Workspace/Repository indexing** (意味検索・文脈把握のための索引化)

> 実際の対応状況はIDE別の「Copilot feature matrix」で確認するのが最短ルート。

---

## Copilot Chat (IDE / GitHub.com / Mobile)

Copilot Chatで代表的にできること：

- コードの説明、バグ修正、テスト生成、設計相談
- 既存コードベースを前提にしたQ&A (@workspace などのコンテキスト支援)
- スラッシュコマンド (例：/explain, /fix, /tests など)
- 一部Surfaceでは**画像入力** (スクショ/図/モックから説明やコード生成)

---

## GitHub.com：Copilot Chat (リポジトリ検索から起動)

- GitHub.com上の検索ボックスで `repo:OWNER/REPO` の後に質問→「Ask Copilot」
- リポジトリ全体を対象に「どこに実装があるか」「何をしているか」を質問可能
- 添付 (リポジトリ/画像 等) により、回答をグラウンディング可能

---

# 3. Agents (cloud agent / agent mode / third-party agents)

---

## 用語整理：Agentの2系統

- **Copilot cloud agent (旧：Copilot coding agent)**
  - GitHub Actionsベースの**エフェメラル環境**で非同期に作業→PR作成
- **Agent mode (IDE)**
  - ローカル開発環境上で、Copilotが自律的に編集・実行提案し反復

> 「どこで実行されるか (GitHub上 / ローカル)」が最大の差分。

---

## Copilot cloud agent (GitHub.comでの自律開発)

できること (代表)：

- リポジトリ調査、実装計画作成、ブランチ作成、コード変更
- テスト/リンター実行 (GitHub Actions上の環境)
- Issue割当て → 自動でPR作成
- 既存PRに `@copilot` で変更依頼 (反復可能)
- セキュリティアラート (例：キャンペーン) を割当てて修正案作成

運用上の勘所：

- **レビュー前提** (差分確認・反復・PR化のゲートを人間が持つ)

---

## Third-party coding agents (public preview)

Copilot cloud agentと並行して利用できる「外部コーディングエージェント」：

- 対応例：**Anthropic Claude / OpenAI Codex**
- 起動場所：
  - GitHub.comのAgentsタブ
  - Issuesへのアサイン
  - PRコメントで `@AGENT_NAME`
  - GitHub Mobile からのエージェントセッション開始

注意：

- public preview (変更可能)
- 利用にはポリシーでの有効化が必要 (組織/エンタープライズ)

---

## Copilot Memory (public preview)

- Copilotがリポジトリの規約・パターン・好み等を推論して**「記憶 (memories)」として保持**
- 現時点の利用先 (例)：
  - Copilot cloud agent
  - Copilot code review
  - Copilot CLI
- 期待効果：
  - 同じ文脈説明の繰り返しを削減し、継続作業の生産性を上げる

---

# 4. Code Review / PR Summaries

---

## Copilot code review

- PRを複数観点でレビューし、指摘・改善案 (可能なら差分提案) を提示
- GitHub.com上でReviewersにCopilotを追加して実行可能
- **自動レビュー** (条件に応じて自動でレビュー要求) も構成可能

カスタマイズ：

- `.github/copilot-instructions.md` 等の**カスタム指示**をレビューに適用
- 注意：指示ファイルの読み取り長など、制約あり

---

## Copilot pull request summaries (英語のみ)

- PRの差分をスキャンし、
  - 変更概要 (文章)
  - 主要変更点 (箇条書き＋該当ファイル/行へのリンク)
    を生成
- 生成場所：
  - PR作成時のdescription
  - 既存PRのdescription編集
  - PRタイムラインのコメント

注意：

- **英語のみ** (公式に明記)

---

# 5. Copilot CLI (ターミナル)

---

## Copilot CLI：位置づけ

- ターミナルからCopilotを使うための**専用CLI** (旧：GitHub CLI拡張はretired)
- できること：
  - 質問応答、コード生成/デバッグ
  - ローカルファイルの読取・変更・実行 (信頼ディレクトリの確認あり)
  - GitHub.com操作 (例：PR一覧、Issue作成、PR作成依頼 等)

---

## Copilot CLI：モード

- **Interactive**：`copilot` で対話セッション開始
- **Programmatic**：自動化・CI等からの呼び出し

運用の勘所：

- セッション中はファイル読取/変更/実行が起こり得るため、
  - 信頼ディレクトリ管理
  - 権限/Allowlist設計
  - 監査 (ログ/メトリクス)
    が必須。

---

## Copilot CLI：拡張 (Tools / Agents / Skills / MCP)

Copilot CLIは、作業を進めるために「ツール」を使う設計になっている：

- built-inツール (検索、読取、編集、実行 等)
- **MCPサーバ**で外部ツール/データソースを追加可能
- **Agent skills**：特定タスク向けの手順・スクリプト・リソースをフォルダ単位で提供
- **Custom agents / Hooks**：エージェントの振る舞い・実行前後処理をカスタム

---

## Copilot CLI：BYOK (Bring Your Own Key)

- Copilot CLIは**自前のLLMプロバイダAPIキー** (BYOK) で動作可能
  - OpenAI互換、Azure OpenAI、Anthropic、ローカル (例：Ollama) 等の接続も想定
- BYOK利用時は、GitHub認証が不要になる一方、
  - GitHub連携系の一部機能が使えない (制約あり)

---

# 6. Context & Customization (効きやすさを設計する)

---

## Copilot Spaces (コンテキストの「パッケージ化」)

- コード、PR、Issue、ノート、画像、ファイルアップロード等をまとめて**Space**化
- Copilot Chatの回答を、そのSpaceの文脈に**グラウンディング**
- 共有：
  - チーム内共有
  - 公開共有 (用途により)

> 「オンボーディング」「引き継ぎ」「調査ノート＋実装の接続」に効く。

---

## Repository indexing (インデクシング)

- リポジトリを索引化し、Copilotが**意味ベースで探索**できるようにする
- 期待効果：
  - 質問への精度向上
  - 参照コード探索の改善
  - agent/cloud agentの調査効率改善

---

## Custom instructions (指示の階層化)

代表的なレイヤ：

- **Repository**：`.github/copilot-instructions.md` など (全体指示)
- **Path-specific**：`.github/instructions/*.instructions.md` (範囲指定)
- **Organization/Enterprise**：標準化・コンプラ/セキュリティ方針の反映

狙い：

- “プロンプト依存” を減らし、組織規約をデフォルト化する。

---

## Prompt files (再利用可能なプロンプト資産)

- `.github/prompts/*.prompt.md` に、よくあるタスク用のプロンプトを保存
- 例：レビュー、APIドキュメント生成、アクセシビリティ監査…など
- チームで「プロンプトの標準化/再利用」を可能にする

---

## MCP (Model Context Protocol)：拡張の基盤

- MCPは「LLMにコンテキスト/ツールを渡す」ための**オープン標準**
- Copilotの主要Surface横断で利用：
  - IDE / Copilot CLI / GitHub.comのagent
- GitHubが提供する **GitHub MCP Server** と **MCP Registry** があり、
  - 利用許可・制限 (Allow/Block/Registry制限) を組織/企業で統制可能

---

## Agent skills / Hooks / Custom agents (エージェント最適化)

- **Skills**：特定タスク向けの手順・スクリプト・資料 (フォルダ)
- **Hooks**：エージェント実行の要所でシェルコマンドを走らせる (検証/監査/自動化)
- **Custom agents**：役割特化のエージェントを複数作る (例：Frontend専門、QA専門)

→ “賢いだけのAI” を “組織で使える実務AI” にする領域。

---

# 7. 管理・統制 (Enterprise運用で必須)

---

## ポリシーとAI Controls

- Enterprise/Organization側で、機能ごとに有効/無効を制御可能  
  例：
  - Copilot Chat
  - Copilot CLI
  - Copilot code review
  - PR summaries
  - cloud agent / third-party agents
  - MCPの利用 (Registry制限含む)
- 監査・可視化：
  - 監査ログ (設定/ライセンス等の変更追跡)
  - 利用状況メトリクス (採用・利用・コード生成 等)

---

## モデル運用 (選択・制御・BYOK)

- Copilotは複数モデルを提供し、用途に応じて選択/自動選択が可能
- Enterpriseでは以下を設計対象にする：
  - 利用可能モデルの絞り込み (セキュリティ/コスト/品質)
  - **BYOK** (LLMプロバイダAPIキー) で組織にカスタムモデルを提供 (プレビュー)
  - レート制限/課金 (premium requests、モデル倍率、Spark固定倍率 など)

---

# 8. 周辺AI機能 (Enterpriseで俯瞰しておく)

---

## GitHub Spark (public preview)

- 自然言語プロンプトで**フルスタックアプリ**を作って公開・共有するプラットフォーム
- Enterpriseでは、AI Controlsで有効化し、利用状況・課金を監視する前提
- 制約例：
  - data residency利用企業では未提供のケースがある (公式注記あり)

---

## Copilot Autofix (Code Security連携)

- Code scanning (CodeQL等) のアラートに対して、
  - LLMで修正案 (パッチ) を提案
- 前提：
  - GitHub Enterprise Cloud + Code Security有効化等 (リポジトリ種別/設定に依存)

> Copilot Enterprise導入時は、**DevSecOpsの修正フロー**に組み込む価値が高い。

---

# まとめ

---

## まとめ：導入・運用設計のチェックリスト

- Surfaceごとの利用方針を決める (IDE / GitHub.com / CLI / Desktop / Mobile)
- Agent戦略 (cloud agent / agent mode / third-party agents) を分離して設計
- Context資産を整備 (Spaces / indexing / prompt files / instructions)
- 拡張・統制 (MCP / skills / hooks / custom agents) を標準化
- ガバナンス (AI Controls / policies / audit / metrics / model & cost) を先に敷く
- セキュリティ連携 (Autofix等) をSDLCに統合

---

# 付録：公式リンク集 (主要)

---

## 主要ドキュメント (入口)

- GitHub Copilot 概要・機能一覧：https://docs.github.com/en/copilot/get-started/features
- Copilot Enterprise/Plans：https://docs.github.com/en/copilot/get-started/plans
- Copilot feature matrix (IDE別対応)：https://docs.github.com/en/enterprise-cloud@latest/copilot/reference/copilot-feature-matrix

---

## Chat / CLI / Agents

- Copilot Chat (GitHub上)：https://docs.github.com/en/enterprise-cloud@latest/copilot/using-github-copilot/asking-github-copilot-questions-in-github
- Copilot CLI (概要)：https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli
- Copilot CLI (How-to)：https://docs.github.com/en/copilot/how-tos/copilot-cli
- cloud agent (概要)：https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent
- third-party agents：https://docs.github.com/en/copilot/concepts/agents/about-third-party-agents
- Copilot Memory：https://docs.github.com/en/copilot/concepts/agents/copilot-memory

---

## Review / Context / Customization

- Copilot code review (概要)：https://docs.github.com/en/copilot/concepts/agents/code-review
- PR summaries (責任ある利用の説明)：https://docs.github.com/en/copilot/responsible-use/pull-request-summaries
- Copilot Spaces：https://docs.github.com/en/copilot/concepts/context/spaces
- Repository indexing：https://docs.github.com/en/copilot/concepts/indexing-repositories-for-copilot-chat
- Custom instructions (repo)：https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot
- MCP (概念)：https://docs.github.com/en/copilot/concepts/context/mcp
- MCP管理 (組織/企業)：https://docs.github.com/en/copilot/concepts/mcp-management
- Agent skills：https://docs.github.com/en/copilot/concepts/agents/about-agent-skills

---

## 管理・統制 / 周辺

- Enterprise管理 (入口)：https://docs.github.com/en/copilot/managing-copilot/managing-copilot-for-your-enterprise
- BYOK (EnterpriseでAPIキー持込)：https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-your-own-api-keys
- Spark (概要)：https://docs.github.com/en/copilot/concepts/spark
- Copilot Autofix (code scanning)：https://docs.github.com/en/enterprise-cloud@latest/code-security/concepts/code-scanning/copilot-autofix-for-code-scanning
