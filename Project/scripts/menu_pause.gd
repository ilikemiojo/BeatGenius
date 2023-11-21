extends Control

signal continuar()

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://cenas/MenuInicial.tscn")

func _on_continuar_pressed():
	emit_signal('continuar')
