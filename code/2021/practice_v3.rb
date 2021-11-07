# -*- coding: utf-8 -*-
require  'AgentController.rb' #呼び出すおまじない

# (分からないうちは)書き換えない
target = AgentController.new("prac") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成

#--------ここから--------
$AISLE = 0.freeze
$ENEMY = 1.freeze
$WALL = 2.freeze
$ITEM = 3.freeze

$UP = 2.freeze
$RIGHT = 6.freeze
$DOWN = 8.freeze
$LEFT = 4.freeze

# 各種自分で定義する変数(初期化が必要なもののみ)
direction = [$UP, $RIGHT, $DOWN, $LEFT].sample()
turn = 0
move = false
change = false
close = false
attac = false

#各種行動の処理
def action(command, direction)
	return target.action(command, direction)
end


# 各処理
def nextEnemyCheck(values)
	case $ENEMY
	when values[2] #上に敵がいたら
		return [true,$UP]
	when values[6] #右に敵がいたら
		return [true,$RIGHT]
	when values[8] #下に敵がいたら
		return [true,$DOWN]
	when values[4] #左に敵がいたら
		return [true,$LEFT]
	else
		return[false]
	end
end

def angleEnemyCheck(values)
	case $ENEMY
	when values[1]	#左へ誘導したい
		unless [values[6], values[8]].all?($WALL)
			return [true,$UP]
		else
			return [false]
		end
	when values[3]	#上へ誘導したい
		unless [values[4], values[8]].all?($WALL)
			return [true,$RIGHT]
		else
			return [false]
		end
	when values[9]	#右へ誘導したい
		unless [values[2], values[4]].all?($WALL)
			return [true,$DOWN]
		else
			return [false]
		end
	when values[7]	#下へ誘導したい
		unless [values[2], values[6]].all?($WALL)
			return [true,$LEFT]
		else
			return [false]
		end
	else
		return [false]
	end
end


def passagesNextAisle(values)	# 隣接する通行可能な通路を調べる(斜めの通路のことを考えることは別の処理として書くと楽そう)
	passable = Array.new()
	values.each_with_index do |i, idx|		# for i in values でも可
		if idx > 0 &&  idx % 2 == 0 && i != $WALL && i != $ENEMY
			passable.push(idx)
		end
	end
	print("passable = ", passable, "\n")
	return passable
end


def reorderingInfo(info, direction) # なぜあるかと言うと、方向別に処理を考えたくないので自機が向いている方向を基準に考えたいから
# look結果を並び替え(up方向に相対的な向きを揃え)て二次元配列にしちゃう...だと面倒なので先に二次元配列にしちゃってから回転しちゃう
	print("info = ", info, "\n")
	info.shift								# ゲーム続行フラグはいらん
	info2d = Array.new(3).map{Array.new(3)}	# 2次元配列を用意
	info.each_with_index do |i, idx|
		info2d[idx/3][idx%3] = i
	end

	print("info2d = ", info2d, "\n")

	case direction
	when $UP
		return info2d 							# 360度回転 (無回転とも)
	when $RIGHT
		return info2d.transpose.reverse			# 右回転
	when $DOWN
		return info2d.reverse.map(&:reverse)	# 180度回転
	when $LEFT
		return info2d.reverse.transpose			# 左回転
	end
end


def infoAnalyse(values, mapInfo2d, move)
	close = false
	attac = false

	mapInfo2d.each_with_index do |v, low|
		mapInfo2d[low].each_with_index do |v, col|
			case mapInfo2d[low][col]
			when $ENEMY
				if [low,col] == [1,1] # 前進すると負けるので絶対walkしない(追いつめてるならputする)
					if [mapInfo2d[low-1][col], mapInfo2d[low][col-1], mapInfo2d[low][col+1]].all?($WALL)
						attac = true
					else
						move = false
					end
				elsif [[0,0], [0,1], [0,2], [1,0], [1,2]].include?([low,col]) # 敵との距離を詰める
					close = true
				end
			when $ITEM
				if [[1,1], [2,1]].include?([low,col])
					print("low, col = ", [low,col], "\n")
					if [mapInfo2d[low-1][col], mapInfo2d[low][col-1], mapInfo2d[low][col+1]].all?($WALL)
						if [values[4], values[6], values[8]].all?($WALL) # 詰み, 動いたら負ける
							move = false
						else
							change = true
						end
					else
						move = true #思いついたら書く
					end
				end
			when $WALL
				# 思いついたら書く
			when $AISLE
				move = true
			end
		end
	end
	return move, close, attac
end







# 行動決定の処理
def actDecision(direction, values, target, turn, move, change, close, attac)
	attac, enemy = nextEnemyCheck(values)
	print("netxEnemyCheck_ok : ", attac, "\n")

	attac, enemy = angleEnemyCheck(values)
	print("angleEnemyCheck_ok : ", attac, "\n")

	if attac
		result = putWall(enemy,target)
		puts("putWall_Done")
		turn = 0
	else
		passable = passagesNextAisle(values)
		#print("passable = ", passable, "\n")
		unless passable.include?(direction)   # 「行きたい方向に通路があるか」が偽なら
			change = true
			puts("Change_Direction_Due_to_Avoid_Wall")
		else
			#思いついたら書く
			change = false
		end

		if change
			direction = (passable.sample)
			print("chenged_direction = ", direction, "\n")
			turn = 0
		end

		if move && (turn % 3 != 0)
			moveInfo = walk(direction, target)
			if close
				#思いついたら書く
			end
		else
			lookInfo = look(direction, target)
			print("lookInfo : ", lookInfo, "\n")
			lookInfo2d = reorderingInfo(lookInfo, direction)
			print("rotate lookInfo2d : ", lookInfo2d, "\n")
			move, change, close, attac = infoAnalyse(values, lookInfo2d, move)
		end
	end

	flg = [direction, turn, move, change, close, attac]
	flg_msg = ["direction = ", "turn = ", "move = ", "change = ", "close = ", "attac = "]

	flg.zip(flg_msg) do |i,j|
		print(j, i, "\n")
	end

	return flg
end



loop do # ここからループ
#---------ここから---------
	values = target.getReady

	if values[0] == 0
    	break
 	end
#-----ここまで書き換えない-----

#ここに処理を書く
	direction, turn, move, change, close, attac = actDecision(direction, values, target, turn, move, change, close, attac)
	turn += 1

#---------ここから---------
	if values[0] == 0
    	break
  	end
  	puts()
end # ループここまで
target.close
#-----ここまで書き換えない-----