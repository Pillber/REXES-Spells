extends Popup

const NoChange = "No change"

@onready var range = $VBoxContainer/Range/RangeOption
@onready var aoe = $VBoxContainer/AOE/AOEOption
@onready var speed = $VBoxContainer/Speed/SpeedOption
@onready var permanence = $VBoxContainer/Permanence/PermanenceOption
@onready var casting_time = $VBoxContainer/CastingTime/CastingTimeOption
@onready var num_elements = $VBoxContainer/NumElements/NumElementsOption
@onready var temp_change = $VBoxContainer/TempChange/TempChangeOption

var base_spell = null
var default_indexes = []
var local_difficulty_modifier = 0
var modified_difficulty_modifier = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("about_to_popup", _on_popup)
	$VBoxContainer/MakeSpellButton.connect("pressed", _on_make_modified_spell)
	$VBoxContainer/DifficultyContainer/AddDifficulty.connect("pressed", _on_add_difficulty)
	$VBoxContainer/DifficultyContainer/ReduceDifficulty.connect("pressed", _on_reduce_difficulty)
	
func setup_option(option_button, category, base_spell_value):
	var index = -1
	for type in SpellData.data[category].keys():
		index += 1
		if type == base_spell_value:
			option_button.add_item(NoChange)
			default_indexes.append(index)
			continue
		option_button.add_item(type)

func populate_spell_modify():
	range.clear()
	aoe.clear()
	speed.clear()
	permanence.clear()
	casting_time.clear()
	default_indexes.clear()
	
	setup_option(range, "Range", base_spell.range)
	setup_option(aoe, "AOE", base_spell.aoe)
	setup_option(speed, "Speed", base_spell.speed)
	setup_option(permanence, "Permanence", base_spell.permanence)
	setup_option(casting_time, "CastingTime", base_spell.casting_time)
	
	$VBoxContainer/DifficultyContainer/Difficulty.text = "Difficulty: "
	$VBoxContainer/KiCost.text = "Ki Cost: "
	$VBoxContainer/AOEDamage.text = "AOE: "
	$VBoxContainer/TempDamage.text = "Temp: "


func _on_popup():
	$VBoxContainer/Name.text = "Name: " + base_spell.name
	populate_spell_modify()
	local_difficulty_modifier = base_spell.difficulty_modifier
	range.select(default_indexes[0])
	aoe.select(default_indexes[1])
	speed.select(default_indexes[2])
	permanence.select(default_indexes[3])
	casting_time.select(default_indexes[4])

func get_difficulty_modifier(option_button, data_type):
	var selected = option_button.get_item_text(option_button.selected)
	if not selected == NoChange:
		return SpellData.data[data_type][selected]
	return 0
	
func clamp_modifier(modifier, category, base_spell_modifier):
	return max(-1 * (SpellData.data[category][base_spell_modifier] - modifier), 0)

func calculate_difficulty_modifier():
	var range_modifier = get_difficulty_modifier(range, "Range")
	range_modifier = clamp_modifier(range_modifier, "Range", base_spell.range)
	
	var aoe_modifier = get_difficulty_modifier(aoe, "AOE")
	aoe_modifier = clamp_modifier(aoe_modifier, "AOE", base_spell.aoe)
	
	var speed_modifier = get_difficulty_modifier(speed, "Speed")
	speed_modifier = clamp_modifier(speed_modifier, "Speed", base_spell.speed)
	
	var permanence_modifier = get_difficulty_modifier(permanence, "Permanence")
	permanence_modifier = clamp_modifier(permanence_modifier, "Permanence", base_spell.permanence)
	
	var casting_time_modifier = get_difficulty_modifier(casting_time, "CastingTime")
	casting_time_modifier = clamp_modifier(casting_time_modifier, "CastingTime", base_spell.casting_time)
	
	var temp_change_modifier = max(-1 * (5 * base_spell.temp_change - 5 * temp_change.value), 0)
	
	var all_modifier = range_modifier + aoe_modifier + speed_modifier + permanence_modifier + casting_time_modifier + temp_change_modifier
	all_modifier *= max(1, base_spell.num_elements - num_elements.value + 1)
	
	modified_difficulty_modifier = all_modifier
	
	
# Difficulty: 10 (+2) (+6)   (+)(-)

func _on_add_difficulty():
	local_difficulty_modifier += 1
	display_difficulty()

func _on_reduce_difficulty():
	if base_spell.difficulty + modified_difficulty_modifier + local_difficulty_modifier > 1:
		local_difficulty_modifier -= 1
	display_difficulty()

func display_difficulty():
	calculate_difficulty_modifier()
	$VBoxContainer/DifficultyContainer/Difficulty.text = "Difficulty: " + str(base_spell.difficulty + modified_difficulty_modifier + local_difficulty_modifier)
	if modified_difficulty_modifier != 0:
		$VBoxContainer/DifficultyContainer/Difficulty.text += " (" + ("+" if modified_difficulty_modifier > 0 else "") + str(modified_difficulty_modifier) + " modifications)"
	if local_difficulty_modifier != 0:
		$VBoxContainer/DifficultyContainer/Difficulty.text += " (" + ("+" if local_difficulty_modifier > 0 else "") + str(local_difficulty_modifier) + " extras)"

func _on_make_modified_spell():
	display_difficulty()
	var ki_cost_key = aoe.get_item_text(aoe.selected)
	if ki_cost_key == NoChange:
		ki_cost_key = base_spell.aoe
	$VBoxContainer/KiCost.text = "Ki Cost: " + str(SpellData.data["AOEki"][ki_cost_key])
	if permanence.get_item_text(permanence.selected) == "permanent":
		$VBoxContainer/KiCost.text += " (Max Ki: -1)"
	var aoe_damage_key = aoe.get_item_text(aoe.selected)
	if aoe_damage_key == NoChange:
		aoe_damage_key = base_spell.aoe
	$VBoxContainer/AOEDamage.text = "AOE Damage: " + str(SpellData.data["AOEDamage"][aoe_damage_key])
	var temp_damage_string = str(temp_change.value) + "d4" if (temp_change.value != 0) else str(0)
	$VBoxContainer/TempDamage.text = "Temp Damage: " + temp_damage_string
