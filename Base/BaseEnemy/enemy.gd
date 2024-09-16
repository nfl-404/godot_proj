extends CharacterBody2D
class_name BaseEnemy

const max_health = 100

var health = 1
var chase = false
var strike = false

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const DAMAGE = 5

var animPlayer: AnimationPlayer

#@onready var player: Enemy = %Player

@onready var color_rect: ColorRect = $ColorRect
@onready var hit_detector: Area2D = $HitDetector

func _on_ready() -> void:
	health = max_health
	color_rect.size.x = 20 * health / max_health

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	#var direction = (player.position - self.position).normalized()
	#var direction = (player.position - self.position).normalized()
	if strike:
		animPlayer.play("strike")
		
	#elif chase:
		#velocity.x = direction.x * SPEED
		#anim.flip_h = direction.x > 0
		#anim.play("Run")
	else:
		velocity.x = 0
		animPlayer.play("idle")
	move_and_slide()


func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false

func _on_hit_detector_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	#print(areas)
	#anim.play("Strike")
	strike = true
	#body.takeDamage(DAMAGE)
	
	
func takeDamage(amount: float) -> void:
	health -= amount
	color_rect.size.x = 20 * health / max_health
	if health <= 0:
		death()
	
func death():
	self.queue_free()
