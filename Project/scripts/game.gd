extends Node2D

var free_play = 0
var score = 0
var comboMultiplier = 1
var bumboHit = false
var caixaHit = false
var beat_atual = 0
var posicaoBumbo = 0
var posicaoCaixa = 0
var fase_atual = 1
var sectionNotes = 0
var sectionNotesHit = 0

@export var baiao_01_bumbo = [48,51,56,59,64,112,115,120,123,128,176,179,183,184,187,190,192]
@export var baiao_01_caixa = [54,62,114,118,122,126,178,182,186,189]

var totalHits = 0
var totalNotes = baiao_01_bumbo.size() + baiao_01_caixa.size();

func _ready():
	free_play = Singletons.free_play
	if(free_play == 1):
		$Conductor.pauseTimer()
		$HUD.hide()
	$Nota.hide()
	$HUD.update_score(score)
	$MenuFeedback.scale = Vector2(0,0)

func _on_bumbo_pressed():
	$Buttons/bumboSound.play()
	if(bumboHit):
		sectionNotesHit += 1
		totalHits += 1
		update_score(10)
	else:
		if(score > 0):
			update_score(-5)
		if (comboMultiplier > 1):
			comboMultiplier = 1
	
func _on_caixa_pressed():
	$Buttons/caixaSound.play()
	if(caixaHit):
		sectionNotesHit += 1
		totalHits += 1
		update_score(10)
	else:
		if(score > 0):
			update_score(-5)
		if (comboMultiplier > 1):
			comboMultiplier = 1
	
func _input(event): #Tocar com as Setas do Teclado
	if event is InputEventKey:
		if event.pressed and (event.keycode == KEY_LEFT or event.keycode == KEY_S):
			_on_caixa_pressed() # (<-) = Caixa
		if event.pressed and (event.keycode == KEY_RIGHT or event.keycode == KEY_K):
			_on_bumbo_pressed() # (->) = Bumbo

func test_nota():
	bumboHit = false
	caixaHit = false
	$Nota.hide()
	if(posicaoBumbo < baiao_01_bumbo.size()):
		if(beat_atual == baiao_01_bumbo[posicaoBumbo]):
			$Nota.show()
			bumboHit = true
			sectionNotes += 1
			posicaoBumbo += 1
			#prints(sectionNotes)
			
	if(posicaoCaixa < baiao_01_caixa.size()):
		if(beat_atual == baiao_01_caixa[posicaoCaixa]):
			$Nota.show()
			caixaHit = true
			sectionNotes += 1
			posicaoCaixa += 1
			#prints(sectionNotes)

func _on_conductor_beat(beat):
	beat_atual = beat
	test_nota()

func update_score(hitPoints):
	score += hitPoints * comboMultiplier
	$HUD.update_score(score)

func abrir_menu_derrota():
	var div = round((float(sectionNotesHit)/sectionNotes)*100)
	totalHits -= sectionNotesHit
	$MenuFeedback/Background/VBoxContainer/Feedback.text = 'Você perdeu!'
	$MenuFeedback/Background/VBoxContainer/Pontuacao.text = 'Pontuação: ' + str(score)
	$MenuFeedback/Background/VBoxContainer/Acertos.text = str(sectionNotesHit)+'/'+str(sectionNotes)+' acertos ('+str(div)+'%)'
	$MenuFeedback/Background/VBoxContainer/Minimo.text = 'Mínimo '+str(sectionNotes/2)+' acertos'
	$HUD.hide()
	$MenuFeedback.scale = Vector2(1,1)
	$Conductor.failSound()
	$Conductor.pauseTimer()

func abrir_menu_vitoria():
	var div = round((float(totalHits)/totalNotes)*100)
	$MenuFeedback/Background/VBoxContainer/Feedback.text = 'Você venceu!'
	$MenuFeedback/Background/VBoxContainer/Pontuacao.text = 'Pontuação: ' + str(score)
	$MenuFeedback/Background/VBoxContainer/Acertos.text = str(totalHits)+'/'+str(totalNotes)+' acertos ('+str(div)+'%)'
	$MenuFeedback/Background/VBoxContainer/Minimo.hide()
	$MenuFeedback/Background/VBoxContainer/VBoxContainer/Retry.hide()
	$HUD.hide()
	$MenuFeedback.scale = Vector2(1,1)
	if (score == 580):
		$Conductor.songCompletePerfectSound()
	else:
		$Conductor.songCompleteSound()
	if (score > Singletons.highscore):
		Singletons.highscore = score
	$Conductor.pauseTimer()

func restart_fase_selecionada(faseScore, faseTempo, faseBeat, posBumbo, posCaixa):
	posicaoBumbo = posBumbo
	posicaoCaixa = posCaixa
	score = faseScore
	$HUD.show()
	$HUD.update_score(score)
	$Conductor.restart(faseTempo, faseBeat)
	
func _on_menu_feedback_retry():
	match fase_atual:
		1: restart_fase_selecionada(0, 0, 0, 0, 0)
		2: restart_fase_selecionada(35, 11.34, 68, 5, 2)
		3: restart_fase_selecionada(80, 22.02, 132, 10, 6)
	$MenuFeedback.scale = Vector2(0,0)

func _on_conductor_section_finished():
	if (sectionNotesHit < (sectionNotes/2)):
		# Derrota
		abrir_menu_derrota()
	elif (sectionNotesHit == sectionNotes):
		# Perfect
		$Conductor.sectionCompletePerfectSound()
		$Conductor.nextSection();
		comboMultiplier += 1
		fase_atual += 1
	else:
		# Passou
		$Conductor.sectionCompleteSound()
		$Conductor.nextSection();
		fase_atual += 1
	sectionNotes = 0
	sectionNotesHit = 0

func _on_conductor_song_finished():
	if (sectionNotesHit < (sectionNotes/2)):
		abrir_menu_derrota()
	else:
		abrir_menu_vitoria()

func _on_pause_pressed():
	$HUD.hide()
	$MenuPause.scale = Vector2(1,1)
	$Conductor.pauseTimer()

func _on_menu_pause_continuar():
	$MenuPause.scale = Vector2(0,0)
	if(free_play == 0):
		_on_menu_feedback_retry()
