extends Node2D
class_name BaseLevel

@export var player: BaseCharacter

func _ready() -> void:
	print('READY CALLED')
	add_child(LevelManager.player)

func spawn():
	print('spawned')
