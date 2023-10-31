extends AudioStreamPlayer

var bpm := 90
var measures := 2

var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

var closest = 0
var time_off_beat = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	sec_per_beat = 60.0 / bpm
	$Baiao_01.play()
	$Feedback.text = str($Baiao_01.get_playback_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	song_position = $Baiao_01.get_playback_position()
	$Feedback.text = str($Baiao_01.get_playback_position())

func _on_timer_timeout():
	print('beat')
