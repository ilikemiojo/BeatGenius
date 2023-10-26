extends Node2D

var speed = 134/2
var hit = false
const SPAWN_Y = -31
const SPAWN_X = 511

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = SPAWN_X
	position.y = SPAWN_Y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !hit:
		position.y += speed * delta
		if position.y > 200:
			pass
