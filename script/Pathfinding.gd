extends Node2D

const DungeonBoard := preload("res://script/DungeonBoard.gd")

var _new_GroupName := preload("res://script/library/GroupName.gd").new()
var _new_DungeonSize := preload("res://script/library/DungeonSize.gd").new()

var _ref_DungeonBoard: DungeonBoard

class PosNode:
	var x:int
	var y:int
	var previous_pos: PosNode

var _already_visited: Dictionary


func find_next_step(source_x: int, source_y: int, target_x:int, target_y: int) -> Array:
	var path = _find_path(source_x,source_y,target_x,target_y)
	if path == []:
		return []
	return _find_path(source_x,source_y,target_x,target_y)[1]
	
	
func _find_path(source_x: int, source_y: int, target_x:int, target_y:int) -> Array:
	_init_dict()
	
	var source_node = PosNode.new()
	source_node.x = source_x
	source_node.y = source_y

	var frontier: Array = _get_surrounding_nodes(source_node)
	var new_frontier: Array = []
	var target_node: PosNode

	while target_node == null:
		while not frontier.empty():
			for node in _get_surrounding_nodes(frontier[0]):
				new_frontier.append(node)
			frontier.remove(0)
		
		target_node = _get_target_node(new_frontier, target_x, target_y)
		frontier = new_frontier
		if new_frontier.empty():
			#Could not find a path
			return []
		new_frontier = []

	var path = [[target_node.x, target_node.y]]				
	while not (path[0][0] == source_x and path[0][1] == source_y):
		target_node = target_node.previous_pos
		path.insert(0, [target_node.x, target_node.y])
	
	return path


func _get_surrounding_nodes(node: PosNode) -> Array:
	var surrounding_nodes = [[node.x-1, node.y], [node.x, node.y-1], [node.x+1, node.y], [node.x, node.y+1]]
	surrounding_nodes.shuffle()
	var result: Array = []

	var passable_objects: Array = [_new_GroupName.GROUND]
	var impassable_objects: Array = [_new_GroupName.WALL, _new_GroupName.ENEMY]

	for surrounding_node in surrounding_nodes:
		var all_sprites_at_node = _ref_DungeonBoard.get_all_sprites_at_pos(surrounding_node[0],surrounding_node[1])
		
		if not _any_sprite_is_in_group(all_sprites_at_node, passable_objects):
			continue
		if _any_sprite_is_in_group(all_sprites_at_node, impassable_objects):
			continue
		if _already_visited[surrounding_node[0]][surrounding_node[1]] == true:
			continue

		var new_node = PosNode.new()
		new_node.x = surrounding_node[0]
		new_node.y = surrounding_node[1]
		new_node.previous_pos = node
		result.append(new_node)

		_already_visited[new_node.x][new_node.y] = true

	return result


func _any_sprite_is_in_group(sprites: Array, groups: Array) -> bool:
	for s in sprites:
		for g in groups:
			if s.is_in_group(g):
				return true
	return false
				

func _get_target_node(frontier: Array, target_x: int, target_y: int) -> PosNode:
	for f in frontier:
		if f.x == target_x and f.y == target_y:
			return f
	return null

	
func _init_dict() -> void:
	for x in range(0, _new_DungeonSize.MAX_X):
		_already_visited[x] = []
		_already_visited[x].resize(_new_DungeonSize.MAX_Y)
