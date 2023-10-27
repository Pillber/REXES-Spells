extends VBoxContainer

const Spell = preload("res://spell.tscn")

@onready var spells = $SpellScroll/Spells


func add_spell(spell):
	var new_spell = Spell.instantiate()
	new_spell.spell_data = spell
	new_spell.name = spell.name
	
	spells.add_child(new_spell)
	
func reload_spells():
	for spell in spells.get_children():
		spell.spell_data = SpellData.spells[spell.name]
		spell.populate_spell()

func remove_spell(spell_to_remove):
	for spell in spells.get_children():
		if spell.name == spell_to_remove.name:
			spells.remove_child(spell)
			break
