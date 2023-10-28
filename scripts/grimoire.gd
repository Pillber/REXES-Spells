extends Control

const SPELL_SAVE_FILE = "user://spells.txt"

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	var file = FileAccess.open("res://data/data.json", FileAccess.READ)
	SpellData.data = JSON.parse_string(file.get_as_text())
	
	$TabBar/SpellCreator.connect("spell_created", _on_spell_created)

	$TabBar/SpellEdit.connect("spell_edited", _on_spell_edited)
	$TabBar/SpellEdit.connect("remove_spell", _on_spell_removed)
	
	load_spells()
	$TabBar/SpellCreator.populate_spell_creator()
	$TabBar/SpellEdit.populate_spell_edit()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_spells()


func save_spells():
	var save = FileAccess.open(SPELL_SAVE_FILE, FileAccess.WRITE)
	for spell in SpellData.spells.values():
		var data = spell.save()
		var json = JSON.stringify(data)
		save.store_line(json)


func load_spells():
	if not FileAccess.file_exists(SPELL_SAVE_FILE):
		return
		
	var save_data = FileAccess.open(SPELL_SAVE_FILE, FileAccess.READ)
	while save_data.get_position() < save_data.get_length():
		var json = save_data.get_line()
		
		var data = JSON.parse_string(json) # dictionary of spell data
		
		var spell = SpellData.SpellInfo.new(data)
		
		_on_spell_created(spell)


func _on_spell_edited(spell):
	SpellData.spells[spell.name] = spell
	$TabBar/SpellList.reload_spells()


func _on_spell_removed(spell):
	SpellData.spells.erase(spell.name)
	$TabBar/SpellList.remove_spell(spell)
	$TabBar/SpellEdit.remove_spell_from_list(spell)


func _on_spell_created(spell):
	SpellData.spells[spell.name] = spell
	$TabBar/SpellList.add_spell(spell)
	$TabBar/SpellEdit/ItemList.add_item(spell.name)
	$TabBar/SpellList.reload_spells()
