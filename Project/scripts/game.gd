extends Node2D

var free_play = 0
var score = 0
var comboMultiplier = 1
var bumboHit = false
var caixaHit = false
var beat_atual = 0
var posicaoBumbo = 0
var posicaoCaixa = 0
var savedPosicaoBumbo = 0
var savedPosicaoCaixa = 0
var fase_atual = 0
var sectionNotes = 0
var sectionNotesHit = 0

var totalHits = 0
var totalNotes = 0
var savedScore = 0

func _ready():
	free_play = Singletons.free_play
	if(free_play == 1):
		$Conductor.pauseTimer()
		$HUD.hide()
	else:
		totalNotes = $Conductor.bumboTimings.size() + $Conductor.caixaTimings.size();
	$Nota.hide()
	$HUD.update_score(score)
	$HUD.update_combo(comboMultiplier)
	$MenuFeedback.scale = Vector2(0,0)

func _on_bumbo_pressed():
	$Buttons/bumboSound.play()
	if(bumboHit):
		sectionNotesHit += 1
		update_score(10)
	else:
		if(score > 0):
			update_score(-5)
		if (comboMultiplier > 1):
			comboMultiplier = 1
			$HUD.update_combo(comboMultiplier)
	
func _on_caixa_pressed():
	$Buttons/caixaSound.play()
	if(caixaHit):
		sectionNotesHit += 1
		update_score(10)
	else:
		if(score > 0):
			update_score(-5)
		if (comboMultiplier > 1):
			comboMultiplier = 1
			$HUD.update_combo(comboMultiplier)
	
func _input(event): #Tocar com as Setas do Teclado
	if event is InputEventKey:
		if event.pressed and (event.keycode == KEY_LEFT or event.keycode == KEY_S):
			_on_caixa_pressed() # (<-) = Caixa
		if event.pressed and (event.keycode == KEY_RIGHT or event.keycode == KEY_K):
			_on_bumbo_pressed() # (->) = Bumbo

func test_nota():
	bumboHit = false
	caixaHit = false
	if(posicaoBumbo < $Conductor.bumboTimings.size()):
		if(beat_atual == $Conductor.bumboTimings[posicaoBumbo]):
			$Buttons/Bumbo/AnimationPlayer.play("kick_note")
			bumboHit = true
			sectionNotes += 1
			posicaoBumbo += 1
			#prints(sectionNotes)
			
	if(posicaoCaixa < $Conductor.caixaTimings.size()):
		if(beat_atual == $Conductor.caixaTimings[posicaoCaixa]):
			$Buttons/Caixa/AnimationPlayer.play("snare_note")
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
	$MenuFeedback/Background/VBoxContainer/Minimo.show()
	$MenuFeedback/Background/VBoxContainer/VBoxContainer/Retry.show()
	$MenuFeedback/Background/VBoxContainer/Feedback.text = 'Você perdeu!'
	$MenuFeedback/Background/VBoxContainer/Pontuacao.text = 'Pontuação: ' + str(score)
	$MenuFeedback/Background/VBoxContainer/Acertos.text = str(sectionNotesHit)+'/'+str(sectionNotes)+' acertos ('+str(div)+'%)'
	$MenuFeedback/Background/VBoxContainer/Minimo.text = 'Mínimo '+str(sectionNotes/2)+' acertos'
	$HUD.hide()
	$MenuFeedback.scale = Vector2(1,1)
	$Conductor.failSound()
	$Conductor.pauseTimer()

func abrir_menu_vitoria():
	if (score == 580):
		$Conductor.songCompletePerfectSound()
	else:
		$Conductor.songCompleteSound()
	var div = round((float(totalHits)/totalNotes)*100)
	$MenuFeedback/Background/VBoxContainer/Feedback.text = 'Você venceu!'
	$MenuFeedback/Background/VBoxContainer/Pontuacao.text = 'Pontuação: ' + str(score)
	$MenuFeedback/Background/VBoxContainer/Acertos.text = str(totalHits)+'/'+str(totalNotes)+' acertos ('+str(div)+'%)'
	$MenuFeedback/Background/VBoxContainer/Minimo.hide()
	$MenuFeedback/Background/VBoxContainer/VBoxContainer/Retry.hide()
	$HUD.hide()
	$MenuFeedback.scale = Vector2(1,1)
		
	if (score > Singletons.highscore[Singletons.level - 1]):
		Singletons.highscore[Singletons.level - 1] = score
	$Conductor.pauseTimer()

func restart_fase_selecionada(fase):
	posicaoBumbo = savedPosicaoBumbo
	posicaoCaixa = savedPosicaoCaixa
	score = savedScore
	sectionNotes = 0
	sectionNotesHit = 0
	comboMultiplier = 1
	$HUD.update_combo(comboMultiplier)
	$HUD.show()
	$HUD.update_score(score)
	$Conductor.restart(fase_atual, $Conductor.sectionsStartTime[fase], $Conductor.sectionsRestartBeat[fase])
	
	
func _on_menu_feedback_retry():
	restart_fase_selecionada(fase_atual)
	$MenuFeedback.scale = Vector2(0,0)

func _on_conductor_section_finished():
	if (sectionNotesHit < (sectionNotes/2)):
		# Derrota
		abrir_menu_derrota()
	elif (sectionNotesHit == sectionNotes):
		# Perfect
		$Conductor.sectionCompletePerfectSound()
		$Conductor.nextSection();
		totalHits += sectionNotesHit
		comboMultiplier += 1
		$HUD.update_combo(comboMultiplier)
		fase_atual += 1
		savedPosicaoBumbo = posicaoBumbo
		savedPosicaoCaixa = posicaoCaixa
		savedScore = score
	else:
		# Passou
		$Conductor.sectionCompleteSound()
		$Conductor.nextSection();
		totalHits += sectionNotesHit
		fase_atual += 1
		savedPosicaoBumbo = posicaoBumbo
		savedPosicaoCaixa = posicaoCaixa
		savedScore = score
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

func _on_menu_pause_restart():
	$MenuPause.scale = Vector2(0,0)
	$Conductor.section_atual = 0
	fase_atual = 0
	savedScore = 0
	savedPosicaoBumbo = 0
	savedPosicaoCaixa = 0
	totalHits = 0
	comboMultiplier = 1
	restart_fase_selecionada(fase_atual)


func _on_menu_feedback_restart():
	$MenuFeedback.scale = Vector2(0,0)
	$Conductor.section_atual = 0
	fase_atual = 0
	savedScore = 0
	savedPosicaoBumbo = 0
	savedPosicaoCaixa = 0
	totalHits = 0
	comboMultiplier = 1
	restart_fase_selecionada(fase_atual)
