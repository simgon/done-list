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
  - 一覧では背景色で表現（A：ピンク、B：黄、C：紫）
- 編集機能
  - 一覧項目をスワイプで編集ボタンを表示
  - 編集モードに切り替え

## 画面
![Simulator Screenshot - iPhone 14 Pro - 2023-07-08 at 22 34 01](https://github.com/simgon/done-list/assets/23553796/1c36d381-a9ca-48c6-b3ea-4d93569ba6dc)