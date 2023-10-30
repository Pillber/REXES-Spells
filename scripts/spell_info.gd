extends Resource

# saveable data entries
var name: String
var range: String
var aoe: String
var speed: String
var permanence: String
var casting_time: String
var num_elements: int
var temp_change: int
var mastery = 0 #max(difficulty - mastery * 2, ceil(difficulty / 2))
var difficulty_modifier = 0

# calculated data entries
var difficulty = 0
var current_difficulty = 0
var ki_cost = 0
var aoe_damage = 0
var temp_damage = ""


func save():
	return {
		"name" : name,
		"range" : range,
		"aoe" : aoe,
		"speed" : speed,
		"permanence" : permanence,
		"casting_time" : casting_time,
		"num_elements" : num_elements,
		"temp_change" : temp_change,
		"mastery" : mastery
	}

func _init(data = {"name":"Test Spell", "range":"touch", "aoe":"marble sized", "speed":"stationary", "permanence":"instant", "casting_time":"1 action", "num_elements":1, "temp_change":0, "mastery":0}):
	name = data["name"]
	range = data["range"]
	aoe = data["aoe"]
	speed = data["speed"]
	permanence = data["permanence"]
	casting_time = data["casting_time"]
	num_elements = data["num_elements"]
	temp_change = data["temp_change"]
	mastery = data["mastery"]
	
	calculate_difficulty()
	calculate_damage()
	calculate_ki_cost()
	

func calculate_difficulty():
	var _difficulty = 0
	_difficulty += SpellData.data["Range"][range]
	_difficulty += SpellData.data["AOE"][aoe]
	_difficulty += SpellData.data["Speed"][speed]
	_difficulty += SpellData.data["Permanence"][permanence]
	_difficulty += SpellData.data["CastingTime"][casting_time]
	_difficulty += 5 * temp_change
	_difficulty *= num_elements
	difficulty = _difficulty
	
	calculate_current_difficulty()
	
func calculate_current_difficulty():
	current_difficulty = max(difficulty - mastery * 2, ceil(difficulty / 2)) + difficulty_modifier
	
func calculate_damage():
	aoe_damage = SpellData.data["AOEDamage"][aoe]
	temp_damage = str(temp_change) + "d4" if (temp_change != 0) else str(0)
	
func calculate_ki_cost():
	ki_cost = SpellData.data["AOEki"][aoe]
