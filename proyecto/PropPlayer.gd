extends Node

signal health_change(Vida)
signal killed()

const VIDAMAX = 100
var Vida = VIDAMAX setget set_vida,get_vida
var Health_bar


func set_vida(nueva_vida):
	Vida = nueva_vida
	emit_signal("health_change", Vida)
	if Vida <= 0:
		Vida = VIDAMAX
		emit_signal("killed")
		#LevelManager.reload_scene()
	

func get_vida():
	return Vida

