# -*- coding: utf-8 -*-
require  'CHaserConnect.rb' #呼び出すおまじない

# 書き換えない
target = CHaserConnect.new("LV 4") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成


#--------自分で追加した変数--------
UL, UP, UR, LEFT, CENTER, RIGHT, DL, DOWN, DR = [1,2,3,4,5,6,7,8,9].freeze  #　「多重代入」+「freeze」というテクニック
ISLE, CHAR, BLOCK, ITEM = [0, 1, 2, 3].freeze
direction = random.rand(1..4)*2  # 1以上4以下の範囲×2で初期化
not_blocks = []
count = 0
exc_direction = 0
#--------自分で追加したメソッド--------

def avoid_block direction,not_blocks
  if not_blocks.include?(direction) # 突き当たるまでは直進する仕様
    return direction
  else
    return not_blocks.sample
  end
end

def get_slanthing_item slanthing_item, not_blocks, direction
  item_direction = []
  for i in slanthing_item
    case i
    when UL
      item_direction.push([UP,LEFT] & not_blocks)
    when UR
      item_direction.push([UP,RIGHT] & not_blocks)
    when DL
      item_direction.push([DOWN,LEFT] & not_blocks)
    when DR
      item_direction.push([DOWN,RIGHT] & not_blocks)
    end
  end

  item_direction.flatten!
  item_direction.select{ |e| item_direction.count(e) > 1 }.uniq

  if item_direction.size > 0
    return item_direction.sample
  else
    return direction
  end
end

def create_items values, chklist
  items = []

  for i in chklist
    if values[i] == ITEM
      items.push(i)
    end
  end
  return items
end

def get_item values,direction,not_blocks

  next_item = create_items(values,[UP,RIGHT,DOWN,LEFT])

  if next_item.size > 0
    return next_item.sample
  else
    slanthing_item = create_items(values,[UL,UR,DL,DR])
    return get_slanthing_item(slanthing_item,not_blocks,direction)
  end
end

def run_away target, values, direction
  looking = look(target, direction)
  if looking.include?(CHAR) && looking.rindex(CHAR) != 0
    return direction
  end

  return 0
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

def look target, direction
  case direction
  when UP
    result = target.lookUp
  when RIGHT
    result = target.lookRight
  when DOWN
    result = target.lookDown
  when LEFT
    result = target.lookLeft
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
  not_blocks = []
  for i in [UP,RIGHT,DOWN,LEFT]
    if values[i] != BLOCK
      not_blocks.push(i)
    end
  end

  if not_blocks.size > 1 && not_blocks.include?(exc_direction)
      not_blocks.delete(exc_direction)
  end

  direction = avoid_block(direction, not_blocks)
  if values.include?(CHAR) && values.rindex(CHAR) != 0 # include? と rindex
    values, direction = put(target, values, direction)
  elsif count == 4
    count = 0
    exc_direction = run_away(target, values, direction)
  elsif values.include?(ITEM)
    direction = get_item(values,direction,not_blocks)
    values = walk(target, direction)
    count += 1
  else
    values = walk(target, direction)
    count += 1
  end

  p count
#ここまでに処理を書く

#---------ここから---------
  if values[0] == 0
    break
  end

end # ループここまで
target.close
#-----ここまで書き換えない-----
