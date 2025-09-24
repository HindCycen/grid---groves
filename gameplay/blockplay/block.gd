extends Node2D
"""
    Class for show the whole block.
    var slices: for each slice of the block.
"""
var slices: Array[Node] = []
var is_pressed: bool = false

func _ready() -> void:
    for child in get_children():
        if child.has_method("on_called"):
            slices.append(child)
            if child.has_signal("is_pressed"):
                child.connect("is_pressed", Callable(self, "on_child_pressed"))
                child.connect("is_released", Callable(self, "on_child_released"))

func on_child_pressed(child: Node) -> void:
    if slices.has(child):
        is_pressed = true

func on_child_released(child: Node) -> void:
    if slices.has(child):
        is_pressed = false

func _process(delta: float) -> void:
    if is_pressed:
        global_position = get_global_mouse_position()