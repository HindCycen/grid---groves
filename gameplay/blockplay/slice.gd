class_name Slice extends Node2D
"""
    A slice for a certain block.
    It is always a child of the block.
    var partial_position: to show the slice's position in the block
"""

@export var partial_position: Vector2

signal is_pressed(signal_node: Node)
signal is_released(signal_node: Node)

func _ready() -> void:
	position = partial_position * Global.grid_size
	set_process_input(true)
	$Area2D.connect("input_event", Callable(self, "_input_event"))

func on_called() -> void:
	pass

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
		on_called()
	
