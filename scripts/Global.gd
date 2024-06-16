extends Node

var stop_count: int = 0:
	set(val):
		stop_count = max(0,val)
		if stop_count == 0:
			get_tree().paused = false
		else :
			get_tree().paused = true

#暂停游戏
func stop_the_world():
	stop_count += 1

#继续游戏
func open_the_world():
	stop_count -= 1
