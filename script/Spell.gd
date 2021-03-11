extends Node2D

var _new_InputName := preload("res://script/library/InputName.gd").new()
var _new_GroupName := preload("res://script/library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://script/library/ConvertCoord.gd").new()

const MouseControl := preload("res://script/MouseControl.gd")
const PCMove := preload("res://script/PCMove.gd")
const DungeonBoard := preload("res://script/DungeonBoard.gd")
const RemoveObject := preload("res://script/RemoveObject.gd")
const Schedule := preload("res://script/Schedule.gd")
const Magic := preload("res://script/Magic.gd")

var _ref_MouseControl: MouseControl
var _ref_PCMove: PCMove
var _ref_DungeonBoard: DungeonBoard
var _ref_RemoveObject: RemoveObject
var _ref_Schedule: Schedule
var _ref_Magic: Magic

var _current_spell: String
var _process_input: bool = false
var _pc: Sprite

signal emit_message(message)


func cast_spell(spell: String) -> void:
	_current_spell = spell
	_process_input = true

	var pc_pos = _new_ConvertCoord.vector_to_array(_pc.position)
	
	if spell == _new_InputName.SPELL_FIREBALL:
		if not _ref_Magic.is_mana_nearby(_new_GroupName.MANA_FIRE, pc_pos[0], pc_pos[1], 3):
			emit_signal("emit_message", "No nearby fire mana! Cast ritual first")
			_end_cast()
			return

		emit_signal("emit_message", "Select unit to cast a fireball on")
		set_process_unhandled_input(true)
		_ref_MouseControl.set_active(true)
		return
	
	if spell == _new_InputName.SPELL_RITUAL_FIRE:

		_ref_Magic.create_mana(_new_GroupName.MANA_FIRE ,pc_pos[0], pc_pos[1])
		emit_signal("emit_message", "You invoke fire")
		_end_cast()
		_ref_Schedule.end_turn()
		return
	
	_end_cast()


func _unhandled_input(event):
	if event.is_action_pressed(_new_InputName.CANCEL_SPELL):
		_end_cast()


func _end_cast():
	_process_input = false
	set_process_unhandled_input(false)
	_ref_MouseControl.set_active(false)
	_ref_PCMove.set_process_unhandled_input(true)


func _cast_spell_at(spell: String, x: int, y: int):
	if spell == _new_InputName.SPELL_FIREBALL:
		var enemy = _ref_DungeonBoard.get_sprite(_new_GroupName.ENEMY, x, y)
		if enemy == null:
			return

		var pc_pos = _new_ConvertCoord.vector_to_array(_pc.position)
		var mana = _ref_Magic.get_nearby_mana(_new_GroupName.MANA_FIRE, pc_pos[0], pc_pos[1], 3)
		var mana_pos = _new_ConvertCoord.vector_to_array(mana.position)
		var mana_x = mana_pos[0]
		var mana_y = mana_pos[1]
		_ref_RemoveObject.remove(_new_GroupName.MANA, mana_x, mana_y)

		_ref_RemoveObject.remove(_new_GroupName.ENEMY, x, y)
		emit_signal("emit_message", "The dwarf dies in a burning mess!")
		_end_cast()
		_ref_Schedule.end_turn()


func _on_MouseControl_mouse_click(x, y):
	if _process_input == true:
		_cast_spell_at(_current_spell, x, y)


func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite
