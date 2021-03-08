extends Node2D

var _new_GroupName := preload("res://script/library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://script/library/ConvertCoord.gd").new()

const RemoveObject := preload("res://script/RemoveObject.gd")

var _initialized = false;
var _pc_health : int = 10

var _ref_RemoveObject: RemoveObject

signal update_pc_health(new_health)


func _process(_delta):
	if _initialized == false:
		emit_signal("update_pc_health", _pc_health)
		_initialized = true


func attack(attacker: Sprite, defender: Sprite) -> int:
	if attacker.is_in_group(_new_GroupName.ENEMY) and defender.is_in_group(_new_GroupName.PC):
		var damage = randi() % 3 + 1
		_pc_health -= damage
		emit_signal("update_pc_health", _pc_health)
		if _pc_health <= 0:
			var pos = _new_ConvertCoord.vector_to_array(defender.position)
			var x = pos[0]
			var y = pos[1]

			_ref_RemoveObject.remove(_new_GroupName.PC, x, y)
		return damage
		
	return 0

