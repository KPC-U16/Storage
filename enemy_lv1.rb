# -*- coding: utf-8 -*-
require  'CHaserConnect.rb' #呼び出すおまじない

# 書き換えない
target = CHaserConnect.new("LV 1") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成


#--------自分で追加した変数--------
UL, UP, UR, LEFT, CENTER, RIGHT, DL, DOWN, DR = [1,2,3,4,5,6,7,8,9].freeze  #　「多重代入」+「freeze」というテクニック
ISLE, CHAR, BLOCK, ITEM = [0, 1, 2, 3].freeze
random = Random.new   # 乱数を使いたい
direction = random.rand(1..4)*2  # 1以上4以下の範囲×2で初期化
#--------自分で追加したメソッド--------
def avoid_block values, direction
  loop do 
    if values[direction] == BLOCK
      case direction
      when UP
        direction = RIGHT
      when RIGHT
        direction = DOWN
      when DOWN
        direction = LEFT
      when LEFT
        direction = UP
      end
    else
      break
    end
  end
  return direction
end

def get_next_item values, direction
  next_item = []  # これがnilじゃなくて空集合じゃないといけない
                  # そもそも宣言しておかないといけないのが難しい

  if values[UP] == ITEM
    next_item.push(UP)
  end
  if values[RIGHT] == ITEM
    next_item.push(RIGHT)
  end
  if values[DOWN] == ITEM
    next_item.push(DOWN)
  end
  if values[LEFT] == ITEM
    next_item.push(LEFT)
  end # この書き方めちゃダサい

  if next_item.size > 0
    next_item.shuffle
    case next_item.first
    when UP
      direction = UP
    when RIGHT
      direction = RIGHT
    when DOWN
      direction = DOWN
    when LEFT
      direction = LEFT
    end # avoid_blockと書き方似てる...まとめられそう...
  end

  return direction
end



def walk target, direction
  case direction
  when UP
    result = target.walkUp
  when RIGHT
    result = target.walkRight
  when DOWN
    result = target.walkDown
  when LEFT
    result = target.walkLeft
  end
  return result
end

def put target, values, direction
  case values.rindex(CHAR) # rindex
  when UP
    result = target.putUp
  when RIGHT
    result = target.putRight
  when DOWN
    result = target.putDown
  when LEFT
    result = target.putLeft
  end

  if result != nil
    return result
  else
    return walk(target, direction) # 改良の余地しかない
  end
end

#--------ここから--------
loop do # ここからループ

#---------ここから---------
  values = target.getReady

  if values[0] == 0
    break
  end
#-----ここまで書き換えない-----

#ここに処理を書く
  if values.include?(CHAR) && values.rindex(CHAR) != 0 # include? と rindex
    values = put(target, values, direction)
  else
    direction = avoid_block(values, direction)
    direction = get_next_item(values, direction)
    values = walk(target, direction)
  end
#ここまでに処理を書く

#---------ここから---------
  if values[0] == 0
    break
  end

end # ループここまで
target.close
#-----ここまで書き換えない-----