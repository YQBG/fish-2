class_name SaverLoader
extends Node

@onready var player = %Player
@onready var home = $"../.."
@onready var quantity_ui = $"../../QuantityUI"

#保存游戏
func save_game(pond_area: Rect2):
	var saved_game: SavedGame = SavedGame.new() as SavedGame
	saved_game.player_position = player.global_position
	saved_game.pond_area = pond_area
	saved_game.fish_quantity = home.fish_quantity
	
	for fishing in get_tree().get_nodes_in_group("fish"):
		saved_game.fish_positions.append(fishing.global_position)
		
	var error = ResourceSaver.save(saved_game,"user://savegame.tres")
	if error == OK:
		print("游戏保存成功")
	else:
		print("游戏保存失败: ", error)
		
		
#加载游戏
func load_game():
	var saved_game := load("user://savegame.tres") as SavedGame
	if saved_game == null:
		print("未找到存档")
		return
		
	player.global_position = saved_game.player_position
	# 加载钓到的鱼的数量
	home.fish_quantity = saved_game.fish_quantity
	quantity_ui.add_count(saved_game.fish_quantity)
	
	# 移除所有鱼
	for fishing in get_tree().get_nodes_in_group("fish"):
		fishing.get_parent().remove_child(fishing)
		fishing.queue_free()
		
	# 重新生成鱼
	for position in saved_game.fish_positions:
		var fish_scene = preload("res://scenes/fish_data.tscn")
		#实例化新鱼
		var new_fish = fish_scene.instantiate()
		# 设置鱼对象的全局位置
		new_fish.global_position = position
		# 将鱼添加到节点中
		home.add_child(new_fish)
		# 重新设置鱼的鱼塘区域
		new_fish.set_pond_area(saved_game.pond_area)  
		
		
		
		
		
