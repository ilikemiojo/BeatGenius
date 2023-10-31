extends Node2D

var hit = false
var song_position = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Nota.set_process_mode(PROCESS_MODE_DISABLED)
	$Nota.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func nota_process_mode(status):
	if(status):
		$Nota.set_process_mode(PROCESS_MODE_INHERIT)
		$Nota.visible = true
		hit = true
	else:
		$Nota.set_process_mode(PROCESS_MODE_DISABLED)
		$Nota.visible = false
		hit = false

func _physics_process(delta):
	song_position = $Conductor/Baiao_01.get_playback_position();
	if(song_position >= 2.55 and song_position <= 2.75):
		nota_process_mode(true)
	else: 
		nota_process_mode(false)

func _on_colisor_area_entered(area):
	hit = true
	print("entrou")

func _on_colisor_area_exited(area):
	hit = false
	print("saiu")

func _on_bumbo_pressed():
	$Buttons/bumboSound.play()
	if(hit):
		print('acertou')
	else:
		print('errou')
	
func _on_caixa_pressed():
	$Buttons/caixaSound.play()
	
func _input(event): #Tocar com as Setas do Teclado
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_LEFT:
			_on_caixa_pressed() # (<-) = Caixa
		if event.pressed and event.keycode == KEY_RIGHT:
			_on_bumbo_pressed() # (->) = Bumbo
