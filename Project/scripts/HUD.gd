extends CanvasLayer

func update_score(score):
	$ScoreLabel.text = str(score)

func update_combo(multiplier):
	$ComboLabel.text = 'Combo: ' + str(multiplier)
	if (multiplier == 1):
		$ComboLabel.hide()
	else:
		$ComboLabel.show()
