extends GPUParticles2D

@onready var area: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.emission_box_extents.x = area.position.x
	self.emission_box_extents.y = area.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
