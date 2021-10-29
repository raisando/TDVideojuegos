extends Control
onready var health_bar = $HealthBar
onready var Health = get_node("../../Player/Area2D").health
var aux=0
func _process(_delta):
	aux+=1
	if aux%50==0:
		health_bar.value+=1
		aux=0
	if health_bar.value != Health.value:
		health_bar=Health.value
		print (Health)
	#if health_bar.value==0:
		
#
