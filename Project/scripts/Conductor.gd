extends AudioStreamPlayer

var bpm := 90*4
var sectionsLastBeat

var song_position = 0.0
var sec_per_beat = 60.0 / bpm
var section_atual = 0
var beat_atual = 0
var last_reported_beat = 0

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

func _physics_process(delta):
	song_position = $Song.get_playback_position() + AudioServer.get_time_since_last_mix()
	song_position -= AudioServer.get_output_latency()
	beat_atual = int(floor(song_position / sec_per_beat))
	report_beat()

func report_beat():
	if (last_reported_beat < beat_atual):
		emit_signal("beat", beat_atual)
		last_reported_beat = beat_atual
		
	if (section_atual < sectionsLastBeat.size()):
		if (beat_atual == sectionsLastBeat[section_atual]):
			emit_signal("section_finished")
	elif (section_atual == sectionsLastBeat.size()):
		emit_signal("song_finished")

func nextSection():
	section_atual += 1

func restart(position, beat):
	$Timer.stop()
	beat_atual = beat
	last_reported_beat = beat
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
			bpm = 90*4
			sectionsLastBeat = [68,132,196]
		2:
			$Song.stream = load("res://audio/baiao.mp3")
			bpm = 90
			sectionsLastBeat = [17, 33, 49]
		3:
			$Song.stream = load("res://audio/baiao.mp3")
			bpm = 90
			sectionsLastBeat = [17, 33, 49]
