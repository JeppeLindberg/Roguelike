extends Node2D

var _new_InputName := preload("res://script/library/InputName.gd").new()
var _new_GroupName := preload("res://script/library/GroupName.gd").new()

const MouseControl := preload("res://script/MouseControl.gd")
const PCMove := preload("res://script/PCMove.gd")
const DungeonBoard := preload("res://script/DungeonBoard.gd")
const RemoveObject := preload("res://script/RemoveObject.gd")
const Schedule := preload("res://script/Schedule.gd")

var _ref_MouseControl: MouseControl
var _ref_PCMove: PCMove
var _ref_DungeonBoard: DungeonBoard
var _ref_RemoveObject: RemoveObject
var _ref_Schedule: Schedule

var _current_spell: String
var _process_input: bool = false

signal emit_message(message)


func cast_spell(spell: String) -> void:
	_current_spell = spell
	_process_input = true
	
	if spell == _new_InputName.SPELL_FIREBALL:
		emit_signal("emit_message", "Select unit to cast a fireball on")
		set_process_unhandled_input(true)
		_ref_MouseControl.set_active(true)
		return
	
	if spell == _new_InputName.SPELL_HEAL:
		emit_signal("emit_message", "The healing energy fizzles")
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

		_ref_RemoveObject.remove(_new_GroupName.ENEMY, x, y)
		emit_signal("emit_message", "The dwarf dies in a burning mess!")
		_end_cast()
		_ref_Schedule.end_turn()


func _on_MouseControl_mouse_click(x, y):
	if _process_input == true:
		_cast_spell_at(_current_spell, x, y)

