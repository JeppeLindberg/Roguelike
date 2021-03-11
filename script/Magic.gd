extends Node2D

var _new_ConvertCoord := preload("res://script/library/ConvertCoord.gd").new()
var _new_GroupName := preload("res://script/library/GroupName.gd").new()

const DungeonBoard := preload("res://script/DungeonBoard.gd")
const InitWorld := preload("res://script/InitWorld.gd")

var _ref_DungeonBoard: DungeonBoard
var _ref_InitWorld: InitWorld

const Fire := preload("res://sprite/Fire.tscn")

var _mana: Array


func create_mana(type_group: String, x, y) -> void:
	var target_pos = _find_available_pos(x, y)

	if target_pos == []:
		return
	
	var new_sprite: Sprite 

	if type_group == _new_GroupName.MANA_FIRE:
		new_sprite = _ref_InitWorld.create_sprite(Fire, _new_GroupName.MANA, target_pos[0], target_pos[1], _new_GroupName.MANA_FIRE)

	if new_sprite != null:
		_mana.append(new_sprite)
	

func _find_available_pos(x, y) -> Array:
	var obstructions = [_new_GroupName.PC, _new_GroupName.MANA, _new_GroupName.WALL]
	var pos = [[x-1, y-1],[x, y-1], [x+1, y-1], [x-1, y], [x, y], [x+1, y], [x-1, y+1], [x, y+1], [x+1, y+1]]
	pos.shuffle()

	for p in pos:
		if not _ref_DungeonBoard.is_inside_dungeon(p[0], p[1]):
			continue

		if not _any_sprite_is_in_group(_ref_DungeonBoard.get_all_sprites_at_pos(p[0], p[1]), obstructions):
			return p
	return []


func _any_sprite_is_in_group(sprites: Array, groups: Array) -> bool:
	for s in sprites:
		for g in groups:
			if s.is_in_group(g):
				return true
	return false

	
func get_nearby_mana(type_group: String, x: int, y: int, radius: int) -> Sprite:
	for m in _mana:
		var pos = _new_ConvertCoord.vector_to_array(m.position)
		var mana_x = pos[0]
		var mana_y = pos[1]

		if (abs(mana_x - x) + abs(mana_y - y)) <= radius:
			if _any_sprite_is_in_group([m],[type_group]):
				return m
	return null


func is_mana_nearby(type_group: String, x: int, y: int, radius: int) -> bool:
	return get_nearby_mana(type_group, x, y, radius) != null	


func _on_RemoveObject_sprite_removed(remove_sprite: Sprite, _group_name: String, _x: int, _y: int) -> void:
	_mana.erase(remove_sprite)

