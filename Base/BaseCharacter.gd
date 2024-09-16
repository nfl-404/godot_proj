extends CharacterBody2D

class_name BaseCharacter

var _speed = 300.0
var _jump_velocity = -400.0
var _direction = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if _direction:
		velocity.x = _direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)

	move_and_slide()
