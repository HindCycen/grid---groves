extends Node2D

var health: int
var max_health: int
var coins: int
var level: int
var abilities: Array
var card_pile: Array

signal init_okay # NOTE: When drawing other child nodes, don't use _ready(), wait for this.

# Init player data
func _ready() -> void:
    health = DataSave.get_data("player.health")
    max_health = DataSave.get_data("player.max_health")
    coins = DataSave.get_data("player.coins")
    level = DataSave.get_data("player.level")
    abilities = DataSave.get_data("player.abilities")
    card_pile = DataSave.get_data("player.card_pile")
    init_okay.emit()