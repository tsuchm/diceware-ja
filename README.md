# Diceware Word List in Japanese

## 概要

ダイスウェア(Diceware)とは，ダイス(さいころ)を使って「ダイスウェア単語
一覧」と呼ばれる単語一覧から単語をランダムに選び，パスフレーズを作る方
法である．

この方法は，安全なパスフレーズを手軽に生成することができる方法であるが，
実施するためには「ダイスウェア単語一覧」が必要である．この単語一覧とし
ては，従来より英語版の単語一覧

    http://www.hyuki.com/diceware/diceware.wordlist.asc

が利用されてきていたが，日本国内で運用する場合，不慣れな英単語を用いた
パスフレーズは記憶しづらくて不便なため，日本語版の単語一覧を用意するこ
とを試みた．

## 方法

形態素解析器 Juman の辞書の中でも，特に基本語彙からなる ContentW.dic
から名詞のみを取り出し，ローマ字表記が紛らわしくなる語彙を削除するスク
リプトを用意した．

Debian GNU/Linux の場合，以下のコマンドを実行すれば，単語一覧を再現す
ることができる．

    sudo apt-get install juman-dic
    perl convert.pl /usr/share/juman/dic/ContentW.dic > wordlist.csv

## 問題点

発音の明瞭さ・発音の区別のし易さについての考慮が不十分である．「早稲
(わせ)」と「和製(わせい)」が含まれてしまっているが，電話など口頭でパス
フレーズを伝達しなければならない場合には，どちらか区別することが難しい
だろう．

## ライセンス

単語一覧の作成元となった，Juman のライセンス(BSD ライセンス)にしたがう．

## リンク

* http://world.std.com/~reinhold/diceware.html
* http://www.hyuki.com/diceware/
