extends AudioStreamPlayer

var bpm := 90
var sectionsLastBeat

var song_position = 0.0
var sec_per_beat = 60.0 / bpm
var beats_before_start = 0
var section_atual = 0
var beat_atual = 0

signal beat()
signal baiao_01_finished()
signal baiao_02_finished()
signal baiao_03_finished()
signal section_finished()
signal song_finished()

# Called when the node enters the scene tree for the first time.
func _ready():
	levelSetup()
	$Song.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	beat_atual += 0.25
	emit_signal("beat", beat_atual)
#	if (section_atual == (sectionsLastBeat.size() - 1)):
#		emit_signal("song_finished")
	if (section_atual < sectionsLastBeat.size()):
		if (beat_atual == sectionsLastBeat[section_atual]):
			emit_signal("section_finished")
			section_atual += 1
#	if(beat_atual == 17):
#		emit_signal("baiao_01_finished")
#	if(beat_atual == 33):
#		emit_signal("baiao_02_finished")
#	if(beat_atual == 49):
#		emit_signal("baiao_03_finished")

func restart(position, beat):
	$Timer.stop()
	beat_atual = beat
	$Song.play(position)
	$Timer.start()
	
func pauseTimer():
	$Timer.stop()
	$Song.stop()

func failSound():
	$Fail.play()

func sectionCompleteSound():
	$SectionComplete.play()

func sectionCompletePerfectSound():
	$SectionCompletePerfect.play()

func songCompleteSound():
	$SongComplete.play()

func songCompletePerfectSound():
	$SongCompletePerfect.play()

func levelSetup():
	match Singletons.level:
		1:
			$Song.stream = load("res://audio/baiao.mp3")
			bpm = 90
			sectionsLastBeat = [17, 33, 49]
		2:
			$Song.stream = load("res://audio/baiao.mp3")
			bpm = 90
			sectionsLastBeat = [17, 33, 49]
		3:
			$Song.stream = load("res://audio/baiao.mp3")
			bpm = 90
			sectionsLastBeat = [17, 33, 49]
