extends CharacterBody2D

@export var rod_scene: PackedScene
var rod: Node2D  # 用于存储实例化的鱼竿
@onready var marker = $Marker2D

#动画节点
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
#相机节点
@onready var camera_2d: Camera2D = $Camera2D
#钓鱼状态
var FISNING: bool = false

#玩家移动速度
const SPEED = 5000

func _ready() -> void:
	#实例化鱼线
	rod = rod_scene.instantiate()
	add_child(rod)  # 将鱼竿添加到玩家节点
	rod.hide()  # 隐藏鱼竿，直到玩家按下钓鱼键

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left","right","up","down")
	#如果玩家按下o键，退出钓鱼状态
	if Input.is_action_pressed("fishing_out"):
		stop_fishing()
		animated_sprite.play("static")
		
	if not FISNING:
		handle_movement(direction)
		if Input.is_action_pressed("fishing"):
			FISNING = true
			rod.show()  # 显示鱼竿
			rod.get_child(0).global_position = marker.global_position
			
		velocity = direction * SPEED * delta
		move_and_slide()
	else :
		animated_sprite.play("fish")
		rod.set_line_length(50)  # 设置鱼线长度	

# 处理玩家移动
func handle_movement(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		animated_sprite.play("static")
	else:
		if direction.y < 0:
			animated_sprite.play("up")
		elif direction.y > 0:
			animated_sprite.play("down")
		if direction.x < 0:
			animated_sprite.flip_h = true
			animated_sprite.play("left")
		elif direction.x > 0:
			animated_sprite.flip_h = false
			animated_sprite.play("right")		

# 停止钓鱼
func stop_fishing():
	FISNING = false
	rod.hide()
	rod.set_line_length(0)  # 设置鱼线长度

#缩放视口
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		var zoom_val = camera_2d.zoom.x + 0.1
		camera_2d.zoom = Vector2(zoom_val,zoom_val)
	elif Input.is_action_just_pressed("zoom_out"):	
		var zoom_val = camera_2d.zoom.x - 0.1
		camera_2d.zoom = Vector2(zoom_val,zoom_val)		
