#!/usr/bin/perl

use Lingua::JA::Hepburn::Passport;
use strict;
use warnings;
use utf8;
use open qw/ :utf8 :std /;

my $conv = Lingua::JA::Hepburn::Passport->new();

my $count = 0;
my %dupcheck;
while( <> ){
    my( $pos ) = ( m!\A\((.*?詞)\s! );
    my( $token, $yomi ) = ( m!代表表記:([^/]+)/([^\s"]+)[\s"]! );
    next unless $pos and $token and $yomi;

    #next unless $pos =~ m!\A(名|形容|動)詞\Z!;
    next unless $pos eq '名詞';

    # 1音のみの語(e.g. 蚊)は，発声をうまく聞き取れない可能性が高いから外す
    next if length($yomi) <= 1;
    # 漢字表記1文字以下，かつ，読み2文字以下(e.g. 愛)も，同じ理由で外す．
    #next if length($token) <= 1 and length($yomi) <= 2;
    # 7音以上は長過ぎるので外す
    next if length($yomi) >= 6;
    next if length($yomi) >= 5 and length($token) >= 4;

    # 促音はローマ字表記が不安定なので除外
    next if $yomi =~ /っ/;
    # 長音はローマ字表記が不安定なので除外
    next if $yomi =~ /ー/;
    next if $token =~ /ー/;
    # 拗音はローマ字表記が不安定なので除外
    next if $yomi =~ /[ぁぃぅぇぉゃゅょ]/;
    # 発音が紛らわしいので除外
    next if $yomi =~ /[じぢずづ]/;

    # 外来語はローマ字表記なのか，元の言語表記なのかが紛らわしいので除外
    next if $token =~ m/[\p{Katakana}ａ-ｚＡ-Ｚ]/;

    # ヘボン式では「新聞」を shimbun と書くことになっているが，この規
    # 則が熟知されていないので，該当する語を除外
    next if $yomi =~ m!ん[まみむえもばびぶべぼぱぴぷぺぽ]!;

    # 長音を含む場合(e.g. 太田)に，OOTA / OHTA / OTA という紛らわしさ
    # があるので，該当する語を除外
    next if $yomi =~ m![おこそとのほもよろごぞどぼぽ][おう]!;
    next if $yomi =~ m![うくすつぬふむゆるぐずづぶぷ]う!;

    # いくつかの既知の縁起の悪い語を外す
    next if $token =~ m![死殺]!;

    my $romaji = $conv->romanize($yomi);

    # 母音のみからなる語(e.g. 愛)は，発声をうまく聞き取れない可能性が高いから除外
    next unless $romaji =~ m/[^AIUEO]/;
    # ローマ字表記で長い語は入力が面倒なので除外
    next if length($romaji) >= 11;

    next if $dupcheck{$yomi}++;
    next if $dupcheck{$romaji}++;

    # 濁音と清音の違いのみしかない語は，片方のみ収録 => 単語が足りなくなった
    #my $x = $yomi;
    #$x =~ tr/が-ござ-ぞだ-どば-ぼぱ-ぽ/か-こさ-そた-とは-ほは-ほ/;
    #next if $dupcheck{$x}++;

    printf( "%d%d%d%d%d,%s,%s,%s\n",
	    int( $count / 1296 ) % 6 + 1,
	    int( $count / 216 ) % 6 + 1,
	    int( $count / 36 ) % 6 + 1,
	    int( $count / 6 ) % 6 + 1,
	    ( $count % 6 ) + 1,
	    $token, $yomi, lc($romaji) );
    $count++;
    last if $count >= 7776;
}
