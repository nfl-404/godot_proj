extends CharacterBody2D

class_name BaseCharacter

var health: float
var mana: float
var rally: float

var onJumpHooks: Dictionary = {}
var onAttackHooks: Dictionary = {}

var _current_speed = 0.0
var _target_speed = 0.0
var _max_speed = 300.0
var _accel = 50.0
var _jump_velocity = -600.0
var _direction = 0
var _lastDirection = 0

func _physics_process(delta: float) -> void:
	var onFloor = is_on_floor()
	#if _current_speed != 0: print('/',_current_speed)
	
	if not onFloor:
		velocity += get_gravity() * delta
		
	_target_speed = _direction * _max_speed
	
	var diff = _target_speed - _current_speed
	var speed_change = diff if abs(diff) < abs(_accel) else abs(diff) / diff * _accel
	_current_speed += speed_change

	#if _direction && onFloor:
		#_current_speed += _direction * _accel
	#elif _direction && !onFloor:
		##TODO
		#_current_speed += _direction * _accel / 2
	#elif _current_speed != 0 && onFloor:
		#var slowdown = abs(_current_speed) / _current_speed * _slowd
		#_current_speed = 0 if abs(slowdown) > abs(_current_speed) else _current_speed - slowdown
		
	#if abs(_current_speed) > abs(_max_speed):
		#_current_speed = abs(_current_speed) / _current_speed * _max_speed
	
	#if _current_speed != 0: print('\\',_current_speed)
	velocity.x = _current_speed

	move_and_slide()
