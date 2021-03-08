extends Node2D

const Player := preload("res://sprite/PC.tscn")
const Dwarf := preload("res://sprite/Dwarf.tscn")
const Floor := preload("res://sprite/Floor.tscn")
const Wall := preload("res://sprite/Wall.tscn")

var _new_GroupName := preload("res://script/library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://script/library/ConvertCoord.gd").new()
var _new_DungeonSize := preload("res://script/library/DungeonSize.gd").new()
var _new_InputName := preload("res://script/library/InputName.gd").new()

const DungeonBoard := preload("res://script/DungeonBoard.gd")

var _ref_DungeonBoard: DungeonBoard

signal sprite_created(new_sprite)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(_new_InputName.INIT_WORLD):
		_init_world()
		_init_PC()
		_init_enemies()
		
		set_process_unhandled_input(false)
		

func _init_world() -> void:
	for x in range(0, _new_DungeonSize.MAX_X):
		for y in range(0, _new_DungeonSize.MAX_Y):
			if (abs(x - _new_DungeonSize.CENTER_X) <= 2) && (abs(y - _new_DungeonSize.CENTER_Y) <= 2):
				_create_sprite(Wall, _new_GroupName.WALL, x, y)
			else:
				_create_sprite(Floor, _new_GroupName.GROUND, x, y)


func _init_PC() -> void:
	_create_sprite(Player, _new_GroupName.PC, 0, 0);


func _init_enemies() -> void:
	var ground_nodes := get_tree().get_nodes_in_group(_new_GroupName.GROUND)
	var enemy := (randi() % 3) + 3
	var i = 0

	ground_nodes.shuffle()
	
	while enemy > 0:
		var pos = _new_ConvertCoord.vector_to_array(ground_nodes[i].position)
		var x = pos[0]
		var y = pos[1]

		if _ref_DungeonBoard.has_sprite(_new_GroupName.ENEMY, x, y) \
				or (x == 0 and y == 0):
			i += 1
			continue

		_create_sprite(Dwarf, _new_GroupName.ENEMY, x, y)
		i += 1
		enemy -= 1


func _create_sprite(prefab: PackedScene, group: String, x: int, y: int, x_offset: int = 0, y_offset: int = 0) -> void:
	var new_sprite := prefab.instance() as Sprite
	new_sprite.position = _new_ConvertCoord.index_to_vector(x, y, x_offset, y_offset)
	new_sprite.add_to_group(group)

	add_child(new_sprite)

	emit_signal("sprite_created", new_sprite)

