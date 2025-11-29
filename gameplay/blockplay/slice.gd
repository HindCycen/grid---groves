class_name Slice extends Node2D
"""
    A slice for a certain block.
    It is always a child of the block.
    var partial_position: to show the slice's position in the block
"""

@export var partial_position: Vector2
@export var slice_type: Global.SliceType = Global.SliceType.NULL

# 定义移动方向
@export var move_direction: Vector2 = Vector2(0, 1)  # 默认向下移动

# 导出纹理变量，用于设置Sprite2D的图像
@export var slice_texture: Texture2D

@export var base_damage: int = 0
@export var base_block: int = 0
@export var base_magic_num: int = 0

signal is_pressed(signal_node: Node)
signal is_released(signal_node: Node)

func _ready() -> void:
	position = partial_position * Global.grid_size
	set_process_input(true)
	$Area2D.connect("input_event", Callable(self, "_input_event"))
	$Area2D.connect("area_entered", Callable(self, "_on_area_entered"))
	
	# 如果设置了纹理，则应用到Sprite2D节点
	if slice_texture != null and has_node("Area2D/Sprite2D"):
		$Area2D/Sprite2D.texture = slice_texture

func on_called(direction: Vector2 = Vector2(0, 1)) -> void:
	# 传递方向参数给bot，告诉它如何移动
	print("ccb - direction: ", direction)

func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#print(_shape_idx)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			handle_pressed()
		elif event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			handle_released()

func handle_pressed() -> void:
	is_pressed.emit(self)

func handle_released() -> void:
	is_released.emit(self)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bot"):
		# 调用bot的set_next_move_direction方法设置移动方向
		if area.has_method("set_next_move_direction"):
			area.set_next_move_direction(move_direction)
		on_called(move_direction)
