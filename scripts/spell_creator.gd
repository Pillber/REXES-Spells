extends VBoxContainer

@onready var name_edit = $Name/NameEdit
@onready var range = $Range/RangeOption
@onready var aoe = $AOE/AOEOption
@onready var speed = $Speed/SpeedOption
@onready var permanence = $Permanence/PermanenceOption
@onready var casting_time = $CastingTime/CastingTimeOption
@onready var num_elems = $NumElements/NumElementsOption
@onready var temp_change = $TempChange/TempChangeOption

signal spell_created(spell)

func _ready():
	$MakeSpellButton.connect("pressed", _on_make_spell)

func populate_spell_creator():
	for range_type in SpellData.data["Range"].keys():
		range.add_item(range_type)
		
	for aoe_type in SpellData.data["AOE"].keys():
		aoe.add_item(aoe_type)
		
	for speed_type in SpellData.data["Speed"].keys():
		speed.add_item(speed_type)
		
	for perm_type in SpellData.data["Permanence"].keys():
		permanence.add_item(perm_type)
		
	for casting_type in SpellData.data["CastingTime"].keys():
		casting_time.add_item(casting_type)

func _on_make_spell():
	var data = {}
	data["name"] = (name_edit.text)
	data["range"] = (range.get_item_text(range.selected))
	data["aoe"] = (aoe.get_item_text(aoe.selected))
	data["speed"] = (speed.get_item_text(speed.selected))
	data["permanence"] = (permanence.get_item_text(permanence.selected))
	data["casting_time"] = (casting_time.get_item_text(casting_time.selected))
	data["num_elements"] = (num_elems.value)
	data["temp_change"] = (temp_change.value)
	data["mastery"] = 0
	data["difficulty_modifier"] = 0
	emit_signal("spell_created", SpellData.SpellInfo.new(data))
