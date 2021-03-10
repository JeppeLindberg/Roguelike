extends Node2D

var _new_GroupName := preload("res://script/library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://script/library/ConvertCoord.gd").new()
var _new_DungeonSize := preload("res://script/library/DungeonSize.gd").new()

const Cursor := preload("res://sprite/Cursor.tscn")

var _process_input: bool = false
var _cursor: Sprite

signal mouse_click(x, y)


func _ready():
	_cursor = Cursor.instance() as Sprite
	_cursor.position = _new_ConvertCoord.index_to_vector(-10, -10)
	_cursor.add_to_group(_new_GroupName.CURSOR)

	add_child(_cursor)


func set_active(active: bool):
	if not active:
		_cursor.position = _new_ConvertCoord.index_to_vector(-10,-10)
	
	_process_input = active


func _input(event):
	if not _process_input:
		return

	if not ((event is InputEventMouseButton) or (event is InputEventMouseMotion)):
		return

	var eventpos = event.position
	eventpos.x += _new_ConvertCoord.STEP_X/2 as float
	eventpos.y += _new_ConvertCoord.STEP_Y/2 as float
	var pos = _new_ConvertCoord.vector_to_array(eventpos)
	var x = pos[0]
	var y = pos[1]

	if not ((0 <= x) and (x < _new_DungeonSize.MAX_X) and \
		(0 <= y) and (y < _new_DungeonSize.MAX_Y)):
		_cursor.position = _new_ConvertCoord.index_to_vector(-10,-10)
		return

	if event is InputEventMouseMotion:
		_cursor.position = _new_ConvertCoord.index_to_vector(x,y)
	elif event is InputEventMouseButton:
		emit_signal("mouse_click", x, y)
