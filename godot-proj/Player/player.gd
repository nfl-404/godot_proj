extends BaseCharacter

var health = 200

func _ready() -> void:
	#anim.play("Idle")
	pass


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _jump_velocity

	_direction = Input.get_axis("move_left", "move_right")

	updateAnimation()
	move_and_slide()
	
func updateAnimation() -> void:
	pass
	#if velocity.x:
		#anim.flip_h = velocity.x < 0
	#
	#if velocity.y < 0:
		#anim.play("Jump")
		#return
	#if velocity.y > 0:
		#anim.play("Fall")
		#return
	#if velocity.x:
		#anim.play("Run")
	#else:
		#anim.play("Idle")

func takeDamage(amount: float) -> void:
	health -= amount
