extends CanvasLayer

func update_score(score):
	$ScoreLabel.text = str(score)

func update_combo(multiplier):
	$ComboLabel.text = 'Combo: ' + str(multiplier)
	if (multiplier == 1):
		$ComboLabel.hide()
	else:
		$ComboLabel.show()

func update_section(section):
	match section:
		0:
			$SectionIcons/Section_1.texture = load("res://sprites/iconHollow.png")
			$SectionIcons/Section_2.texture = load("res://sprites/iconHollow.png")
			$SectionIcons/Section_3.texture = load("res://sprites/iconHollow.png")
		1:
			$SectionIcons/Section_1.texture = load("res://sprites/iconFilled.png")
		2:
			$SectionIcons/Section_2.texture = load("res://sprites/iconFilled.png")
		3:
			$SectionIcons/Section_3.texture = load("res://sprites/iconFilled.png")
