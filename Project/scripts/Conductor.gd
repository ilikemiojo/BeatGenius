extends AudioStreamPlayer

var bpm := 90
var measures := 2

var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var beat_atual = 0
var measure = 1

var closest = 0
var time_off_beat = 0.0

signal hit_time();
signal beat()

# Called when the node enters the scene tree for the first time.
func _ready():
	sec_per_beat = 60.0 / bpm
	$Baiao_01.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	beat_atual += 0.25
	emit_signal("beat", beat_atual)
