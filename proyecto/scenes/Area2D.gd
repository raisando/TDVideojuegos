extends Area2D
onready var health = get_node("../../HUD/Control/HealthBar")
#onready var invulnerable= get_node("../Invulnerable")
#var originalhealth=health
func _ready():
	connect("body_entered", self, "on_body_entered")
	#connect("timeout",self,"_on_timer_timeout")
	
func on_body_entered(body):
	health.value-=5
	print (health.value)

#func _on_timer_timeout():
#	if originalhealth.value!=health.value and invulnerable.is_stopped():
#		originalhealth.value=health.value
#		invulnerable.start()
#		print (originalhealth.value)
		
