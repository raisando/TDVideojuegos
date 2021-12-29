extends KinematicBody2D

var vida_enemigo = 60
var bullet = preload("res://scenes/enemybullet.tscn")
var is_alive=true
onready var Player
export var _facing_right = true
signal enemigomuerto

func _ready():
	$Timer.connect("timeout", self, "_fire")
	$AnimationPlayer.call_deferred("play","attack")
	
func _physics_process(delta):
	if is_alive:		
		if vida_enemigo <= 0:	
			set_deferred("is_alive",false)
			$Sprite.visible=false
			$Sprite2.visible=true
			$AnimationPlayer.call_deferred("play","death")

	
func _fire():
	#print("a")
	var Bullet=bullet.instance()
	get_tree().get_root().add_child(Bullet)
	$enemyspell.play()
	if not _facing_right:
			Bullet.global_position=$bulletspawn.global_position
			Bullet.rotation= PI
			scale.x = -1
	else:
		Bullet.global_position=$bulletspawn.global_position
	
func quitar_vida_ghost(value):
	vida_enemigo -= value
	print(vida_enemigo)

func muerte():
	emit_signal("enemigomuerto")
	queue_free()


