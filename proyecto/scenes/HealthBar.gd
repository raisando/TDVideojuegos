extends TextureProgress
onready var health_bar = $HealthBar
var Health: = 100
func _process(_delta):
	if Input.is_action_just_pressed("left"):
		Health-=5	
		health_bar.value = Health
	if Input.is_action_just_pressed("right"):
		Health+=5
		health_bar.value = Health
		
	print (Health)
	pass
