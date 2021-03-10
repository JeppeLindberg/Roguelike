extends Node2D

const PC_ATTACK: String = "PCAttack"
const RELOAD_GAME: String = "ReloadGame"
const SPELL: String = "Spell"

const Schedule := preload("res://script/Schedule.gd")
const DungeonBoard := preload("res://script/DungeonBoard.gd")

var _pc: Sprite
var _ref_Schedule: Schedule
var _ref_DungeonBoard: DungeonBoard

var _new_InputName := preload("res://script/library/InputName.gd").new()
var _new_GroupName := preload("res://script/library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://script/library/ConvertCoord.gd").new()

signal pc_moved(message)
signal clear_message()


func _ready() -> void:
	set_process_unhandled_input(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(_new_InputName.INIT_WORLD):
		emit_signal("clear_message")
		get_node(RELOAD_GAME).reload()
		return

	if _pc == null:
		return

	var source: Array = _new_ConvertCoord.vector_to_array(_pc.position)
	if _is_move_input(event):
		emit_signal("clear_message")

		var target = _get_new_position(event, source)
		_try_move(target[0], target[1])
		return

	var _spell_input = _get_spell_input(event)
	if _spell_input != "":
		emit_signal("clear_message")

		set_process_unhandled_input(false)
		get_node(SPELL).cast_spell(_spell_input)
		return

	if event.is_action_pressed(_new_InputName.SKIP_TURN):
		emit_signal("clear_message")
		_ref_Schedule.end_turn()


func _try_move(x: int, y: int) -> void:
	if not _ref_DungeonBoard.is_inside_dungeon(x, y):
		emit_signal("pc_moved", "You cannot leave the map")
		return

	if _ref_DungeonBoard.has_sprite(_new_GroupName.WALL, x, y):
		emit_signal("pc_moved", "You bump into a wall")
		return

	if _ref_DungeonBoard.has_sprite(_new_GroupName.ENEMY, x, y):
		set_process_unhandled_input(false)
		get_node(PC_ATTACK).attack(_new_GroupName.ENEMY, x, y)
		return

	set_process_unhandled_input(false)
	_ref_DungeonBoard.move_sprite(_pc, x, y)
	_pc.position = _new_ConvertCoord.index_to_vector(x, y)
	_ref_Schedule.end_turn()
	
	
func _is_move_input(event: InputEvent) -> bool:
	var actions = [_new_InputName.MOVE_LEFT, _new_InputName.MOVE_RIGHT, _new_InputName.MOVE_UP, _new_InputName.MOVE_DOWN]

	for action in actions:
		if event.is_action_pressed(action):
			return true
	return false


func _get_spell_input(event: InputEvent) -> String:
	var actions = [_new_InputName.SPELL_FIREBALL, _new_InputName.SPELL_HEAL]
	
	for action in actions:
		if event.is_action_pressed(action):
			return action
	return ""
	
	
func _get_new_position(event: InputEvent, source: Array) -> Array:
	var x: int = source[0]
	var y: int = source[1]

	if event.is_action_pressed(_new_InputName.MOVE_LEFT):
		x -= 1
	if event.is_action_pressed(_new_InputName.MOVE_RIGHT):
		x += 1
	if event.is_action_pressed(_new_InputName.MOVE_UP):
		y -= 1
	if event.is_action_pressed(_new_InputName.MOVE_DOWN):
		y += 1

	return [x, y]


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		set_process_unhandled_input(true)

	
func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite
		set_process_unhandled_input(true)

