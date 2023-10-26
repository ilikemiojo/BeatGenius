extends Node2D

var hit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_bumbo_pressed():
	if(hit):
		print("acertou")
	else:
		print("errou")

func _on_colisor_area_entered(area):
	hit = true
	print("entrou")

func _on_colisor_area_exited(area):
	hit = false
	print("saiu")
