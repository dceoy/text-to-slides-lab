---
marp: true
title: Google Workspace Business Standardで利用可能なAI関連機能
description: 最新の公式ドキュメントに基づく整理 (2026-04-09時点)
footer: Google Workspace Business Standard AI Features (2026-04-09)
paginate: true
size: 16:9
theme: gradient
---

# Google Workspace Business Standardで利用可能なAI関連機能

最新の公式ドキュメントに基づく整理  
調査時点: 2026-04-09

- 対象: Google Workspace Business Standard
- 方針: **含まれる機能** と **別ライセンス/別条件** を分離して整理
- 形式: Marp Markdown

---

# 結論

Business Standard で、少なくとも次の AI 関連機能が利用可能です。

- **Gemini in Workspace**  
  Gmail / Calendar / Docs / Drive / Sheets / Slides / Meet / Chat / Vids / Forms
- **Gemini アプリ**  
  Gemini Advanced、Deep Research、Gems、Canvas、コード実行など
- **NotebookLM / NotebookLM Plus**
- **Google Workspace Studio**
- **AppSheet Core ライセンス由来の Gemini for App Creation**

一方で、**AppSheet の高度な AI 自動化 (Gemini in AppSheet Solutions) は Enterprise Plus が必要**です。

---

# 調査方針

本資料では、以下を区別しています。

## 1. Business Standard に標準で含まれるもの

- Google Workspace Business Standard のライセンスで使える AI 機能

## 2. 周辺製品だが追加条件があるもの

- AppSheet の上位ライセンス依存機能
- AI 利用上限やプロモーション枠の影響を受ける機能
- 管理者設定、年齢制限、ロールアウト状況に左右される機能

---

# Business Standard の位置づけ

Google の公式比較では、Business Standard は Business Starter に加えて次を含みます。

- **複数アプリでの Gemini AI アシスタント**
- **AI experts の team を作る機能**
- **AI research assistant と対話する機能**
- Meet の高度な会議機能

実務上は、これは概ね以下に対応します。

- Gemini in Workspace が Gmail 以外にも拡張
- Gemini アプリの高度機能
- NotebookLM / NotebookLM Plus
- Workspace Studio

---

# Gemini in Workspace 1/3

## Gmail

- サイドパネル
- Help me write
- Suggested Replies
- メールスレッドの AI Overview
- Help me schedule
- Proofread
- Salesforce for Gemini

## Calendar

- Help me schedule

## Docs

- サイドパネル
- Help me write
- 画像生成
- Help me create
- ドキュメント要約

---

# Gemini in Workspace 2/3

## Drive

- サイドパネル
- PDF の要約/分析

## Sheets

- サイドパネル
- **AI 関数 `=AI()` / `=Gemini()`**
- Enhanced Smart Fill

## Slides

- サイドパネル
- 画像生成
- 背景除去
- 文面のリライト/短縮

---

# Gemini in Workspace 3/3

## Meet

- Take notes for me
- Ask Gemini in Meet
- 翻訳字幕
- Adaptive audio
- 背景生成
- Studio sound / look / lighting

## Chat

- サイドパネル
- 会話要約
- 自動翻訳

## Vids / Forms

- Vids: AI avatars, AI video clips, voiceover, image generation, Help me create
- Forms: フォーム作成、質問生成、自由記述回答の要約・分析

---

# Gemini アプリ

Business Standard では Gemini アプリも対象です。

## 主な機能

- Gemini Advanced
- Deep Research
- Gems
- Edit and run code
- File upload and advanced data analysis
- Canvas
- 画像生成 (人物を含む)
- Audio Overviews
- Google Workspace apps 連携

## 連携でできること

- Gmail/Drive の情報検索・要約
- Google Tasks の参照/追加
- Google Keep のメモ/リスト操作
- Calendar の予定作成・検索・編集

---

# NotebookLM / NotebookLM Plus

## Business Standard で使えるもの

- NotebookLM
- **NotebookLM Plus**

## 主な用途

- PDF / Web / YouTube / 音声 / Google Docs / Google Slides をソースとして投入
- ソースに基づく Q&A
- 要約生成
- Audio Overview
- 引用付きの回答

## 実務上の位置づけ

- 調査、レビュー、ナレッジ整理、会議資料読み込みに向く
- Business Standard では「AI research assistant」の中核機能として捉えやすい

---

# Google Workspace Studio

Workspace Studio は、Google Workspace 上でフローを作り、AI エージェント的な自動化を行う機能です。

## Business Standard でできること

- Studio の利用
- フローの作成・実行
- Workspace 横断の自動化
- Gmail / Chat / Drive などの業務フロー統合

## 代表ユースケース

- 会議内容の要約を Chat に投稿
- Gmail 添付を Drive に保存し Sheets に記録
- 定型フォローアップメールの下書き作成

## 管理面

- 管理者が組織・OU・グループ単位で ON/OFF 可能

---

# AppSheet

## Business Standard で含まれるもの

- **AppSheet Core ライセンス** (ドメイン確認済みユーザー向け)

## AI 関連で使えるもの

- **Gemini for App Creation**  
  自然言語で業務要件を説明し、アプリのたたき台を作成

## 別ライセンスが必要なもの

- **Gemini in AppSheet Solutions** は **AppSheet Enterprise Plus** が必要
- 画像/PDF/テキストからの情報抽出や分類など、より高度な AI 自動化はこちら側

## 要点

- Business Standard だけで「AI でアプリの原型を作る」までは可能
- 本格的な AppSheet AI 自動化は別途上位ライセンス前提

---

# 利用上限と運用上の注意

Google は一部 AI 機能に利用上限を設定しています。

## Business Standard の代表例

- Workspace Studio: **400 flow executions / month**
- Audio overviews for PDFs: **20 / day**
- Vids avatar generation: **25 / month**
- Vids video generation: **50 / month**
- Nano Banana Pro in Slides / Vids: **30 / month**

## 注意

- AI Function in Sheets と Workspace Studio の一部上限は **2026-05-01 から執行開始**
- 一部機能は地域、言語、段階的ロールアウト、管理者設定に依存

---

# 管理・セキュリティ・コンプライアンス

Google の Privacy Hub によると、Business 向け Gemini/NotebookLM には次が適用されます。

- やり取りは組織内に留まる
- 既存の Workspace のエンタープライズ向け保護が適用される
- コンテンツは、許可なくドメイン外の生成 AI モデル学習に使われない
- 管理者は Gemini アプリ、NotebookLM、Workspace Studio などの利用可否を制御可能

## ただし

- NotebookLM は現時点で ISO / SOC / FedRAMP / HIPAA BAA 対応ではない
- NotebookLM は Workspace DLP と未統合

---

# 推奨する説明の仕方

Business Standard の AI を社内説明するなら、次の 4 層に分けると伝わりやすいです。

1. **日常業務支援**  
   Gmail / Docs / Meet / Chat / Forms
2. **分析・資料作成支援**  
   Sheets / Slides / Drive / Vids
3. **探索・調査支援**  
   Gemini アプリ / NotebookLM
4. **業務自動化・内製化**  
   Workspace Studio / AppSheet

---

# まとめ

Business Standard は、単なる「Gmail に AI が付く」プランではありません。

- Workspace 各アプリへの Gemini 組み込み
- Gemini アプリの高度機能
- NotebookLM Plus
- Workspace Studio
- AppSheet Core ベースの Gemini for App Creation

まで含む、**中堅組織向けの実務型 AI スイート**として整理できます。

ただし、AppSheet の高度 AI 自動化や一部の利用上限拡張は追加ライセンス前提です。

---

# 参考資料 (公式)

- Google Workspace Business edition 選択ガイド  
  https://knowledge.workspace.google.com/admin/getting-started/editions/choose-your-google-workspace-edition
- Gemini in Workspace / Gemini app / NotebookLM の機能比較  
  https://support.google.com/docs/answer/13952129
- Business editions の高度 AI 機能・利用上限比較  
  https://knowledge.workspace.google.com/admin/getting-started/editions/compare-business-editions
- Gemini AI features now included in Google Workspace subscriptions  
  https://knowledge.workspace.google.com/admin/gemini/gemini-ai-features-now-included-in-google-workspace-subscriptions
- NotebookLM を仕事用または学校用アカウントで使う  
  https://support.google.com/notebooklm/answer/16337734
- NotebookLM をユーザーに対して ON/OFF する  
  https://knowledge.workspace.google.com/admin/users/access/turn-notebooklm-on-or-off-for-users
- Google Workspace Studio 公式サイト  
  https://workspace.google.com/studio/
- Workspace Studio の利用制御  
  https://knowledge.workspace.google.com/admin/users/access/turn-google-workspace-studio-on-or-off-for-your-organization
- AppSheet の管理とライセンス  
  https://knowledge.workspace.google.com/admin/appsheet/manage-appsheet-in-your-organization
- Gemini in AppSheet  
  https://support.google.com/appsheet/answer/16106353
- Generative AI in Google Workspace Privacy Hub  
  https://knowledge.workspace.google.com/admin/gemini/generative-ai-in-google-workspace-privacy-hub
