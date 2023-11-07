extends Node2D

var score = 0
@export var hitPoints = 10
var comboMultiplier = 1
var bumboHit = false
var caixaHit = false
var beat_atual = 0
var posicaoBumbo = 0
var posicaoCaixa = 0

@export var baiao_01_bumbo = [12.0, 12.75, 14.0, 14.75, 16.0, 28.0, 28.75, 30.0, 30.75, 32.0, 44.0, 44.75, 45.75, 46.0, 46.75, 47.5, 48.0]
@export var baiao_01_caixa = [13.5, 15.5, 28.5, 29.5, 30.5, 31.5, 44.5, 45.5, 46.5, 47.25]
#@export var baiao_02_bumbo = [29.0, 29.75, 31.0, 31.75, 33.0]
#@export var baiao_02_caixa = [29.5, 30.5, 31.5, 32.5]
#@export var baiao_03_bumbo = [44.0, 44.75, 45.75, 46.0, 46.75, 47.5, 48.0]
#@export var baiao_03_caixa = [44.5, 45.5, 46.5, 47.25]

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
	print(beat)
	print(posicaoBumbo)
	print(posicaoCaixa)

func update_score():
	score += hitPoints * comboMultiplier
	$HUD.update_score(score)

func _on_conductor_baiao_01_finished():
	if(score < 70):
		print('você falhou')
		posicaoBumbo = 0
		posicaoCaixa = 0
		score = 0
		$HUD.update_score(0)
		$Conductor.restart(0.0, 0)
	else:
		print('você passou da primeira fase')
		


func _on_conductor_baiao_02_finished():
	if(score < 160):
		print('você falhou')
		posicaoBumbo = 5
		posicaoCaixa = 2
		score = 70
		$HUD.update_score(70)
		$Conductor.restart(11.34, 17)
	else:
		print('você passou da segunda fase')


func _on_conductor_baiao_03_finished():
	if(score < 290):
		print('você falhou')
		posicaoBumbo = 10
		posicaoCaixa = 6
		score = 180
		$HUD.update_score(180)
		$Conductor.restart(22.02, 33)
	else:
		print('você passou da terceira fase')
