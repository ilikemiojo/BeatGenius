extends Node2D

func _on_bumbo_pressed():
	$bumboSound.play()
	
func _input(event): #Tocar com as Setas do Teclado
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_LEFT:
			$caixaSound.play() # (<-) = Caixa
		if event.pressed and event.keycode == KEY_RIGHT:
			$bumboSound.play() # (->) = Bumbo

func _on_caixa_pressed():
	$caixaSound.play()
