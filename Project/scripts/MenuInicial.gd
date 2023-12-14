extends Control

func _on_iniciar_pressed():
	get_tree().change_scene_to_file("res://cenas/SelecaodeNivel.tscn")


func _on_sair_pressed():
	get_tree().quit()

func _on_free_play_pressed():
	Singletons.free_play = 1
	get_tree().change_scene_to_file("res://cenas/game.tscn")


func _on_creditos_pressed():
	get_tree().change_scene_to_file("res://cenas/Creditos.tscn")
