extends Node2D

const LEVELS_DIRECTORY = 'res://LevelManager/Levels'
const DEFAULT_LEVEL = 'Sanbox'

var _levels: Dictionary = {}

var player = preload("res://Player/player.tscn")

func _on_ready() -> void:	
	var dir = DirAccess.open(LEVELS_DIRECTORY)
	print('Levels: ', dir.get_directories())
	for level in dir.get_directories():
		_levels[level] = null

func load_level(name: String):
	if !_levels.has(name):
		print('Level ' + name + ' not found')
		return
	if _levels[name] != null:
		print('Level ' + name + ' alreay loaded')
		return
	_levels[name] = load(get_level_path(name))
	print('levels: ', get_level_path(name), ' ', _levels)
	
func start(name: String): 
	var tree: SceneTree = get_tree()
	
	if !_levels.has(name) || !_levels[name]:
		print('Level ' + name + ' not loaded')
		return
	tree.change_scene_to_packed(_levels[name])
	
func switch(name: String):
	var tree: SceneTree = get_tree()
	
	if !_levels.has(name) || !_levels[name]:
		print('Level ' + name + ' not loaded')
		return

	tree.change_scene_to_packed(_levels[name])
	
func get_level_path(name):
	return LEVELS_DIRECTORY + '/' + name + '/' + name + '.tscn'
	
	
