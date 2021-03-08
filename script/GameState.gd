extends Node2D

var _new_GroupName := preload("res://script/library/GroupName.gd").new()
var _new_GameState := preload("res://script/library/GameState.gd").new()

var _pc_count: int = 0;
var _enemy_count: int = 0;

signal change_state(new_state)


func _victory() -> void:
	emit_signal("change_state", _new_GameState.VICTORY)


func _defeat() -> void:
	emit_signal("change_state", _new_GameState.DEFEAT)


func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc_count += 1
	if new_sprite.is_in_group(_new_GroupName.ENEMY):
		_enemy_count += 1


func _on_RemoveObject_sprite_removed(sprite: Sprite, _group_name: String, _x:int, _y:int) -> void:
	if sprite.is_in_group(_new_GroupName.PC):
		_pc_count -= 1
	if sprite.is_in_group(_new_GroupName.ENEMY):
		_enemy_count -= 1
	
	if _enemy_count == 0:
		_victory()
	elif _pc_count == 0:
		_defeat()
