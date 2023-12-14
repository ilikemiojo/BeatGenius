extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Background/VBoxContainer/VBoxContainer/HBoxContainer/Nivel01_perfect.hide()
	
	$Background/VBoxContainer/VBoxContainer/HBoxContainer/Nivel01_info.text = '   Recorde: ' + str(Singletons.highscore[0])
	if(Singletons.highscore[0] == Singletons.maxscore[0]):
		$Background/VBoxContainer/VBoxContainer/HBoxContainer/Nivel01_perfect.show()



func _on_nivel_01_pressed():
	Singletons.level = 1
	Singletons.free_play = 0
	get_tree().change_scene_to_file("res://cenas/game.tscn")


func _on_nivel_02_pressed():
	pass # Replace with function body.


func _on_nivel_03_pressed():
	pass # Replace with function body.


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://cenas/MenuInicial.tscn")
