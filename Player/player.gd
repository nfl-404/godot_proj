extends BaseCharacter

enum EActions {
	NONE = 0,
	ATTACK = 1,
	JUMP = 2,
	DASH = 3,
	BLOCK = 4,
}

var combo = 0

var history = History.new()

var skill1: BaseSkill = DevilTrigger.new()

@onready var animation: AnimationPlayer = $Animation
@onready var hit_detector: Area2D = $HitDetector
@onready var sprite: Sprite2D = $Sprite
@onready var ui: CanvasLayer = $Camera2D/Ui

func _ready() -> void:
	health = 100
	mana = 100
	rally = 0
	
	history.Init()
	skill1.Init(self)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	skill1.process()
	
	var currentAction = getInputAction()
	if(currentAction): handleInputAction(currentAction)
	
	#TODO maybe move higher
	handleRotation()
	updateAnimation()
	updateUI()
	
	move_and_slide()
	
func getInputAction() -> EActions:
	#TODO
	if Input.is_action_just_released("block"):
		if [
			HistoryEvents.EAttackStates.PARRY,
			HistoryEvents.EAttackStates.BLOCK,
		].has(history.attack_state): removeBlock()
	if Input.is_action_just_pressed("skill_1"):
		skill1.onPress()
	elif Input.is_action_just_released("skill_1"):
		skill1.onRelease()
	
	if Input.is_action_just_pressed("dash"):
		return EActions.DASH
	if Input.is_action_just_pressed("attack"):
		return EActions.ATTACK
	if Input.is_action_just_pressed("block"):
		return EActions.BLOCK
	if Input.is_action_just_pressed("jump"):
		return EActions.JUMP
	return EActions.NONE
	
func handleInputAction(action: EActions) -> void:
	#print('action', action)
	#TODO
	#if action != EActions.ATTACK: resetCombo()
	
	match action:
		EActions.NONE: pass
		EActions.JUMP:
			jump()
		EActions.DASH:
			_current_speed = _max_speed * 3 * _lastDirection
		EActions.ATTACK:
			if 	history.attack_state == HistoryEvents.EAttackStates.ATTACK: return
			var diff = history.GetDiff(HistoryEvents.LAST_ATTACK)
			if diff > 0.5 || combo >= 2:
				resetCombo()
			else:
				combo += 1
			match combo:
				0: animation.play('Attack1')
				1: animation.play('Attack2')
				2: animation.play('Attack3')
			history.attack_state = HistoryEvents.EAttackStates.ATTACK
		EActions.BLOCK:
			history.attack_state = HistoryEvents.EAttackStates.PARRY
			animation.play('Parry')
	
func handleRotation() ->void:
	_direction = Input.get_axis("move_left", "move_right")
	if(_direction != 0):
		_lastDirection = _direction
		sprite.flip_h = _lastDirection < 0
		hit_detector.scale.x = _lastDirection
	
func updateAnimation() -> void:
	if history.attack_state != HistoryEvents.EAttackStates.NONE: return
	
	if !is_on_floor():
		if velocity.y < 0: animation.play('Jump')
		else: animation.play('Fall')
		return
	
	if is_on_floor():
		if _current_speed == 0: animation.play('Idle')
		elif abs(_current_speed) <= _max_speed: animation.play('Run')
		else: animation.play('Fall')
		return

	#if _current_speed:
		#sprite.flip_h = _current_speed < 0
	
	#if velocity.y < 0:
		#anim.play("Jump")
		#return
	#if velocity.y > 0:
		#anim.play("Fall")
		#return
	#if velocity.x:
		#anim.play("Run")
	#else:
		#anim.play("idle")
	#anim.play("Idle")
	
func updateUI() -> void:
	#TODO
	var modif: float = 2.5
	
	var hpBarValue = health * modif
	var rallyBarValue = (health - rally) * modif
	if rallyBarValue <= 0: rallyBarValue = 1
	
	var mpBarValue = mana * modif
	
	(ui.find_child('BarRally') as ColorRect).size.x = rallyBarValue
	(ui.find_child('BarHp') as ColorRect).size.x = hpBarValue
	(ui.find_child('BarMp') as ColorRect).size.x = mpBarValue
	
func jump() -> void:
	print('onJumpHooks ', onJumpHooks)
	var _velocity = _jump_velocity
	for key in onJumpHooks.keys():
		var hook = onJumpHooks[key]
		_velocity = hook.call(_velocity)
	
	if is_on_floor(): velocity.y = _velocity
	elif is_on_wall(): 
		velocity.y = _velocity
		forceRotate()
		_current_speed = _lastDirection * _max_speed * 2
	
func forceRotate() -> void:
	_lastDirection = _lastDirection * -1
	sprite.flip_h = _lastDirection < 0
	hit_detector.scale.x = _lastDirection
	
func strike(damage: float) -> void:
	history.Update(HistoryEvents.LAST_ATTACK)
	
	for key in onJumpHooks.keys():
		var hook = onAttackHooks[key]
		damage = hook.call(damage)
	
	var areas = hit_detector.get_overlapping_bodies()
	for area in areas:
		if area.has_method("takeDamage"):
			area.takeDamage(damage)
	
	history.attack_state = HistoryEvents.EAttackStates.NONE
	animation.play('Idle')
	
func holdBlock() -> void:
	history.attack_state = HistoryEvents.EAttackStates.BLOCK
	animation.play('Block')
	
func removeBlock() -> void:
	history.attack_state = HistoryEvents.EAttackStates.NONE
	animation.play('Idle')
	
func takeDamage(
	amount: float,
	impact: Vector2 = Vector2(0,0),
) -> void:
	match history.attack_state:
		HistoryEvents.EAttackStates.PARRY:
			print('Parry!')
		HistoryEvents.EAttackStates.BLOCK:
			rally += amount
		_:
			health -= amount + rally
			rally = 0
		
	_current_speed = impact.x
	
func resetCombo() -> void:
	combo = 0
