extends TextureProgress


onready var health_bar =$HealthBar
var health=75

func currenthealth(health, amount):
	texture_progress.value= health
func max_health(max_health):
	health_bar.max_value = 1000
