extends Node2D

const ENEMY_MOVE: String = "EnemyMove"
const ENEMY_ATTACK: String = "EnemyAttack"

const STATE_INITIAL: String = "state_initial"
const STATE_MOVE: String = "state_move"
const STATE_ATTACK: String = "state_attack"

const Schedule := preload("res://script/Schedule.gd")
const Pathfinding := preload("res://script/Pathfinding.gd")

var _ref_Schedule: Schedule
var _ref_Pathfinding: Pathfinding
var _pc: Sprite
var _states: Array

var _new_GroupName := preload("res://script/library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://script/library/ConvertCoord.gd").new()

signal enemy_message(message)

class EnemyState:
	var sprite: Sprite
	var state: String


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if not current_sprite.is_in_group(_new_GroupName.ENEMY):
		return

	var enemy_state = _get_sprite_state(current_sprite)

	if enemy_state.state == STATE_INITIAL:
		enemy_state.state = STATE_MOVE
	
	if enemy_state.state == STATE_MOVE:
		if not _pc_is_close(_pc, current_sprite):
			if randf() > 0.9:
				_ref_Schedule.end_turn()
				return

			var enemy_pos = _new_ConvertCoord.vector_to_array(current_sprite.position)
			var player_pos = _new_ConvertCoord.vector_to_array(_pc.position)
	
			var pos = _ref_Pathfinding.find_next_step(enemy_pos[0], enemy_pos[1], player_pos[0], player_pos[1]);
			if not pos == []:
				get_node(ENEMY_MOVE).try_move(current_sprite, pos[0], pos[1])

		if _pc_is_close(_pc, current_sprite):
			emit_signal("enemy_message", "The dwarf is readying for attack!")
			enemy_state.state = STATE_ATTACK

		_ref_Schedule.end_turn()
		return

	if enemy_state.state == STATE_ATTACK:
		if not _pc_is_close(_pc, current_sprite):
			enemy_state.state = STATE_MOVE
			_ref_Schedule.end_turn()
			return
			
		var damage = get_node(ENEMY_ATTACK).attack(current_sprite, _pc)
		emit_signal("enemy_message", "The dwarf attacks you for {0} damage!".format([damage]))
		_ref_Schedule.end_turn()
		return
	
	_ref_Schedule.end_turn()


func _get_sprite_state(sprite: Sprite) -> EnemyState:
	for state in _states:
		if state.sprite == sprite:
			return state
	return null


func _pc_is_close(source: Sprite, target: Sprite) -> bool:
	var source_pos: Array = _new_ConvertCoord.vector_to_array(source.position)
	var target_pos: Array = _new_ConvertCoord.vector_to_array(target.position)
	var delta_x: int = abs(source_pos[0] - target_pos[0]) as int
	var delta_y: int = abs(source_pos[1] - target_pos[1]) as int

	return delta_x + delta_y < 2


func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite
	if new_sprite.is_in_group(_new_GroupName.ENEMY):
		var new_state = EnemyState.new();
		new_state.sprite = new_sprite
		new_state.state = STATE_INITIAL
		_states.append(new_state)


func _on_RemoveObject_sprite_removed(remove_sprite: Sprite, _group_name: String, _x: int, _y: int) -> void:
	var state = _get_sprite_state(remove_sprite)
	if not state == null:
		_states.erase(state)
