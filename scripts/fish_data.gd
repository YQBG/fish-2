extends CharacterBody2D
class_name FishData

@onready var fishpond: TileMapLayer = $"../Fishpond"
# 基础属性
@export var speed: float = 2000.0  # 鱼的移动速度
@export var texture: AtlasTexture #鱼的纹理
@export var direction_smoothness: float = 0.1  # 方向平滑过渡的程度
# 行为属性
@export var change_direction_time: float = 1.0  # 改变方向的时间间隔（秒）

# 内部变量
var direction: Vector2  # 当前移动方向
var target_direction: Vector2  # 目标移动方向
#鱼塘的四个边界值
var fishpond_up: int
var fishpond_down: int
var fishpond_left: int
var fishpond_right: int
var pond_area: Rect2  # 鱼塘区域
var time_elapsed: float = 0.0  # 累积时间，用于计算改变方向的时间点

func _ready() -> void:
	randomize()  # 随机种子初始化
	change_direction()  # 初始化第一次的随机方向
	
func _physics_process(delta: float) -> void:
	time_elapsed += delta  # 增加累积时间

	# 检查是否需要改变方向
	if time_elapsed >= change_direction_time:
		change_direction()  # 改变目标方向
		time_elapsed = 0.0  # 重置累积时间
	# 使用线性插值平滑过渡到目标方向
	direction = direction.lerp(target_direction, direction_smoothness).normalized()
	# 根据当前方向和速度计算位移
	velocity = direction * speed * delta
	move_and_slide()
	# 目标移动方向
	target_direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
	check_boundaries()

func change_direction() -> void:
	target_direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()

func set_pond_area(area: Rect2) -> void:
	#拿到home场景传递过来的值
	pond_area = area
	
	var global_pos = fishpond.map_to_local(pond_area.position)
	var global_size = fishpond.map_to_local(pond_area.size)
	fishpond_up = global_pos.y
	# 这里做减法是因为拿到的位置有偏差，鱼塘的边界值总是大于实际的边界。
	# 我也不知道应该如何调整，索性就减去具体的数字。
	fishpond_down = (global_pos.y + global_size.y) - 60
	fishpond_left = global_pos.x
	fishpond_right = (global_pos.x + global_size.x) - 75

func check_boundaries() -> void:
	if position.x < fishpond_left:
		direction.x = abs(direction.x)  # 反转X方向
	elif position.x > fishpond_right:
		direction.x = -abs(direction.x)  # 反转X方向
		
	if position.y < fishpond_up:
		direction.y = abs(direction.y)  # 反转Y方向
	elif position.y > fishpond_down:
		direction.y = -abs(direction.y)  # 反转Y方向
