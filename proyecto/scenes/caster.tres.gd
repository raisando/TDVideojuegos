extends KinematicBody2D

var vida_enemigo = 60
var bullet = preload("res://scenes/bullet.tscn")

	
func _ready():
	
	$Timer.connect("timeout", self, "_fire")
	
	

	
func _fire():
	#print("a")
	var Bullet=bullet.instance()
	get_tree().get_root().add_child(Bullet)
	Bullet.global_position=$bulletspawn.global_position
	#print("b")
	
func quitar_vida(value):
	vida_enemigo -= value
	print(vida_enemigo)

func muerte():
	queue_free()

