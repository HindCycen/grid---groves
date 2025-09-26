extends Button

func _ready() -> void:
    var bot = get_parent().get_node("Bot")
    if bot:
        bot.connect("movement_started", Callable(self, "_on_bot_movement_started"))
        bot.connect("movement_ended", Callable(self, "_on_bot_movement_ended"))
    disabled = false

func _on_bot_movement_started() -> void:
    # Bot开始移动时禁用按钮
    disabled = true

func _on_bot_movement_ended() -> void:
    # Bot停止移动时启用按钮
    disabled = false