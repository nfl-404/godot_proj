class_name History

var _internals = {}

func Init() -> void:
	_internals[HistoryEvents.LAST_ATTACK] = 0.0
	_internals[HistoryEvents.IS_ATTACKING] = false
	_internals[HistoryEvents.ATTACK_STATE] = HistoryEvents.EAttackStates.NONE
	
func Update(name: String) -> void:
	_internals[name] = Time.get_unix_time_from_system()
	
func GetDiff(name: String) -> float:
	return Time.get_unix_time_from_system() - _internals[name]

var last_attack: float:
	get:
		return _internals[HistoryEvents.LAST_ATTACK] 
	set(value):
		assert(false, "Variable is readonly, use 'Update' instead")
		
var is_attacking: bool:
	get:
		return _internals[HistoryEvents.IS_ATTACKING]
	set(value):
		_internals[HistoryEvents.IS_ATTACKING] = !!value
		
var attack_state: int:
	get:
		return _internals[HistoryEvents.ATTACK_STATE]
	set(value):
		_internals[HistoryEvents.ATTACK_STATE] = value
