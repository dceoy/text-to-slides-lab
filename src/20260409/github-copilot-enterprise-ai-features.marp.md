---
marp: true
title: GitHub Copilot Enterprise - AI関連機能カタログ（公式Docsベース）
description: Copilot Chat / Copilot CLI / Copilot cloud agent / AgentHQ(=agent management) など、GitHub Copilot Enterpriseで利用可能なAI機能の網羅整理
footer: GitHub Copilot Enterprise AI Features (2026-04-09)
paginate: true
size: 16:9
theme: gradient
---

# GitHub Copilot Enterprise

## AI関連機能カタログ（公式Docsベース）

- 対象：Copilot Enterpriseで利用可能な主要AI機能（プレビュー含む）
- 作成日：2026-04-09
- 出典：GitHub公式ドキュメント／公式GitHubサイト

---

## 本資料のスコープ

- 「機能カタログ」＝ _どこで_ 使えるか（Surface）× _何が_ できるか（Capability）を整理
- Enterprise固有：**ポリシー管理／アクセス制御／監査ログ／利用状況・メトリクス**等のガバナンス
- プレビュー表記：公式Docsで _public preview_ とされる機能は、その旨を明記

> 注：実際の有効化可否は、Enterprise/Orgポリシーとリポジトリ設定（opt-out等）に依存

---

## 全体像（Surface × Capability）

| Surface                                                | 主なAI機能                                                                                                |
| ------------------------------------------------------ | --------------------------------------------------------------------------------------------------------- |
| IDE（VS Code / JetBrains / VS / Eclipse / Xcode など） | Inline suggestions、Copilot Chat、（IDEの）agent mode、カスタム指示・プロンプト                           |
| GitHub.com                                             | Copilot Chat、PRサマリ、Copilot code review、Copilot cloud agent、Agents/agent management、Copilot Spaces |
| ターミナル                                             | Copilot CLI、Windows Terminal の Copilot Chat                                                             |
| GitHub Desktop                                         | コミットメッセージ／説明文生成                                                                            |
| 拡張・連携                                             | MCP（Model Context Protocol）、Skills、Hooks、Plugins、BYOモデル/キー、Copilot SDK（preview）             |
| 生成開発（preview）                                    | GitHub Spark（自然言語でフルスタック構築）                                                                |

---

## Copilot Chat（対話型支援）

**提供面（どこで使えるか）**

- GitHub.com / GitHub Mobile / 対応IDE / Windows Terminal で利用可能

**主な用途（何ができるか）**

- コード・設計・デバッグ・テスト・ドキュメント作成のQ&A
- 「skills / keywords」により、よくあるタスクを素早く実行（環境により差分あり）

---

## IDE向け：コーディング支援（同期型）

- **Inline suggestions**：入力中に自動補完スタイルで提案（多様なIDE/エディタをサポート）
- **Next edit suggestions**：次の編集箇所を予測して提案（VS Code / Xcode / Eclipse など）
- **IDEの agent mode**：ローカル環境で自律的に編集・実行・自己修正（cloud agent とは別概念）
- **カスタム指示 / プロンプトファイル**：チーム規約・テスト手順・レビュー観点などを“定常知”として注入

---

## GitHub.com向け：レビューとPR生産性

- **Copilot code review**：多角的観点でレビュー指摘＋提案（クリック適用等）
- **Copilot pull request summaries**：差分の要点、影響ファイル、レビュー観点を要約
- **Commit message generation**：選択した変更内容からコミットタイトル/説明文を生成
- **Copilot Chat in GitHub**：PR/Issue/Repoなど“今いる文脈”を前提にQ&A

---

## Copilot cloud agent（旧：Copilot coding agent）

**コンセプト**

- GitHub Actionsベースの一時的な開発環境で、タスクを“バックグラウンド”で自律遂行

**できること（例）**

- リポジトリ調査、実装計画作成、バグ修正、機能追加、テスト拡充、ドキュメント更新、技術的負債対応、マージ衝突解消 など

**ワークフロー**

- 調査→計画→ブランチ上で変更→差分レビュー→反復→PR作成

---

## cloud agent：起点（エントリポイント）

- GitHub.com の **Agents tab / Agents panel** からタスク開始
- Issue へアサインしてタスク実行
- 既存PRコメントで `@copilot` メンションして修正依頼
- 一部は VS Code 等からも起動可能（PR作成など）

---

## AgentHQ / agent management（統制・運用の司令塔）

> GitHubの発信では「Agent HQ / Mission Control」等として紹介される概念を、
> 公式Docs上の機能要素としては **agent management**（集中管理ページ）で捉える。

- **agent management**：複数エージェントセッションへジャンプし、進捗確認・切替を一元化
- **Agents tab**：新規タスク投入、作業状況のモニタリング

---

## Third-party coding agents（public preview）

- Copilot cloud agent と並行して **第三者のコーディングエージェント**も利用可能（プレビュー）
- 既存Issueを割当て／プロンプト投入 → エージェントがPR作成 → レビュー依頼 → コメントで反復指示
- 利用場所：Agents tab、Issues、PRコメント（`@AGENT_NAME`）、GitHub Mobile、VS Code など

---

## Copilot CLI（ターミナルのエージェント基盤）

- ターミナルで `copilot` を起動し、フォルダ配下のファイルを対象に作業
- 対話（interactive）／非対話（non-interactive）をサポート
- ローカルファイルの変更・実行まで踏み込むため、**信頼できるディレクトリ**前提
- GitHub.com操作（例：PR一覧、Issue作成、PR作成）も支援

---

## Copilot CLI：拡張（Agents / Skills / Hooks / MCP / Plugins）

- **Custom agents**：特定の規約・領域に最適化したエージェント定義
- **Agent skills**：`SKILL.md`＋スクリプト等で専門タスク能力を追加（オープン標準）
- **Hooks**：エージェント実行の節目でシェルコマンドを実行し挙動を拡張
- **MCP servers**：外部システムのツール/リソースを接続して文脈・実行能力を拡大
- **Plugins / Marketplace**：CLIに“アプリストア”型の拡張機構（複数マーケットプレイス登録可）

---

## Context強化：Copilot Spaces

- タスク単位の“コンテキスト集合”を **Space** として整理（Repo / PR / Issue / テキスト / 画像 / アップロード等）
- Spaceの文脈で Copilot に質問し、チーム共有・公開も可能
- IDEからも（リモートGitHub MCPサーバ経由で）Spaceを参照可能

---

## Context強化：MCP（Model Context Protocol）

- Copilotを外部システムへ接続し、**ツール実行**と**データ参照**を拡張するプロトコル
- **GitHub MCP server**：リポジトリ内容などを“リソース”として提供
- **MCP Registry**：利用するMCPサーバを登録・管理
- Chat側では `/mcp.server.prompt` のようなスラッシュコマンドが提供される場合あり

---

## モデル選択・カスタムモデル（Enterprise観点）

- **Copilot auto model selection**：Chat / cloud agent 等でモデルを自動選択する仕組み
- **AIモデルのアクセス制御**：利用可能モデルをポリシーとして管理
- **BYO（Bring Your Own Key）**：
  - Enterprise：自社のLLM APIキーを統合し、組織へ提供可能
  - CLI：OpenAI互換/ Azure OpenAI / Anthropic / ローカル（例：Ollama）等へ接続可能

---

## ガバナンス（Enterprise管理者向け）

- **Policy management**：機能・モデルの有効化/無効化、制約（ガードレール）設定
- **Access management**：Org単位・ユーザ単位でライセンス/利用範囲を制御
- **Usage data / metrics**：利用状況、（cloud agent の）PR成果指標などを把握
- **Audit logs**：監査ログで操作履歴を追跡
- **Exclude files / content exclusion**：Copilotへ見せないファイルを設定

---

## Copilot SDK（public preview）

- Copilotを利用したアプリケーションを、任意言語/環境で開発するためのSDK
- ストリーミング応答、ツール実行、（SDK側の）hooks などを通じて統合を実装
- 企業内ツール（例：開発支援Bot、社内手順の自動化）への組込みを想定

---

## まとめ：導入・展開の実務ガイド（例）

1. **ベース機能**：IDE（Chat/補完）＋GitHub.com（Chat/PRサマリ）を全社展開
2. **レビュー強化**：Copilot code review を限定Repoでパイロット → ガイドライン整備
3. **自律化**：cloud agent を“バックログ処理”用途で段階導入（opt-out / 制約を明確化）
4. **拡張**：Spaces / MCP / Skills / CLI plugins による業務固有ワークフローの最適化
5. **統制**：ポリシー、監査、利用指標で “安全・再現性・ROI” を運用管理

---

## 参考（公式）

- Features: https://docs.github.com/en/copilot/get-started/features
- Copilot cloud agent: https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent
- Agent management: https://docs.github.com/en/copilot/concepts/agents/cloud-agent/agent-management
- Third-party agents: https://docs.github.com/en/copilot/concepts/agents/about-third-party-agents
- Copilot CLI: https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-getting-started
- Copilot Spaces: https://docs.github.com/en/copilot/concepts/context/spaces
- MCP: https://docs.github.com/en/copilot/concepts/context/mcp
- Agent skills: https://docs.github.com/en/copilot/concepts/agents/about-agent-skills
- Hooks (agents): https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/use-hooks
- BYO keys (enterprise): https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-your-own-api-keys
- Policies: https://docs.github.com/en/copilot/concepts/policies
- Copilot SDK: https://docs.github.com/en/copilot/how-tos/copilot-sdk/sdk-getting-started
