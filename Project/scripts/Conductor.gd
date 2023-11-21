extends AudioStreamPlayer

var bpm := 90

var song_position = 0.0
var sec_per_beat = 60.0 / bpm
var beats_before_start = 0
var beat_atual = 0

signal beat()
signal baiao_01_finished()
signal baiao_02_finished()
signal baiao_03_finished()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Baiao.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	beat_atual += 0.25
	emit_signal("beat", beat_atual)
	if(beat_atual == 17):
		emit_signal("baiao_01_finished")
	if(beat_atual == 33):
		emit_signal("baiao_02_finished")
	if(beat_atual == 49):
		emit_signal("baiao_03_finished")

func restart(position, beat):
	$Timer.stop()
	beat_atual = beat
	$Baiao.play(position)
	$Timer.start()
	
func pauseTimer():
	$Timer.stop()
	$Baiao.stop()

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

