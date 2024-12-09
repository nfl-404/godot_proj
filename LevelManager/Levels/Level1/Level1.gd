extends BaseLevel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('?player', player)
	add_child(player)
	await get_tree().create_timer(3).timeout
	LevelManager.load_level('Sandbox')
	LevelManager.switch('Sandbox')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tree_entered() -> void:
	player = LevelManager.player.instantiate()
