extends PanelContainer

var _new_GameState := preload("res://script/library/GameState.gd").new()

var _victory_text: String = "You win!"
var _defeat_text: String = "You were defeated!"

onready var _center_text: Label = get_node("CenterText")


func _splash_screen(text: String) -> void:
	visible = true
	_center_text.text = text


func _on_GameState_change_state(new_state: String) -> void:
	if new_state == _new_GameState.VICTORY:
		_splash_screen(_victory_text)
	elif new_state == _new_GameState.DEFEAT:
		_splash_screen(_defeat_text)