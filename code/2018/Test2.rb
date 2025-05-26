# -*- coding: utf-8 -*-
# Test用プログラム 壁にそって進む

require 'CHaserConnect.rb' # CHaserConnect.rbを読み込む Windows

# サーバに接続
target = CHaserConnect.new("Fushi") # この名前を4文字までで変更する

values = Array.new(10) # 書き換えない
mode = 1

loop do # 無限ループ
  #----- ここから -----
  values = target.getReady # 準備信号を送り制御情報と周囲情報を取得
  if values[0] == 0        # 制御情報が0なら終了
    break
  end
  if values[2] == 3          #上にハートがあったら
    mode = 1
  elsif values[4] == 3       #左にハートがあったら
    mode = 2
  elsif values[6] == 3       #右にハートがあったら
    mode = 3
  elsif values[8] == 3       #下にハートがあったら
    mode = 4
  end
  if mode == 1
    if values[2] != 2
      values = target.walkUp
      mode = 1
    elsif values[4] != 2
      values = target.walkLeft
      mode = 2
    elsif values[8] != 2
      values = target.walkDown
      mode = 4
    elsif values[6] != 2
      values = target.walkRight
      mode = 3
    end
  #---------------------------------------左進んだとき--------------------------------------
  elsif mode == 2
   if values[4] != 2
     values = target.walkLeft
     mode = 2
   elsif values[8] != 2
     values = target.walkDown
     mode = 4
   elsif values[2] != 2
     values = target.walkUp
     mode = 1
   elsif values[6] != 2
     values = target.walkRight
     mode = 3
   end
#---------------------------------------右進んだとき--------------------------------------
 elsif mode == 3
  if values[6] != 2
    values = target.walkRight
    mode = 3
  elsif values[2] != 2
    values = target.walkUp
    mode = 1
  elsif values[8] != 2
    values = target.walkDown
    mode = 4
  elsif values[4] != 2
    values = target.walkLeft
    mode = 2
  end
#---------------------------------------下進んだとき--------------------------------------
 elsif mode == 4
  if values[8] != 2
    values = target.walkDown
    mode = 4
  elsif values[6] != 2
    values = target.walkRight
    mode = 3
  elsif values[4] != 2
    values = target.walkLeft
    mode = 2
  elsif values[2] != 2
    values = target.walkUp
    mode = 1
  end
end
#------------------------------------------------------------------------------------------
  if values[0] == 0 # 制御情報が0なら終了
   break
  end
  #----- ここまで -----
end

target.close # ソケットを閉じる
