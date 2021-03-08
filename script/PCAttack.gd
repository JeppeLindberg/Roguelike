extends Node2D

const DungeonBoard := preload("res://script/DungeonBoard.gd")
const Schedule := preload("res://script/Schedule.gd")
const RemoveObject := preload("res://script/RemoveObject.gd")

var _ref_DungeonBoard: DungeonBoard
var _ref_Schedule: Schedule
var _ref_RemoveObject: RemoveObject

signal pc_attacked(message)


func attack(group_name: String, x: int, y:int) -> void:
	if not _ref_DungeonBoard.has_sprite(group_name, x, y):
		return
	
	_ref_RemoveObject.remove(group_name, x, y)
	_ref_Schedule.end_turn()
	_ref_Schedule.end_turn()
	emit_signal("pc_attacked", "You killed a dwarf!")
	
