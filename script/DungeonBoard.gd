extends Node2D

var _new_DungeonSize := preload("res://script/library/DungeonSize.gd").new()
var _new_GroupName := preload("res://script/library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://script/library/ConvertCoord.gd").new()

var _sprite_dict: Dictionary

var groups = [_new_GroupName.ENEMY, _new_GroupName.WALL, _new_GroupName.GROUND,_new_GroupName.PC, _new_GroupName.MANA]

func _ready() -> void:
	_init_dict()


func has_sprite(group_name: String, x: int, y: int) -> bool:
	return get_sprite(group_name, x, y) != null	


func get_sprite(group_name: String, x: int, y: int) -> Sprite:
	if not is_inside_dungeon(x, y):
		return null
	return _sprite_dict[group_name][x][y]
	

func get_all_sprites_at_pos(x: int, y: int) -> Array:
	var sprites: Array = []

	if not is_inside_dungeon(x, y):
		return []

	for g in groups:
		if not _sprite_dict[g][x][y] == null:
			sprites.append(_sprite_dict[g][x][y])
	return sprites
	
	
func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	var pos: Array
	var group: String
	
	if new_sprite.is_in_group(_new_GroupName.ENEMY):
		group = _new_GroupName.ENEMY
	elif new_sprite.is_in_group(_new_GroupName.WALL):
		group = _new_GroupName.WALL
	elif new_sprite.is_in_group(_new_GroupName.GROUND):
		group = _new_GroupName.GROUND
	elif new_sprite.is_in_group(_new_GroupName.PC):
		group = _new_GroupName.PC
	elif new_sprite.is_in_group(_new_GroupName.MANA):
		group = _new_GroupName.MANA
	else:
		return

	pos = _new_ConvertCoord.vector_to_array(new_sprite.position)
	_sprite_dict[group][pos[0]][pos[1]] = new_sprite


func _init_dict() -> void:
	for g in groups:
		_sprite_dict[g] = {}
		for x in range(_new_DungeonSize.MAX_X):
			_sprite_dict[g][x] = []
			_sprite_dict[g][x].resize(_new_DungeonSize.MAX_Y)


func is_inside_dungeon(x: int, y: int) -> bool:
	return (x > -1) and (x < _new_DungeonSize.MAX_X) \
		and (y > -1) and (y < _new_DungeonSize.MAX_Y)


func _on_RemoveObject_sprite_removed(_sprite: Sprite, group_name: String, x:int, y:int)	-> void:
	_sprite_dict[group_name][x][y] = null


func move_sprite(sprite: Sprite, new_x: int, new_y: int) -> void:
	var pos = _new_ConvertCoord.vector_to_array(sprite.position)
	var x = pos[0]
	var y = pos[1]
	
	for g in groups:
		if sprite.is_in_group(g):
			_sprite_dict[g][x][y] = null
			_sprite_dict[g][new_x][new_y] = sprite
