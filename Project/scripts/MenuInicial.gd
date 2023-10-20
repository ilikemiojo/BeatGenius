extends Control




func _on_iniciar_pressed():
	get_tree().change_scene_to_file("res://cenas/node_2d.tscn")


func _on_sair_pressed():
	get_tree().quit()
