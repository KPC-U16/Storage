# -*-coding: utf-8 -*-
require 'CHaserConnect.rb'
#　書き換えない
target = CHaserConnect.new("2019") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成

# サーバから渡される値の情報
@aisle = 0
@enemy = 1
@kabe = 2
@item = 3

@up = 2
@left = 4
@right = 6
@down = 8
@upleft = 1
@upright = 3
@downleft = 5
@downright = 9

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
	return field
end

def ChangeDirection(random, direction)
	chengedDirection = random.rand(1..4) * 2
	if chengedDirection == direction
		ChangeDirection(random, direction)
	end
	return chengedDirection
end

def InversionDirection(direction)
	chengedDirection = direction + 4
	if chengedDirection > 8
		chengedDirection -= 8
	end
	return chengedDirection
end


def SuddenlyChangeDirection(elapsedTurns, random, direction, mode)
	probability = random.rand(0..100)
	if probability < elapsedTurns * 25
		elapsedTurns = 0
		direction = ChangeDirection(random, direction)
		p 'Suddenly'
		mode = @look
	else
		elapsedTurns += 1
	end
	return direction, mode, elapsedTurns
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
def Kabeyoke(values, random, direction, mode)
	if values[direction] == @kabe
		direction = Kabeyoke(values, random, ChangeDirection(random, direction))
		mode = @look
	end
	return direction, mode
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

def FindCornerNeighbor(values, direction, mode)
	if values[@upleft] == @enemy
		if direction == @down || direction == @right
			direction = InversionDirection(direction)
		end
	elsif values[@upright] == @enemy
		if direction == @down || direction == @left
			direction = InversionDirection(direction)
		end
	elsif values[@downleft] == @enemy
		if direction == @up || direction == @right
			direction = InversionDirection(direction)
		end
	elsif values[@downright] == @enemy
		if direction == @up || direction == @left
			direction = InversionDirection(direction)
		end
	end
	mode = @look
	return direction, mode
end

def DealEnemyWithinSquareRange(field, direction, mode)
	case direction
	when @right
		twoStepsAhead = [field[1], field[5], field[7]]
		threeStepsAhead = [field[2], field[6], field[8]]
		fourStepsAhead = [field[3], field[9]]
	when @up
		twoStepsAhead = [field[5], field[7], field[9]]
		threeStepsAhead = [field[2], field[4], field[6]]
		fourStepsAhead = [field[1], field[3]]
	when @down
		twoStepsAhead = [field[1], field[3], field[5]]
		threeStepsAhead = [field[4], field[6], field[8]]
		fourStepsAhead = [field[7], field[9]]
	when @left
		twoStepsAhead = [field[3], field[5], field[9]]
		threeStepsAhead = [field[2], field[4], field[8]]
		fourStepsAhead = [field[1], field[7]]
	end

	if twoStepsAhead.include?(@enemy)
		mode = @look
	elsif threeStepsAhead.include?(@enemy) || fourStepsAhead.include?(@enemy)
		mode = @walk
	else
		mode = @search
	end

	return mode
end


# ここまでに実行するメソッドを書いておく

# 初期化
walkResult = Array.new(10)
lookResult = Array.new(10)
searchResult = Array.new(10)

direction = random.rand(1..4) * 2
turnCounts = 0
pedometer = 0
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

	print "mode when getReady = ", mode, "\n"

	direction, mode, elapsedTurns = SuddenlyChangeDirection(elapsedTurns, random, direction, mode)
#	direction = Kabeyoke(values, direction)
	direction, mode = Kabeyoke(values, random, direction, mode)
	direction, mode = FindNextItem(values, direction, mode)
	direction, mode = FindNeighbor(values, direction, mode)
	direction, mode = FindCornerNeighbor(values, direction, mode)
	if mode != "put"
		# look や search を使いこなそう
		if mode == @look
			if lookResult.include?(@enemy)
				mode = DealEnemyWithinSquareRange(lookResult, direction, mode)
			else
				mode = @search
			end
		elsif mode == @search
			if seachResult.include?(@enemy)
				mode = @walk
			else
				mode = @walk
			end
		end
	end

	print "mode when Action = ", mode, "\n"

	did = mode
	actionResult = Action(mode, target, direction)

	case mode
	when @walk
		pedometer += 1
		walkResult = Array.new{actionResult}
	when mode == @look
		lookResult = Array.new{actionResult}
	when mode == @search
		searchResult = Array.new{actionResult}
	end

	print "actionResult = ", actionResult, "\n"
	print "lookResult = ", lookResult, "\n"
	print "searchResult = ", searchResult , "\n"

#	if did == @search and actionResult.include?(@item)
#		elapsedTurns == 0
#	elsif did == @search and actionResult.include?(@enemy)

	turnCounts += 1



	#---------ここまで---------
end # ループここまで
target.close
#-----ここまで書き換えない-----