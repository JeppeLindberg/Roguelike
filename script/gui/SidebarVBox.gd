extends VBoxContainer

var _new_GroupName := preload("res://script/library/GroupName.gd").new()

var _turn_text: String = "Turn {0}"
var _health_text: String = "Health {0}/10"

var _turn_counter: int = 0
var _pc_health: int = 0

onready var _label_help: Label = get_node("Help")
onready var _label_sidebar: Label = get_node("Sidebar")


func _ready() -> void:
	_label_help.text = ""
	_update_text()


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		_turn_counter += 1
		_update_text()


func _on_EnemyAttack_update_pc_health(new_health: int) -> void:
	_pc_health = new_health
	_update_text()


func _update_text() -> void:
	_label_sidebar.text = \
		_turn_text.format([_turn_counter]) + '\n' + \
		_health_text.format([_pc_health]) + '\n' + \
		'\n' + \
		"(1) Fireball" + '\n' + \
		"(2) Ritual (Fire)"


