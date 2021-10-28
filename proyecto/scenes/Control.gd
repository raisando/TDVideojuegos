extends Control
onready var health_bar = $HealthBar
#var Health: = 100
func _process(_delta):
	if Input.is_action_just_pressed("left"):		
		health_bar.value -= 5
	if Input.is_action_just_pressed("right"):
		health_bar.value += 5
		
	pass
