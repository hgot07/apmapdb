# Access Point map database support tools 

## 機能概要
`apmap-eduroamJP.pl` は、Cityroam仕様の基地局管理シートを元に、
eduroam JP申請システム向けに基地局マップデータを作成するための、
支援ツールです。

`apmap-kml.pl` は、Cityroam仕様の基地局管理シートを元に、
Google mapsのKMLファイルを作成するための、支援ツールです。
KMLファイルのPlacemarkブロックのみ出力します。

## Cityroam仕様の基地局管理シートについて
基地局情報の管理と、組織間でのデータ交換を容易にするために、
無線認証連携協会 (Cityroam協会) で
策定された、標準形式のスプレッドシートです。

## apmap-eduroamJP.plの使い方
準備として以下を実行して、足りないモジュールがあればインストールしておく。
```
$ perl -c apmap-eduroamJP.pl
```

1. 基地局マップデータのテンプレート `APmap-tmpl-vXXX.xlsx` に従って、
基地局管理シートを作成する。
2. CSV UTF-8形式でエクスポートする。(必ずUTF-8エンコードにする)
3. 上記CSVファイルを `apmap-eduroamJP.pl` に読み込ませて、
リダイレクトによって出力ファイルを作成する。
(出力ファイルはBOM付きなことに留意)
```
$ ./apmap-eduroamJP.pl infile.csv > outfile.csv
```
4. eduroam JP申請システムからダウンロードしたスプレッドシート
(テンプレート)を使い、
まず**institutionシート**を埋めておく。
5. コマンドで生成されたCSVファイル (outfile.csv) 
を別ウィンドウのExcelなどで読み込み、
テンプレートの**locationシート**にコピー・ペーストする。
元から入っていた表は上書き削除する。
6. でき上ったスプレッドシートのファイル (.xlsx) を
eduroam JP申請システムにアップロードする。

## apmap-kml.plの使い方
スクリプトをテキストエディタで編集して、iconの設定などをカスタマイズする。
以下を実行して、足りないモジュールがあればインストールしておく。
```
$ perl -c apmap-kml.pl
```
1. 基地局マップデータのテンプレート `APmap-tmpl-vXXX.xlsx` に従って、
基地局管理シートを作成する。
2. CSV UTF-8形式でエクスポートする。(必ずUTF-8エンコードにする)
3. 上記CSVファイルを `apmap-kml.pl` に読み込ませて、
リダイレクトによって出力ファイルを作成する。
```
$ ./apmap-kml.pl infile.csv > outfile.kml
```
4. 出力ファイルにはPlacemarkブロックしか含まれないので、
先頭と末尾に足りない要素を補う。  
(KML/KMZファイルの内容はGoogle mapsのドキュメントを参照)
5. KMLファイルと付随するアイコンのイメージファイルを、zipでまとめて、
KMZファイルを作成する。  

## 注意事項
- **No Pull Requests.**  
基本的にPRは受け付けていないので、修正や要望がある場合はまず
Issueで連絡してください。
- スプレッドシートを直接読み込む機能は今後の課題です。

