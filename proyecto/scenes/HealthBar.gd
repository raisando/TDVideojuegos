extends Control

onready var health_bar =$HealthBar
var health=75
func currenthealth(health, amount):
	health_bar.value= 75

func max_health(max_health):
	health_bar.max_value = 75

