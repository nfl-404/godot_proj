class_name DevilTrigger extends BaseSkill

var _id = 'skill1'

func Init(owner: BaseCharacter):
	super.Init(owner)
	
	var constants = [
		['duration', 200]
	]
	var state = [
		['time', 0]
	]
	CreateConstants(constants)
	CreateState(state)

func onPress():
	if _active: deactivate()
	else: activate()
	
func onProcess():
	_state.time += 1
	#print('skill is active ', _state)
	if _state.time >= _constants.duration:
		deactivate()
		
func activate():
	_owner.mana -= 20
	_active = true
	_owner.onAttackHooks[_id] = attackBuff
	_owner.onJumpHooks[_id] = jumpBuff
	
func deactivate():
	_active = false
	_state.time = 0	
	_owner.onAttackHooks.erase(_id)
	_owner.onJumpHooks.erase(_id)
	
func attackBuff(damage: float):
	return damage * 3
	
func jumpBuff(velocity: float):
	return velocity * 1.5

func Destroy():
	queue_free()
