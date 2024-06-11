extends Node2D

signal fish_count

#鱼钩
@export var hook_area_scene: PackedScene
var hook_area: Node2D
#鱼线
@onready var line: Line2D = $Line2D


func _ready():
	#实例化鱼钩
	hook_area = hook_area_scene.instantiate()
	hook_area.connect("fish_caught", _on_hook_area_fish_caught)
	#设置鱼线宽度
	line.width = 0.8
	# 设置鱼线的初始长度
	line.points = [Vector2(0, 0), Vector2(0, 0)]
	# 确保鱼钩在鱼线末端
	hook_area.position = line.points[1]
	add_child(hook_area)
	
	
func set_line_length(length):
	#设置鱼线长度
	line.points[1].y = length
	 # 确保鱼线末端的钩子随长度变化
	hook_area.position.y = length 

func _on_hook_area_fish_caught(fish):
	fish_count.emit()
	if fish.is_in_group("fish"):
		emit_signal("fish_caught", fish)
		fish.queue_free()  
