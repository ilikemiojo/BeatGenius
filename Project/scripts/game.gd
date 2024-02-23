extends Node2D

var free_play = 0
var score = 0
var comboMultiplier = 1
var bumboHit = false
var caixaHit = false
var beat_atual = 0
var posicaoBumbo = 0
var posicaoCaixa = 0
var posicaoBumboDemo = 0
var posicaoCaixaDemo = 0
var savedPosicaoBumbo = 0
var savedPosicaoCaixa = 0
var savedPosicaoBumboDemo = 0
var savedPosicaoCaixaDemo = 0
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

func demo_notes():
	if(posicaoBumboDemo < $Conductor.bumboDemoTimings.size()):
		if(beat_atual == $Conductor.bumboDemoTimings[posicaoBumboDemo]):
			$Buttons/Bumbo/AnimationPlayer.play("kick_note")
			posicaoBumboDemo += 1
		
	if(posicaoCaixaDemo < $Conductor.caixaDemoTimings.size()):
		if(beat_atual == $Conductor.caixaDemoTimings[posicaoCaixaDemo]):
			$Buttons/Caixa/AnimationPlayer.play("snare_note")
			posicaoCaixaDemo += 1

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
	demo_notes()
	test_nota()

func update_score(hitPoints):
	score += hitPoints * comboMultiplier
	$HUD.update_score(score)

func abrir_menu_derrota():
	var div = round((float(sectionNotesHit)/sectionNotes)*100)
	$MenuFeedback/Background/VBoxContainer/Minimo.show()
	$MenuFeedback/Background/VBoxContainer/VBoxContainer/Retry.show()
	$MenuFeedback/Background/VBoxContainer/Feedback.text = 'You lost!'
	$MenuFeedback/Background/VBoxContainer/Pontuacao.text = 'Score: ' + str(score)
	$MenuFeedback/Background/VBoxContainer/Acertos.text = str(sectionNotesHit)+'/'+str(sectionNotes)+' notes hit ('+str(div)+'%)'
	$MenuFeedback/Background/VBoxContainer/Minimo.text = 'Minimum: '+str(sectionNotes/2)+' notes'
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
	$MenuFeedback/Background/VBoxContainer/Feedback.text = 'You won!'
	$MenuFeedback/Background/VBoxContainer/Pontuacao.text = 'Score: ' + str(score)
	$MenuFeedback/Background/VBoxContainer/Acertos.text = str(totalHits)+'/'+str(totalNotes)+' notes hit ('+str(div)+'%)'
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
	posicaoBumboDemo = savedPosicaoBumboDemo
	posicaoCaixaDemo = savedPosicaoCaixaDemo
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
		$HUD.update_section(fase_atual)
		savedPosicaoBumbo = posicaoBumbo
		savedPosicaoCaixa = posicaoCaixa
		savedPosicaoBumboDemo = posicaoBumboDemo
		savedPosicaoCaixaDemo = posicaoCaixaDemo
		savedScore = score
	else:
		# Passou
		$Conductor.sectionCompleteSound()
		$Conductor.nextSection();
		totalHits += sectionNotesHit
		fase_atual += 1
		$HUD.update_section(fase_atual)
		savedPosicaoBumbo = posicaoBumbo
		savedPosicaoCaixa = posicaoCaixa
		savedPosicaoBumboDemo = posicaoBumboDemo
		savedPosicaoCaixaDemo = posicaoCaixaDemo
		savedScore = score
	sectionNotes = 0
	sectionNotesHit = 0

func _on_conductor_song_finished():
	if (sectionNotesHit < (sectionNotes/2)):
		abrir_menu_derrota()
	else:
		abrir_menu_vitoria()

func _on_pause_pressed():
	if(Singletons.free_play == 1):
		$MenuPause/Background/VBoxContainer/VBoxContainer/Restart.hide()
	else:
		$MenuPause/Background/VBoxContainer/VBoxContainer/Restart.show()
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
	$HUD.update_section(fase_atual)
	savedScore = 0
	savedPosicaoBumbo = 0
	savedPosicaoCaixa = 0
	savedPosicaoBumboDemo = 0
	savedPosicaoCaixaDemo = 0
	totalHits = 0
	comboMultiplier = 1
	restart_fase_selecionada(fase_atual)


func _on_menu_feedback_restart():
	$MenuFeedback.scale = Vector2(0,0)
	$Conductor.section_atual = 0
	fase_atual = 0
	$HUD.update_section(fase_atual)
	savedScore = 0
	savedPosicaoBumbo = 0
	savedPosicaoCaixa = 0
	savedPosicaoBumboDemo = 0
	savedPosicaoCaixaDemo = 0
	totalHits = 0
	comboMultiplier = 1
	restart_fase_selecionada(fase_atual)
