# -*- coding: utf-8 -*-
require  'CHaserConnect.rb' #呼び出すおまじない

# 書き換えない
target = CHaserConnect.new("LV 2") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成


#--------自分で追加した変数--------
UL, UP, UR, LEFT, CENTER, RIGHT, DL, DOWN, DR = [1,2,3,4,5,6,7,8,9].freeze  #　「多重代入」+「freeze」というテクニック
ISLE, CHAR, BLOCK, ITEM = [0, 1, 2, 3].freeze
direction = random.rand(1..4)*2  # 1以上4以下の範囲×2で初期化
#--------自分で追加したメソッド--------

def change_direction candidate, direction
  case candidate.sample
  when UP
    direction = UP
  when RIGHT
    direction = RIGHT
  when DOWN
    direction = DOWN
  when LEFT
    direction = LEFT
  end

  return direction
end

def avoid_block values, direction
  next_isle = []  # next_itemに倣った

  if values[direction] == BLOCK # 突き当たるまでは直進する仕様
    if values[UP] != BLOCK
      next_isle.push(UP)
    end
    if values[RIGHT] != BLOCK
      next_isle.push(RIGHT)
    end
    if values[DOWN] != BLOCK
      next_isle.push(DOWN)
    end
    if values[LEFT] != BLOCK
      next_isle.push(LEFT)
    end # get_next_itemと書き方似てる...
  end

  if next_isle.size > 0
    return change_direction(next_isle, direction)
  else
    return direction
  end
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
    return change_direction(next_item, direction)
  else
    return direction
  end
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
    return result, direction
  else
    direction = avoid_block(values, direction)
    return walk(target, direction), direction # 改良の余地しかない
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
    values, direction = put(target, values, direction)
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