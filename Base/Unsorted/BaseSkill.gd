class_name BaseSkill extends Node

var _owner : BaseCharacter
var _state : Dictionary = {}
var _constants : Dictionary = {}
var _active : bool = false

func Init(owner: BaseCharacter) -> void:
	_owner = owner
		
func CreateConstants(constants: Array):
	for constant in constants:
		_constants[constant[0]] = constant[1]
		
func CreateState(items: Array):
	for item in items:
		_state[item[0]] = item[1]
		
func onPress():
	pass
	
func onRelease():
	pass
	
func onProcess():
	pass
	
func process():
	if _active:
		onProcess()
	
	#pass
	#_internals[HistoryEvents.LAST_ATTACK] = 0.0
	#_internals[HistoryEvents.IS_ATTACKING] = false
	#_internals[HistoryEvents.ATTACK_STATE] = HistoryEvents.EAttackStates.NONE
