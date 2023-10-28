extends VBoxContainer

const SpellModify = preload("res://scenes/spell_modify.tscn")

var spell_data: Resource

func _ready():
	$CastSpellButton.connect("pressed", _on_cast_spell)
	$ToggleInfoButton.connect("pressed", _toggle_extra_info)
	$CastModifiedButton.connect("pressed", _on_create_modified_spell)

func populate_spell():
	name = spell_data.name
	$Name.text = "Spell Name: " + str(spell_data.name)
	$Difficulty.text = "Difficulty: " + str(spell_data.current_difficulty)
	$KiCost.text = "Ki Cost: " + str(spell_data.ki_cost)
	if spell_data.permanence == "permanent":
		$KiCost.text += " (Max Ki: -1)"
	$AOEDamage.text = "AOE Damage: " + str(spell_data.aoe_damage)
	$TempDamage.text = "Temp Damage: " + str(spell_data.temp_damage)
	$TimesCast.text = "Times Cast: " + str(spell_data.mastery)
	
	$ExtraInfo/Range.text = "Range: " + str(spell_data.range)
	$ExtraInfo/AOE.text = "AOE: " + str(spell_data.aoe)
	$ExtraInfo/Speed.text = "Speed: " + str(spell_data.speed)
	$ExtraInfo/Permanence.text = "Permanence: " + str(spell_data.permanence)
	$ExtraInfo/CastingTime.text = "Casting Time: " + str(spell_data.casting_time)
	$ExtraInfo/NumElements.text = "Number of Elements: " + str(spell_data.num_elements)
	$ExtraInfo/TempChange.text = "Temp Change: " + str(spell_data.temp_change)
	

func _on_cast_spell():
	spell_data.mastery += 1
	spell_data.calculate_current_difficulty()
	populate_spell()

func _toggle_extra_info():
	$ExtraInfo.visible = not $ExtraInfo.visible

func _on_create_modified_spell():
	var spell_modify = SpellModify.instantiate()
	spell_modify.base_spell = spell_data
	add_child(spell_modify)
	spell_modify.connect("popup_hide", func(): spell_modify.queue_free())
	spell_modify.popup()
