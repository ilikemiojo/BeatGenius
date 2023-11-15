extends Node2D

var score = 0
#@export var hitPoints = 10
var comboMultiplier = 1
var bumboHit = false
var caixaHit = false
var beat_atual = 0
var posicaoBumbo = 0
var posicaoCaixa = 0
var score_minimo = 0
var fase_atual = 1

@export var baiao_01_bumbo = [12.0, 12.75, 14.0, 14.75, 16.0, 28.0, 28.75, 30.0, 30.75, 32.0, 44.0, 44.75, 45.75, 46.0, 46.75, 47.5, 48.0]
@export var baiao_01_caixa = [13.5, 15.5, 28.5, 29.5, 30.5, 31.5, 44.5, 45.5, 46.5, 47.25]

func _ready():
	$Nota.hide()
	$HUD.update_score(score)
	$MenuFeedback.scale = Vector2(0,0)
	
func test_nota():
	bumboHit = false
	caixaHit = false
	$Nota.hide()
	if(posicaoBumbo < baiao_01_bumbo.size()):
		if(beat_atual == baiao_01_bumbo[posicaoBumbo]):
			$Nota.show()
			bumboHit = true
			posicaoBumbo += 1
			
	if(posicaoCaixa < baiao_01_caixa.size()):
		if(beat_atual == baiao_01_caixa[posicaoCaixa]):
			$Nota.show()
			caixaHit = true
			posicaoCaixa += 1

func _on_bumbo_pressed():
	$Buttons/bumboSound.play()
	if(bumboHit):
		update_score(10)
		print('acertou')
	else:
		print('errou')
		if(score > score_minimo):
			update_score(-10)
	
func _on_caixa_pressed():
	$Buttons/caixaSound.play()
	if(caixaHit):
		update_score(10)
		print('acertou')
	else:
		print('errou')
		if(score > score_minimo):
			update_score(-10)
		
	
func _input(event): #Tocar com as Setas do Teclado
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_LEFT:
			_on_caixa_pressed() # (<-) = Caixa
		if event.pressed and event.keycode == KEY_RIGHT:
			_on_bumbo_pressed() # (->) = Bumbo

func _on_conductor_beat(beat):
	beat_atual = beat
	test_nota()
#	print(beat)
#	print(posicaoBumbo)
#	print(posicaoCaixa)

func update_score(hitPoints):
	score += hitPoints * comboMultiplier
	$HUD.update_score(score)

func _on_conductor_baiao_01_finished():
	if(score < 70):
		abrir_menu_derrota()
	else:
		score_minimo = 70
		fase_atual = 2

func _on_conductor_baiao_02_finished():
	if(score < 160):
		abrir_menu_derrota()
	else:
		score_minimo = 160
		fase_atual = 3

func _on_conductor_baiao_03_finished():
	if(score < 270):
		abrir_menu_derrota()
	else:
		score_minimo = 270
		abrir_menu_vitoria()

func abrir_menu_derrota():
	$MenuFeedback/TextureRect/VBoxContainer/Feedback.text = 'Você Perdeu!'
	$MenuFeedback/TextureRect/VBoxContainer/Pontuacao.text = str(score)+' pts'
	$MenuFeedback.scale = Vector2(1,1)
	$Conductor.failSound()
	$Conductor.pauseTimer()

func abrir_menu_vitoria():
	$MenuFeedback/TextureRect/VBoxContainer/Feedback.text = 'Você Venceu!'
	$MenuFeedback/TextureRect/VBoxContainer/Pontuacao.text = str(score)+' pts'
	$MenuFeedback.scale = Vector2(1,1)
	#Conductor.SOM DA VITORIA!!!
	$Conductor.pauseTimer()

func restart_fase_selecionada(faseScore, faseTempo, faseBeat, posBumbo, posCaixa):
	posicaoBumbo = posBumbo
	posicaoCaixa = posCaixa
	score = faseScore
	$HUD.update_score(score)
	$Conductor.restart(faseTempo, faseBeat)
	
func _on_menu_feedback_retry():
	match fase_atual:
		1: restart_fase_selecionada(0, 0, 0, 0, 0)
		2: restart_fase_selecionada(70, 11.34, 17, 5, 2)
		3: restart_fase_selecionada(160, 22.02, 33, 10, 6)
	$MenuFeedback.scale = Vector2(0,0)

