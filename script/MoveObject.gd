extends Node2D

signal move_sprite(sprite, new_x, new_y)

const DungeonBoard := preload("res://script/DungeonBoard.gd")

var _ref_DungeonBoard: DungeonBoard


func move(sprite: Sprite, new_x: int, new_y: int) -> void:
	emit_signal("move_sprite", sprite, new_x, new_y)
