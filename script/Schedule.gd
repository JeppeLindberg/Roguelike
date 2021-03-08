extends Node2D

var _new_GroupName := preload("res://script/library/GroupName.gd").new()

var _actors: Array = [null]
var _pointer: int = 0

var _continue_game: bool = true

signal turn_started(current_sprite)
signal turn_ended(current_sprite)


func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_actors[0] = new_sprite
	elif new_sprite.is_in_group(_new_GroupName.ENEMY):
		_actors.append(new_sprite)


func end_turn() -> void:
	emit_signal("turn_ended", _get_current())
	if not _continue_game:
		return
	_goto_next()
	emit_signal("turn_started", _get_current())


func _get_current() -> Sprite:
	return _actors[_pointer] as Sprite


func _goto_next() -> void:
	_pointer += 1

	if _pointer > len(_actors) - 1:
		_pointer = 0


func _on_RemoveObject_sprite_removed(remove_sprite: Sprite, _group_name: String, _x: int, _y: int) -> void:
	if remove_sprite.is_in_group(_new_GroupName.PC):
		_continue_game = false

	var current_sprite: Sprite = _get_current()

	_actors.erase(remove_sprite)
	_pointer = _actors.find(current_sprite)
