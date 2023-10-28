extends VBoxContainer

@onready var spell_name = $VBoxContainer/SpellName 
@onready var range = $VBoxContainer/Range/RangeOption
@onready var aoe = $VBoxContainer/AOE/AOEOption
@onready var speed = $VBoxContainer/Speed/SpeedOption
@onready var permanence = $VBoxContainer/Permanence/PermanenceOption
@onready var casting_time = $VBoxContainer/CastingTime/CastingTimeOption
@onready var num_elements = $VBoxContainer/NumElements/NumElementsOption
@onready var temp_change = $VBoxContainer/TempChange/TempChangeOption
@onready var mastery = $VBoxContainer/Mastery/MasteryOption

signal spell_edited(spell)
signal remove_spell(spell)

var spell

func _ready():
	$VBoxContainer/SaveEditsButton.connect("pressed", _on_spell_done_editing)
	$VBoxContainer/RemoveSpellButton.connect("pressed", _on_spell_remove)
	$ItemList.connect("item_activated", _on_spell_edit_selected)
	
func populate_spell_edit():
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
		
func remove_spell_from_list(spell):
	$ItemList.remove_item(select_from_text($ItemList, spell.name))

func select_from_text(option_button, text):
	for index in range(option_button.item_count):
		if (option_button.get_item_text(index) == text):
			return index
	return -1

func edit_spell(spell):
	self.spell = spell
	spell_name.text = "Name: " + str(spell.name)
	range.select(select_from_text(range, spell.range))
	aoe.select(select_from_text(aoe, spell.aoe))
	speed.select(select_from_text(speed, spell.speed))
	permanence.select(select_from_text(permanence, spell.permanence))
	casting_time.select(select_from_text(casting_time, spell.casting_time))
	num_elements.value = spell.num_elements
	temp_change.value = spell.temp_change
	mastery.value = spell.mastery
	
func _on_spell_done_editing():
	var data = {}
	data["name"] = (spell.name)
	data["range"] = (range.get_item_text(range.selected))
	data["aoe"] = (aoe.get_item_text(aoe.selected))
	data["speed"] = (speed.get_item_text(speed.selected))
	data["permanence"] = (permanence.get_item_text(permanence.selected))
	data["casting_time"] = (casting_time.get_item_text(casting_time.selected))
	data["num_elements"] = (num_elements.value)
	data["temp_change"] = (temp_change.value)
	data["mastery"] = (mastery.value)
	
	spell = SpellData.SpellInfo.new(data)
	emit_signal("spell_edited", spell)


func _on_spell_remove():
	$VBoxContainer.visible = false
	emit_signal("remove_spell", spell)

func _on_spell_edit_selected(index):
	var spell_name = $ItemList.get_item_text(index)
	edit_spell(SpellData.spells[spell_name])
	$VBoxContainer.visible = true
	pass

