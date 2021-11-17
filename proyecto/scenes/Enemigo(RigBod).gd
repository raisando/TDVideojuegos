extends KinematicBody2D

var linear_vel = Vector2.ZERO
var direccion_x = 1
var MAX_SPEED = 120
var JUMP_SPEED = 300
var ACCELERATION = 100
var GRAVITY = 400

var start_direction = Vector2(1,0)

#var seguiri = false
var seguir = false
var _facing_right = true

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var AreaVision = get_node("Area2D")
#onready var AreaVisionDer = get_node("Area2DIzq")
onready var recon_pared = $RayCast2D
onready var Player = get_parent().get_node("Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	#seguir = false
	direccion_x = start_direction.x
	recon_pared.cast_to.x *= direccion_x
	AreaVision.connect("body_entered", self, "_on_body_entered")
	AreaVision.connect("body_exited", self, "_on_body_exited")
	
func _physics_process(delta):
	var dir_seguir = (Player.global_position - global_position).normalized()
	dir_seguir.y = 0
	#seguir = false
	
	if not seguir:
		if recon_pared.is_colliding():
			direccion_x *= -1
			recon_pared.cast_to.x *= -1
		linear_vel.x = direccion_x * MAX_SPEED
		linear_vel.y = delta * GRAVITY
	
		linear_vel = move_and_slide(linear_vel, Vector2.UP)
	
	#if recon_pared.is_colliding() and not seguir:
	#	direccion_x *= -1
	#	recon_pared.cast_to.x *= -1
	if seguir:
		move_and_collide(dir_seguir * MAX_SPEED * delta * 1.8)

	


func _on_body_entered(body: Node):
	seguir = true
	print(body.name + " entra")
	pass # Replace with function body.

func _on_body_exited(body: Node):
	#contador para esperar unos segundos antes de volver a deambular
	seguir = false
	print(body.name + "sale")
	
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
