extends KinematicBody2D

var linear_vel = Vector2.ZERO
var direccion_x = 1
const MAX_SPEED = 120
const JUMP_SPEED = 300
const ACCELERATION = 100
const GRAVITY = 400
const MINDISTANCE = 32

export var start_direction = Vector2(1,0)

#var seguiri = false
var seguir = false
var _facing_right = true
var vida_enemigo = 60
var attacking = false

var is_alive = true
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var AreaVision = get_node("Area2D")
#onready var AreaVisionDer = get_node("Area2DIzq")
onready var recon_pared = $RayCast2D
onready var Player



# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	var Players = get_tree().get_nodes_in_group("Player")
	print_debug(Players)
	if Players.size() > 0:
		Player = Players[Players.size()-1]
	#seguir = false
	direccion_x = start_direction.x
	recon_pared.cast_to.x *= direccion_x
	AreaVision.connect("body_entered", self, "_on_body_entered")
	AreaVision.connect("body_exited", self, "_on_body_exited")
	$ataquemelee.connect("body_entered",self,"on_ataquemelee_player_body_entered")
	$ataquemelee/CollisionShape2D.disabled = true
	$ataquemelee/CollisionShape2D2.disabled = true


func _physics_process(delta):
	if is_alive:
		
		if vida_enemigo <= 0:
			#is_alive = false
			set_deferred("is_alive",false)
			$AnimationPlayer.call_deferred("play","Muerte")


		var dir_seguir = Vector2(Player.global_position.x - global_position.x,0)#
		
			
		#seguir = false
		
		if not seguir and not attacking:
			if recon_pared.is_colliding():
				direccion_x *= -1
				recon_pared.cast_to.x *= -1
				$Sprite.flip_h = not $Sprite.flip_h

			if direccion_x > 0:
				$Sprite.flip_h = false
			else:
				$Sprite.flip_h = true
				
			linear_vel.x = direccion_x * MAX_SPEED
			linear_vel.y = delta * GRAVITY
			$AnimationPlayer.play("Deambular")
		
			linear_vel = move_and_slide(linear_vel, Vector2.UP)
		
		#if recon_pared.is_colliding() and not seguir:
		#	direccion_x *= -1
		#	recon_pared.cast_to.x *= -1
		if seguir and dir_seguir.length() > MINDISTANCE and not attacking:
			if dir_seguir.x > 0:
				$Sprite.flip_h = false
			else:
				$Sprite.flip_h = true
			if $AnimationPlayer.current_animation != "Deambular":
				$AnimationPlayer.play("Deambular")
			move_and_collide(dir_seguir.normalized() * MAX_SPEED * delta * 0.8)
			
		if seguir and dir_seguir.length() <= MINDISTANCE and not attacking:
			attacking = true
			if dir_seguir.x > 0:
				$ataquemelee.scale.x = 1
			else:
				$ataquemelee.scale.x = -1
			$skeletonatack.play()
			$AnimationPlayer.play("Ataque")
			yield($AnimationPlayer,"animation_finished")
			attacking = false


	


func _on_body_entered(body: Node):
	if body.is_in_group("Player"):
		seguir = true
		print(body.name + " entra")
	

func _on_body_exited(body: Node):
	#contador para esperar unos segundos antes de volver a deambular
	
	if body.is_in_group("Player"):
		seguir = false
		print(body.name + " sale")

func quitar_vida_ghost(value):
	vida_enemigo -= value
	print(vida_enemigo)
	
func muerte():
	queue_free()

func on_ataquemelee_player_body_entered(body: Node):
	if body.is_in_group("Player") and body.has_method("quitar_vida_player"):
		body.quitar_vida_player(5)
		
