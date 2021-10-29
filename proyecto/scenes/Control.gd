extends Control
onready var health_bar = $HealthBar
onready var Health = get_node("../../Player/Area2D").health
func _process(_delta):
	if health_bar.value != Health.value:
		health_bar=Health.value
		print (Health)
#
