extends Node2D

var score = 0
@export var hitPoints = 10
var comboMultiplier = 1
var hit = false
var bumboHit = false
var caixaHit = false
var beat_atual = 0
var posicaoBumbo = 0
var posicaoCaixa = 0
@export var baiao_01_bumbo = []
@export var baiao_01_caixa = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Nota.set_process_mode(PROCESS_MODE_DISABLED)
	$Nota.visible = false
	$HUD.update_score(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func nota_process_mode(status, tipo):
	if(tipo == 'bumbo'):
		if(status):
			$Nota.set_process_mode(PROCESS_MODE_INHERIT)
			$Nota.visible = true
			bumboHit = true
		else:
			$Nota.set_process_mode(PROCESS_MODE_DISABLED)
			$Nota.visible = false
			bumboHit = false
	if(tipo == 'caixa'):
		if(status):
			$Nota.set_process_mode(PROCESS_MODE_INHERIT)
			$Nota.visible = true
			caixaHit = true
		else:
			$Nota.set_process_mode(PROCESS_MODE_DISABLED)
			$Nota.visible = false
			caixaHit = false

func _process(delta):
	if(posicaoBumbo < baiao_01_bumbo.size()):
		if(beat_atual == baiao_01_bumbo[posicaoBumbo]):
			if(!bumboHit):
				nota_process_mode(true, 'bumbo')
				print('nota')
		elif(bumboHit):
			nota_process_mode(false, 'bumbo')
			posicaoBumbo += 1
	if(posicaoCaixa < baiao_01_caixa.size()):
		if(beat_atual == baiao_01_caixa[posicaoCaixa]):
			if(!caixaHit):
				nota_process_mode(true, 'caixa')
				print('nota')
		elif(caixaHit):
			nota_process_mode(false, 'caixa')
			posicaoCaixa += 1

func _on_bumbo_pressed():
	$Buttons/bumboSound.play()
	if(bumboHit):
		update_score()
		print('acertou')
	else:
		print('errou')
	
func _on_caixa_pressed():
	$Buttons/caixaSound.play()
	if(caixaHit):
		update_score()
		print('acertou')
	else:
		print('errou')
	
func _input(event): #Tocar com as Setas do Teclado
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_LEFT:
			_on_caixa_pressed() # (<-) = Caixa
		if event.pressed and event.keycode == KEY_RIGHT:
			_on_bumbo_pressed() # (->) = Bumbo


func _on_conductor_beat(beat):
	beat_atual = beat

func update_score():
	score += hitPoints * comboMultiplier
	$HUD.update_score(score)
