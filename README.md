# やったこと記録アプリ（iOSアプリ）

## 使用言語
Swift5(SwiftUI)

## アプリ仕様
- やったことを記録するアプリ（タイムログ）
  - やった内容と開始／終了時刻を入力して記録
    - 時分単位で入力
  - やった内容を一覧で表示
    - 削除可能（スワイプで削除ボタンを表示）
  - 記録データはSQLite3にて端末内で保持
  - CSV形式で共有可能

## 未実装（やりたいこと）
- やったことに対しての評価項目（A、B、C）
  - [ ] 一覧では背景色で表現（A：ピンク、B：黄、C：紫）
- 編集機能
  - [ ] 一覧項目をスワイプで編集ボタンを表示
  - [ ] 編集モードに切り替え
- 入力項目
  - [ ] 日付項目をタップ長押しで前回の終了時間をセット
  - [ ] 内容項目をタップ長押しで履歴一覧を表示後、選択内容をセット
- 一覧
  - [x] ~~曜日を表示~~
  - [x] ~~作業時間を表示~~
  - [ ] リスト内容をタップ長押しでコピー

## 画面
![スクショ](https://github.com/simgon/done-list/assets/23553796/8b4b570f-d4b9-465f-8684-c3572e7bed20)
