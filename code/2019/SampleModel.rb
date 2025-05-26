# -*- coding: utf-8 -*-
require 'CHaserConnect.rb' #呼び出すおまじない

#　書き換えない
target = CHaserConnect.new("model") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成

# ループ前変数
$initPosi = nil # 初期値判定 0=左上 1=左下 2=右下 3=右上
i = 0 # for文
wallCountA = 0 # 壁A測定一回目
itemCountA = 0 # アイテムA測定二回目
wallCountB = 0 # 壁B測定一回目
itemCountB = 0 # アイテムB測定二回目
judgA = 0 # 初期移動方向判定一回目
judgB = 0 # 初期移動方向判定二回目

#ループ内変数
$tar = nil #　Walk,$put,Lookの分岐　0=$put,1=walk,2=$look
$put = nil # $put 0=Up,1=Left,2=Down,3=Right
$look = nil # $look 0=Up,1=Left,2=Down,3=Right
$go = nil # 移動先 0=Up,1=Left,2=Down,3=Right
$tarn = 4 # ターンカウント(初期移動の分の4)

#ここからメソッド定義

def _initialPositionGrasp(values, target) # 初期位置把握
	values = target.getReady
	values = target.searchUp
	if values[9] == 2
		values = target.getReady
		values = target.searchLeft
		if values[9] == 2
			$initPosi = 0
		else
			$initPosi = 3
		end
	else
		values = target.getReady
		values = target.searchDown
		if values[9] == 2
			values = target.getReady
			values = target.searchRight
			if values[9] == 2
				$initPosi = 2
			else
				$initPosi = 1
			end
		end
	end
	print "initposi"
	puts $initPosi
end

def _initialAction(values, target, i,wallCountA, wallCountB, itemCountA ,itemCountB, judgA, judgB) # 初期行動
	if $initPosi == 0 # マップ左上にいた時の行動
		values = target.getReady
		values = target.lookDown
		values.each{ |i|
			if values[i] == 2
				wallCountA += 1
			elsif values[i] == 3
				itemCountA += 1
			end
		}
		values = target.getReady
		values = target.lookRight
		values.each{ |i|
			if values[i] == 2
				wallCountB += 1
			elsif values[i] == 3
				itemCountB += 1
			end
		}
		wallCountA - item_countA = judgA
		wallCountB - item_countB = judgB
		if judgA < judgB
			$go = 3
		else
			$go = 2
		end
	elsif  $initPosi == 1 # マップ左下にいた時の行動
		values = target.getReady
		values = target.lookUp
		values.each{ |i|
			if values[i] == 2
				wallCountA += 1
			elsif values[i] == 3
				itemCountA += 1
			end
		}
		values = target.getReady
		values = target.lookRight
		values.each{ |i|
			if values[i] == 2
				wallCountB += 1
			elsif values[i] == 3
				itemCountB += 1
			end
		}
		wallCountA - item_countA = judgA
		wallCountB - item_countB = judgB
		if judgA < judgB
			$go = 3
		else
			$go = 0
		end
	elsif $initPosi == 2 # マップ右下にいた時の行動
		values = target.getReady
		values = target.lookUp
		values.each{ |i|
			if values[i] == 2
				wallCountA += 1
			elsif values[i] == 3
				itemCountA += 1
			end
		}
		values = target.getReady
		values = target.lookLeft
		values.each{ |i|
			if values[i] == 2
				wallCountB += 1
			elsif values[i] == 3
				itemCountB += 1
			end
		}
		wallCountA - item_countA = judgA
		wallCountB - item_countB = judgB
		if judgA < judgB
			$go = 1
		else
			$go = 0
		end
	elsif  $initPosi == 3 # マップ右上にいた時の行動
		values = target.getReady
		values = target.lookDown
		values.each{ |i|
			if values[i] == 2
				wallCountA += 1
			elsif values[i] == 3
				itemCountA += 1
			end
		}
		values = target.getReady
		values = target.lookLeft
		values.each{ |i|
			if values[i] == 2
				wallCountB += 1
			elsif values[i] == 3
				itemCountB += 1
			end
		}
		wallCountA - item_countA = judgA
		wallCountB - item_countB = judgB
		if judgA < judgB
			$go = 1
		else
			$go = 2
		end
	end
end

def _obliqueItemGet(values,  random) #斜めのアイテムを取りに行く
	if values[1] == 3
		rand = random.rand(0..1)
		if rand == 0
			$go = 0 # 上に歩く
			$tar = 1 # walkする
			if values[2] == 2
				$go = 1 # 左に歩く
				$tar = 1 # walkする
			end
		else
			$go = 1 # 左に歩く
			$tar = 1 #walkする
			if values[4] == 2
				$go = 0 # 上に歩く
				$tar = 1 # walkする
			end
		end
	elsif values[3] == 3
		rand = random.rand(0..1)
		if rand == 0
			$go = 0 # 上に歩く
			$tar = 1 # walkする
			if values[2] == 2
			$go = 3 # 右に歩く
			$tar = 1 # walkする
		end
	else
			$go = 3 # 右に歩く
			$tar = 1 #walkする
			if values[6] == 2
				$go = 0 # 上に歩く
				$tar = 1 # walkする
			end
		end
	elsif values[7] == 3
		rand = random.rand(0..1)
		if rand == 0
			$go = 1 # 左に歩く
			$tar = 1 # walkする
			if values[4] == 2
				$go = 2 # 下に歩く
				$tar = 1 # walkする
			end
		else
			$go = 2 # 下に歩く
			$tar = 1 # walkする
			if values[8] == 2
				$go = 1 # 左に歩く
				$tar = 1 # walkする
			end
		end
	elsif values[9] == 3
		rand = random.rand(0..1)
		if rand == 0
			$go = 2 # 下に歩く
			$tar = 1 # walkする
			if values[8] == 2
				$go = 3 # 右に歩く
				$tar = 1 # walkする
			end
		else
			$go = 3 # 右に歩く
			$tar = 1  # walkする
			if values[6] == 2
				$go = 2 # 下に歩く
				$tar = 1  # walkする
			end
		end
	end
end

def _itemGet(values) # 隣接するアイテムを取りに行く
	if values[2] == 3
		$go = 0 # 上に歩く
		$tar = 1 # walkする
	elsif values[4] == 3
		$go = 1 #　左に歩く
		$tar = 1 # walkする
	elsif values[6] == 3
		$go = 3 #右に歩く
		$tar = 1 # walkする
	elsif values[8] == 3
		$go = 2 #下に歩く
		$tar = 1 # walkする
	end
end

def _obliqueEnemy(values, random) #斜めに敵がいた時の行動
	if values[1] == 1
		rand = random.rand(0..1)
		if rand == 0
			$go = 3 # 右に歩く
			$tar = 1  # walkする
			if values[6] == 2
				$go = 2 # 下に歩く
				$tar = 1  # walkする
				if values[8] == 2
					$look = 0 # 上を見る
					$tar = 2 # lookする
				end
			end
		else
			$go = 2 # 下に歩く
			$tar = 1  # walkする
			if values[8] == 2
				$go = 3 # 右に歩く
				$tar = 1  # walkする
				if values[6] == 2
					$look = 0 # 上を見る
					$tar = 2  # lookする
				end
			end
		end
	elsif values[3] == 1
		rand = random.rand(0..1)
		if rand == 0
			$go = 1 # 左に歩く
			$tar = 1  # walkする
			if values[4] == 2
				$go = 2 # 下に歩く
				$tar = 1 # walkする
				if values[8] == 2
					$look = 0 # 上を見る
					$tar = 2 # walkする
				end
			end
		else
			$go = 2 # 下に歩く
			$tar = 1 # walkする
			if values[8] == 2
				$go = 1 # 左に歩く
				$tar = 1  # walkする
				if values[4] == 2
					$look = 0 # 上を見る
					$tar = 2  # lookする
				end
			end
		end
	elsif values[7] == 1
		rand = random.rand(0..1)
		if rand == 0
			$go = 3 # 右に歩く
			$tar = 1  # walkする
			if values[6] == 2
				$go = 0 # 上に歩く
				$tar = 1 # walkする
				if values[2] == 2
						$look = 2 # 下を見る
						$tar = 2  # lookする
					end
				end
			else
			$go = 0 # 上に歩く
			$tar = 1  # walkする
			if values[2] == 2
				$go = 3 # 右に歩く
				$tar = 1  # walkする
				if values[6] == 2
					$look = 2 # 下を見る
					$tar = 2  # lookする
				end
			end
		end
	elsif values[9] == 1
		rand = random.rand(0..1)
		if rand == 0
			$go = 1 # 左に歩く
			$tar = 1  # walkする
			if values[4] == 2
				$go = 0 # 上に歩く
				$tar = 1  # walkする
				if values[2] == 2
					$look = 2 # 下を見る
					$tar = 2  # lookする
				end
			end
		else
			$go = 0 # 上に歩く
			$tar = 1 # walkする
			if values[2] == 2
				$go = 1 # 左に歩く
				$tar = 1  # walkする
				if values[4] == 2
					$look = 2 # 下を見る
					$tar = 2  # lookする
				end
			end
		end
	end
end

def _enemy(values) # 隣接した敵に攻撃する
	if values[2] == 1
		$put = 0 #上にputする
		$tar = 0 # putする
	elsif values[4] == 1
		$put = 1 #左にputする
		$tar = 0 # putする
	elsif values[6] == 1
		$put = 3 #右にputする
		$tar = 0 # putする
	elsif values[8] == 1
		$put = 2 #下にputする
		$tar = 0 # putする
	end
end

def _avoidBlock(values, random) # 壁にめり込まない
	if $go == 0 # 上を向いているとき
		if values[2] == 2
			rand = random.rand(0..1)
			if rand == 0
				$go = 1 # 左に歩く
				$tar = 1  # walkする
				if values[4] == 2
					$go = 3 # 右に歩く
					$tar = 1  # walkする
					if values[6] == 2
						$go = 2 # 下に歩く
						$tar = 1  # walkする
					end
				end
			else
				$go = 3 # 右に歩く
				$tar = 1 # walkする
				if values[6] == 2
					$go = 1 # 左に歩く
					$tar = 1 # walkする
					if values[4] == 2
						$go = 2 # 下に歩く
						$tar = 1  # walkする
					end
				end
			end
		end
		$tar = 1  # walkする
	end

	if $go == 1 # 左を向いていた時
		if values[4] == 2
			rand = random.rand(0..1)
			if rand == 0
				$go = 0 # 上に歩く
				$tar = 1 # walkする
				if values[2] == 2
					$go = 2 # 下に歩く
					$tar = 1 # walkする
					if values[8] == 2
						$go = 3 # 右に歩く
						$tar = 1 # walkする
					end
				end
			else
				$go = 2 # 下に歩く
				$tar = 1 # walkする
				if values[8] == 2
					$go = 0 # 上に歩く
					$tar = 1 # walkする
					if values[2] == 2
						$go = 3 # 右に歩く
						$tar = 1 # walkする
					end
				end
			end
		end
		$tar = 1 # walkする
	end

	if $go == 2 # 下を向いていた時
		if values[8] == 2
			rand = random.rand(0..1)
			if rand == 0
			$go = 1 # 左に歩く
			$tar = 1 # walkする
			if values[4] == 2
				$go = 3 # 右に歩く
				$tar = 1 # walkする
				if values[6] == 2
					$go = 0 # 上に歩く
					$tar = 1 # walkする
				end
			end
		else
				$go = 3 # 右に歩く
				$tar = 1 # walkする
				if values[6] == 2
					$go = 1 # 左に歩く
					$tar = 1  # walkする
					if values[4] == 2
						$go = 0 # 上に歩く
						$tar = 1 # walkする
					end
				end
			end
		end
		$tar = 1 # walkする
	end

	if $go == 3 # 右を向いていた時
		if values[6] == 2
			rand = random.rand(0..1)
			if rand == 0
				$go = 0 # 上に歩く
				$tar = 1 # walkする
				if values[2] == 2
					$go = 2 # 下に歩く
					$tar = 1  # walkする
					if values[8] == 2
						$go = 1 # 左に歩く
						$tar = 1  # walkする
					end
				end
			else
				$go = 2 # 下に歩く
				$tar = 1 # walkする
				if values[8] == 2
					$go = 0 # 上に歩く
					$tar = 1 # walkする
					if values[2] == 2
						$go = 1 # 左に歩く
						$tar = 1 # walkする
					end
				end
			end
		end
	$tar = 1 # walkする
end
end


# ここから実行するメソッドを書いていく

_initialPositionGrasp(values, target) # 初期位置把握

_initialAction(values, target, i, wallCountA, wallCountB, itemCountA ,itemCountB, judgA, judgB) # 初期行動

loop do # ここからループ

#---------ここから---------
values = target.getReady

if values[0] == 0
	break
end
#-----ここまで書き換えない-----

_obliqueItemGet(values, random) #斜めのアイテムを取りに行く

_obliqueEnemy(values, random) #斜めに敵がいたときの行動

_avoidBlock(values, random) # 壁にめり込まない

_itemGet(values) # 隣接するアイテムを取りに行く

_enemy(values) # 隣接する敵に攻撃を仕掛ける

_act(values, target) #行動する








# -*-coding: utf-8 -*-
require 'CHaserConnect.rb'
#　書き換えない
target = CHaserConnect.new("2019") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成

@aisle = 0
@enemy = 1
@kabe = 2
@item = 3

@up = 2
@left = 4
@right = 6
@down = 8

@walk = "walk"
@look = "look"
@search = "search"
@put = "put"

# ここから実行するメソッドを書いていく
def Move(target, direction)
	field = Array.new(10)
	case direction
	when @up
		field = target.walkUp
	when @left
		field = target.walkLeft
	when @right
		field = target.walkRight
	when @down
		field = target.walkDown
	end
	return field
end

def Look(target, direction)
	field = Array.new(10)
	case direction
	when @up
		field = target.lookUp
	when @left
		field = target.lookLeft
	when @right
		field = target.lookRight
	when @down
		field = target.lookDown
	end
	return field
end

def Search(target, direction)
	field = Array.new(10)
	case direction
	when @up
		field = target.searchUp
	when @left
		field = target.searchLeft
	when @right
		field = target.searchRight
	when @down
		field = target.searchDown
	end
	return field
end

def Put(target, direction)
	field = Array.new(10)
	case direction
	when @up
		field = target.putUp
	when @left
		field = target.putLeft
	when @right
		field = target.putRight
	when @down
		field = target.putDown
	end
	return field
end

def Action(mode, target, direction)
	field = Array.new(10)

	p mode, direction

	case mode
	when @walk
		field = Move(target, direction)
	when @look
		field = Look(target, direction)
	when @search
		field = Search(target, direction)
	when @put
		field = Put(target, direction)
	end
	return field, @walk
end

def ChangeDirection(random, direction)
	chengedDirection = random.rand(1..4) * 2
	if chengedDirection == direction
		ChangeDirection(random, direction)
	end
	return chengedDirection
end

def SuddenlyChangeDirection(elapsedTurns, random, direction)
	probability = random.rand(0..100)
	if probability < elapsedTurns * 25
		elapsedTurns = 0
		direction = ChangeDirection(random, direction)
		p 'Suddenly'
	else
		elapsedTurns += 1
	end
	return direction, elapsedTurns
end

# 規則性あり版
#def Kabeyoke(values, direction)
#	if values[direction] == @kabe
#		direction += 2
#		if direction > 8
#			direction -= 8
#		end
#		direction = Kabeyoke(values, direction)
#	end
#	return direction
#end

# 規則性なし版
def Kabeyoke(values, random, direction)
	if values[direction] == @kabe
		direction = Kabeyoke(values, random, ChangeDirection(random, direction))
	end
	return direction
end

def FindNeighbor(values, direction, mode)
	if values[@up] == @enemy
		direction = @up
		mode = @put
	elsif values[@right] == @enemy
		direction = @right
		mode = @put
	elsif values[@left] == @enemy
		direction = @left
		mode = @put
	elsif values[@down] == @enemy
		direction = @down
		mode = @put
	end
	return direction, mode
end

def FindNextItem(values, direction, mode)
	if values[@up] == @item
		direction = @up
		mode = @walk
	elsif values[@right] == @item
		direction = @right
		mode = @walk
	elsif values[@left] == @item
		direction = @left
		mode = @walk
	elsif values[@down] == @item
		direction = @down
		mode = @walk
	end
	return direction, mode
end


# ここまでに実行するメソッドを書いておく

# 初期化
direction = random.rand(1..4) * 2
turnCounts = 0
elapsedTurns = 0
mode = @walk
# 初期化おわ


loop do # ここからループ
	#---------ここから---------
	values = target.getReady

	if values[0] == 0
		break
	end
	#-----ここまで書き換えない-----
	#---------ここから---------

	direction, elapsedTurns = SuddenlyChangeDirection(elapsedTurns, random, direction)
#	direction = Kabeyoke(values, direction)
	direction = Kabeyoke(values, random, direction)
	direction, mode = FindNextItem(values, direction, mode)
	direction, mode = FindNeighbor(values, direction, mode)
	if mode != "put"
		# look や search を使いこなそう
	end
	did = mode
	actionResult, mode = Action(mode, target, direction)

#	if did == @search and actionResult.include?(@item)
#		elapsedTurns == 0
#	elsif did == @search and actionResult.include?(@enemy)




	#---------ここまで---------
end # ループここまで
target.close
#-----ここまで書き換えない-----