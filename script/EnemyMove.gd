extends Node2D

var _new_GroupName := preload("res://script/library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://script/library/ConvertCoord.gd").new()

const DungeonBoard := preload("res://script/DungeonBoard.gd")

var _ref_DungeonBoard: DungeonBoard

func try_move(current_sprite: Sprite,x: int, y: int) -> void:
	if not _ref_DungeonBoard.is_inside_dungeon(x, y):
		return 
	if _ref_DungeonBoard.has_sprite(_new_GroupName.WALL, x, y):
		return 
	if _ref_DungeonBoard.has_sprite(_new_GroupName.ENEMY, x, y):
		return 

	_ref_DungeonBoard.move_sprite(current_sprite, x, y)
	current_sprite.position = _new_ConvertCoord.index_to_vector(x, y)
	return 

