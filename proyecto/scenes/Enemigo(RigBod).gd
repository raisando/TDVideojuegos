extends KinematicBody2D

var linear_vel = Vector2.ZERO
var direccion_x = 1
var MAX_SPEED = 150
var JUMP_SPEED = 300
var ACCELERATION = 100
var GRAVITY = 400

var start_direction = Vector2(1,0)



var _facing_right = true

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var AreaVision = get_node("Area2D")
onready var recon_pared = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	direccion_x = start_direction.x
	recon_pared.cast_to.x *= direccion_x
	AreaVision.connect("body_entered", self, "_on_body_entered")
	
func _physics_process(delta):
	
	if recon_pared.is_colliding():
		direccion_x *= -1
		recon_pared.cast_to.x *= -1
		
	linear_vel.x = direccion_x * MAX_SPEED
	linear_vel.y = delta * GRAVITY
	
	linear_vel = move_and_slide(linear_vel, Vector2.UP)


func _on_body_entered(body: Node):
	print(body.name)
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
