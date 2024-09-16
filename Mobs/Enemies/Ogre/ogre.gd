extends BaseEnemy

func _on_ready() -> void:
	super._on_ready()
	animPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func _strike() -> void:
	var areas = hit_detector.get_overlapping_bodies()
	strike = false
	for area in areas:
		strike = true
		area.takeDamage(DAMAGE)
