# -*- coding: utf-8 -*-
# Test用プログラム ひたすら四方をsearch（調べる）

require 'CHaserConnect.rb' # CHaserConnect.rbを読み込む Windows

# サーバに接続
target = CHaserConnect.new("テスト1") # この名前を4文字までで変更する

values = Array.new(10) # 書き換えない

loop do # 無限ループ
  #----- ここから -----


  #----- ここまで -----
end
p "test1 end"
target.close # ソケットを閉じる
