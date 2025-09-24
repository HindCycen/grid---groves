extends Node2D
"""
    A slice for a certain block.
    It is always a child of the block.
    var partial_position: to show the slice's position in the block
"""

@export var partial_position: Vector2

signal is_pressed(signal_node: Node)
signal is_released(signal_node: Node)

func _ready() -> void:
	position = partial_position * 16
	set_process_input(true)
	$Area2D.connect("input_event", Callable(self, "_input_event"))

func on_called() -> void:
	pass

func _input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print(shape_idx)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			handle_pressed()
		elif event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			handle_released()

func handle_pressed() -> void:
	is_pressed.emit(self)

func handle_released() -> void:
	is_released.emit(self)
