extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_nivel_01_pressed():
	Singletons.free_play = 0
	get_tree().change_scene_to_file("res://cenas/game.tscn")


func _on_nivel_02_pressed():
	pass # Replace with function body.


func _on_nivel_03_pressed():
	pass # Replace with function body.


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://cenas/MenuInicial.tscn")
