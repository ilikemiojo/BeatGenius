extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Background/VBoxContainer/VBoxContainer/HBoxContainer/Nivel01_perfect.hide()
	$Background/VBoxContainer/VBoxContainer/HBoxContainer2/Nivel02_perfect.hide()
	$Background/VBoxContainer/VBoxContainer/HBoxContainer3/Nivel03_perfect.hide()
	
	$Background/VBoxContainer/VBoxContainer/HBoxContainer/Nivel01_info.text = '   Recorde: ' + str(Singletons.highscore[0])
	if(Singletons.highscore[0] == Singletons.maxscore[0]):
		$Background/VBoxContainer/VBoxContainer/HBoxContainer/Nivel01_perfect.show()
		
	$Background/VBoxContainer/VBoxContainer/HBoxContainer2/Nivel02_info.text = '   Recorde: ' + str(Singletons.highscore[1])
	if(Singletons.highscore[1] == Singletons.maxscore[1]):
		$Background/VBoxContainer/VBoxContainer/HBoxContainer2/Nivel02_perfect.show()
		
	$Background/VBoxContainer/VBoxContainer/HBoxContainer3/Nivel03_info.text = '   Recorde: ' + str(Singletons.highscore[2])
	if(Singletons.highscore[2] == Singletons.maxscore[2]):
		$Background/VBoxContainer/VBoxContainer/HBoxContainer3/Nivel03_perfect.show()

func selectLevel(level):
	Singletons.level = level
	Singletons.free_play = 0
	if (Singletons.showTutorial):
		get_tree().change_scene_to_file("res://cenas/Tutorial.tscn")
	else:
		get_tree().change_scene_to_file("res://cenas/game.tscn")

func _on_nivel_01_pressed():
	selectLevel(1)

func _on_nivel_02_pressed():
	selectLevel(2)

func _on_nivel_03_pressed():
	selectLevel(3)

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://cenas/MenuInicial.tscn")


func _on_info_button_01_pressed():
	$Informations.scale = Vector2(1,1)
	$Informations.show_baiao_info()

func _on_info_button_02_pressed():
	$Informations.scale = Vector2(1,1)
	$Informations.show_xote_info()

func _on_info_button_03_pressed():
	$Informations.scale = Vector2(1,1)
	$Informations.show_xaxado_info()
	
func _on_informations_close():
	$Informations.scale = Vector2(0,0)
