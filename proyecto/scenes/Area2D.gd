extends Area2D
onready var health = get_node("../../HUD/Control/HealthBar")

func _ready():
	connect("body_entered", self, "on_body_entered")
	
func on_body_entered(body):
	health.value-=5
	print (health)
