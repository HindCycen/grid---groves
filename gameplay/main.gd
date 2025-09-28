extends Node2D

func _ready():
	DataSave.init_default_data()
	if not DataSave.load():
		DataSave.save()
