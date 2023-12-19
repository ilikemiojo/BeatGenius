extends AudioStreamPlayer

var bpm := 90*4
var sectionsLastBeat
var sectionsRestartBeat
var sectionsStartTime
var bumboTimings
var caixaTimings
var bumboDemoTimings
var caixaDemoTimings

var song_position = 0.0
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
	if (Singletons.free_play == 0):
		song_position = $Song.get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		beat_atual = int(floor(song_position / $Timer.wait_time))
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
		section_atual = 0

func nextSection():
	section_atual += 1

func restart(section, position, beat):
	$Timer.stop()
	section_atual = section
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
			$Timer.wait_time = 60.0 / bpm
			sectionsLastBeat = [68,132,196]
			sectionsRestartBeat = [0, 68, 132]
			sectionsStartTime = [0, 10.67, 21.33]
			bumboDemoTimings = [16,19,24,27,32,80,83,88,91,96,144,147,151,152,155,158,160]
			caixaDemoTimings = [22,30,82,86,90,94,146,150,154,157]
			bumboTimings = [48,51,56,59,64,112,115,120,123,128,176,179,183,184,187,190,192]
			caixaTimings = [54,62,114,118,122,126,178,182,186,189]
		2:
			$Song.stream = load("res://audio/xote.mp3")
			bpm = 90*4
			$Timer.wait_time = 60.0 / bpm
			sectionsLastBeat = [68,132,196]
			sectionsRestartBeat = [0, 68, 132]
			sectionsStartTime = [0, 10.67, 21.33]
			bumboDemoTimings = [16,20,22,24,28,30,32,80,84,86,88,92,94,96,144,147,148,150,152,155,156,158,160]
			caixaDemoTimings = [82,90,146,154,157]
			bumboTimings = [48,52,54,56,60,62,64,112,116,118,120,124,126,128,176,179,180,182,184,187,188,190,192]
			caixaTimings = [114,122,178,186,189]
		3:
			$Song.stream = load("res://audio/xaxado.mp3")
			bpm = 120*4
			$Timer.wait_time = 60.0 / bpm
			sectionsLastBeat = [68,132,196]
			sectionsRestartBeat = [0, 68, 132]
			sectionsStartTime = [0, 8, 16]
			bumboDemoTimings = [16,19,22,24,27,30,32,80,83,86,88,91,94,96,144,147,150,152,155,158,160]
			caixaDemoTimings = [84,92,145,148,151,153,156,159]
			bumboTimings = [48,51,54,56,59,62,64,112,115,118,120,123,126,128,176,179,182,184,187,190,192]
			caixaTimings = [116,124,177,180,183,185,188,191]
