extends AudioStreamPlayer

var bpm := 90

var song_position = 0.0
var sec_per_beat = 60.0 / bpm
var beats_before_start = 0
var beat_atual = 0

signal beat()
signal baiao_01_finished()
signal hit_time();

# Called when the node enters the scene tree for the first time.
func _ready():
	$Baiao_01.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	beat_atual += 0.25
	emit_signal("beat", beat_atual)


func _on_baiao_01_finished():
	emit_signal("baiao_01_finished")

func restart():
	beat_atual = 0
	$Baiao_01.play(0.0)
