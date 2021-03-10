extends Label

var _new_GroupName := preload("res://script/library/GroupName.gd").new()

var _game_started = "Game started"


func _ready() -> void:
	text = "Press R to start game."


func _on_Schedule_turn_ended(_current_sprite: Sprite) -> void:
	pass


func _on_EnemyAI_enemy_message(message: String) -> void:
	text = message


func _on_PCMove_pc_moved(message: String) -> void:
	text = message

	
func _on_PCAttack_pc_attacked(message: String) -> void:
	text = message


func _on_Spell_emit_message(message: String) -> void:
	text = message


func _on_PCMove_clear_message() -> void:
	text = ""

	
func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		text = _game_started