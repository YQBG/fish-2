extends Node2D  

@export var fish_scene: PackedScene
@export var fish_count: int = 1  # 生成的鱼的数量
@onready var tile_map_layer: TileMapLayer = $Fishpond
@onready var player: CharacterBody2D = $Player
@onready var fish_container: Node2D = $FishContainer
@onready var prompt_box = $PromptBox
@onready var quantity_ui = $QuantityUI
var fish_quantity: int = 0

func _ready(): 
	#随机化随机数发生器的种子
	randomize()
	#拿到鱼塘区域的数据
	var pond_area = tile_map_layer.get_used_rect()
	generate_fish(fish_count,pond_area)

func _physics_process(delta):
	prompt_box.global_position = player.global_position
	prompt_box.position.x = player.position.x - 30
	prompt_box.position.y = player.position.y - 50
	player.get_child(4).connect("fish_count",add_fish_count)
	
# 生成指定数量的鱼并将其放置在鱼塘区域内
func generate_fish(count: int, pond_area: Rect2) -> void:
	#将鱼塘的位置和大小坐标转换为全局坐标
	var global_pos = tile_map_layer.map_to_local(pond_area.position)
	var global_size = tile_map_layer.map_to_local(pond_area.size)
	
	for i in range(count):
		# 生成一个随机位置
		var rand_position = Vector2(
			#这里做减法是因为拿到的位置有偏差，在生成鱼的坐标的时候会有概率出现鱼的坐标在鱼塘外。
			#我也不知道应该如何调整，索性就减去具体的数字。
			randf_range(global_pos.x, (global_pos.x + global_size.x) - 75), 
			randf_range(global_pos.y, (global_pos.y + global_size.y) - 60)
		)
		# 实例化鱼对象
		var fish_instance = fish_scene.instantiate()
		# 设置鱼对象的全局位置
		fish_instance.global_position = rand_position
		# 将鱼添加到节点中
		add_child(fish_instance)
		#将鱼塘区域pond_area作为参数传递过去
		fish_instance.set_pond_area(pond_area)

func _input(event):
	if event.is_action_pressed("fishing"):
		prompt_box.get_child(0).get_child(0).text = "按O键退出钓鱼"
	elif event.is_action_pressed("fishing_out"):
		prompt_box.get_child(0).get_child(0).text = "按F键开始钓鱼"
		
#当玩家进入鱼塘区域，显示提示框
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		prompt_box.get_child(0).get_child(0).text = "按F键开始钓鱼"
		prompt_box.show()


#当玩家离开鱼塘区域，隐藏提示框
func _on_area_2d_body_exited(_body):
	prompt_box.hide()
	# 创建补间动画
	var tween = get_tree().create_tween()
	tween.tween_property($PromptBox,"modulate",Color(1, 1, 1, 1),1)

func add_fish_count():
	fish_quantity += 1
	quantity_ui.add_count(fish_quantity)
