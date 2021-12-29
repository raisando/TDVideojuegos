extends KinematicBody2D

export var movil = true
### signal killed() colocar señal en PropPlayer

var linear_vel = Vector2.ZERO
var MAX_SPEED = 300
var JUMP_SPEED = 400
var DASH_SPEED = 600
var DASH_TIME = 0.15
var ACCELERATION = 100

var GRAVITY = 850

var _facing_right = true
var _airborne_time = 0
var _MAX_AIRBORNE_TIME = 0.1
var _ghost_state = false
var jump_count=0
var is_alive = true


# Vida = PropPlayer.Vida 
# Usar PropPlayer.Vida en vez de asignar a una variable

var _dashing_time = 0
var _can_dash= false
var _dashing = false

var player_en_portal = false
var portal_seleccionado



var bullet = preload("res://scenes/bullet.tscn")
var bullettimer=0


onready var Player = get_parent().get_node("Player")
onready var playback = $AnimationTree.get("parameters/playback")
onready var playbackg = $AnimationTreeg.get("parameters/playback")
onready var Entrada = $Entrada
onready var ataque_melee = $ataquemelee

var _can_shoot=true
onready var death_menu = $Panel

func _ready() -> void:
	#var _er = PropPlayer.connect("killed", self, "on_killed")
	ataque_melee.connect("body_entered", self, "on_ataquemelee_body_entered")
	
	$ataquemelee/CollisionShape2D.disabled = true
	$ataquemelee/CollisionShape2D2.disabled = true
	
	
	

func _process(delta):
	bullettimer+=delta
	if bullettimer>1:
		_can_shoot=true
	else:
		_can_shoot=false

func _physics_process(delta):
	if is_alive:
		if PropPlayer.Vida <= 0:
			#playback.travel("Muerte")
			#movil = false
			set_deferred("is_alive",false)
			
			#playback.travel("Muerte")
			if not _ghost_state:
				$AnimationTree.active=false
				$AnimationPlayer.call_deferred("play","Muerte")
			else: 
				$AnimationTreeg.active=false
				$Sprite2.visible=false
				$Sprite.visible=true
				$AnimationPlayer.call_deferred("play","Muerte")
			
		if movil == false:
			if Input.is_action_just_pressed("dash"):
				_dashing = true
				movil = true
				_can_dash = false
				playback.travel("dash")
				$ataquemelee/CollisionShape2D.set_deferred("disabled",true)
				$ataquemelee/CollisionShape2D2.set_deferred("disabled",true)
			linear_vel.x = 0
			linear_vel.y += GRAVITY * delta
			linear_vel = move_and_slide(linear_vel,Vector2.UP)
			return
		
		
		if Input.is_action_just_released("change_char"): #me cambia el estado del personaje
			_ghost_state=not _ghost_state
			
		if _ghost_state==false:  #para modo humano
			$Sprite2.visible=false
			$Sprite.visible=true
			jump_count=2
			
				
			
			linear_vel = move_and_slide(linear_vel,Vector2.UP,false,4,0.785398,false)
			var on_floor = is_on_floor()
			
			linear_vel.y += GRAVITY * delta
			
			var target_vel = Input.get_action_strength("right") - Input.get_action_strength("left")
			linear_vel.x = move_toward(linear_vel.x,target_vel * MAX_SPEED,ACCELERATION) 
			
			if on_floor or nextToWall():
				_airborne_time = 0
			else:
				_airborne_time += delta
				
			if (on_floor or _airborne_time <= _MAX_AIRBORNE_TIME or nextToWall()) and Input.is_action_just_pressed("jump"):
				if nextToRightWall():
					print("ntrw")
					linear_vel.x += 100
					linear_vel.y -= JUMP_SPEED
				if nextToLeftWall():
					print("ntlw")
					linear_vel.x -= 100
					linear_vel.y -= JUMP_SPEED
				else:		
					linear_vel.y = -JUMP_SPEED
					_airborne_time = _MAX_AIRBORNE_TIME

			if (on_floor or _airborne_time <= _MAX_AIRBORNE_TIME and _can_dash) and Input.is_action_just_pressed("dash"):
				_dashing = true
				_can_dash  = false
			if _dashing:
				_dashing_time += delta
				if _facing_right:
					linear_vel.x = DASH_SPEED
				else:
					linear_vel.x = -DASH_SPEED
				if _dashing_time >= DASH_TIME:
					_dashing = false
					_dashing_time = 0
					
					yield(get_tree().create_timer(4),"timeout")
					_can_dash = true
					
				
				
			#animations
			if on_floor:
				if abs(linear_vel.x)> 10 and not _dashing:
					playback.travel("run")
				elif Input.is_action_pressed("dash"):
					playback.travel("dash")
				elif Input.is_action_just_pressed("attack"):
					playback.travel("attackfull")
					$swing.play()
				else:
					playback.travel("idle")
			
			else: 
				if linear_vel.y >0:
					playback.travel("fall")
					if nextToWall():
						playback.travel("wallSlide")
				else:
					playback.travel("jump")
			
			if not _facing_right and Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
				scale.x = -1
				_facing_right = true

			if  _facing_right and Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
				scale.x = -1
				_facing_right = false	
		
		else:  #para modo fantasma
			$Sprite2.visible=true
			$Sprite.visible=false
			
			linear_vel = move_and_slide(linear_vel,Vector2.UP)
			var on_floor = is_on_floor()
			
			linear_vel.y += GRAVITY * delta
			
			var target_vel = Input.get_action_strength("right") - Input.get_action_strength("left")
			linear_vel.x = move_toward(linear_vel.x,target_vel * MAX_SPEED,ACCELERATION) 
			
			if on_floor:
				_airborne_time = 0
				jump_count=0
			else:
				_airborne_time += delta
				
			if Input.is_action_just_pressed("jump") and jump_count!=2:
				linear_vel.y = -JUMP_SPEED+GRAVITY*delta
				_airborne_time = _MAX_AIRBORNE_TIME
				jump_count+=1
			else:
				_airborne_time=0
				
				
			if (on_floor or _airborne_time <= _MAX_AIRBORNE_TIME and _can_dash) and Input.is_action_just_pressed("dash"):
				_dashing = true
				_can_dash  = false
			if _dashing:
				_dashing_time += delta
				if _facing_right:
					linear_vel.x = DASH_SPEED
				else:
					linear_vel.x = -DASH_SPEED
				if _dashing_time >= DASH_TIME:
					_dashing = false
					_dashing_time = 0
					
					yield(get_tree().create_timer(4),"timeout")
					_can_dash = true
			
			if Input.is_action_just_pressed("attack"):
				playbackg.travel("atackfull")
				_fire()
					
				
			#animations
			if on_floor:
				if abs(linear_vel.x)> 10 and not _dashing:
					playbackg.travel("run2")
				elif Input.is_action_pressed("dash"):
					playbackg.travel("dash")
				else:
					playbackg.travel("idle2")
			
			else:
				if linear_vel.y >0:
					playbackg.travel("fall")
				else:
					playbackg.travel("jump")
			
			if not _facing_right and Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
				scale.x = -1
				_facing_right = true

			if  _facing_right and Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
				scale.x = -1
				_facing_right = false	
				
		#TELEPORT

		if Entrada.is_colliding():
			player_en_portal = true
			portal_seleccionado = Entrada.get_collider()
		else:
			player_en_portal = false
			portal_seleccionado = Entrada.get_collider()
			
		if Input.is_action_just_pressed("Entrar") and player_en_portal:
			portal_seleccionado.activar(self)
			#get_tree().call_group("Player", "teleport_to", get_node(teleport_target).position)


#func teleport_to(target_pos):
#	position = target_pos

#export (NodePath) var teleport_target = get_parent().get_node("Portal1").position


func nextToWall():
	return nextToRightWall() or nextToLeftWall()

func nextToRightWall():
	return $RightWall.is_colliding()
	
func nextToLeftWall():
	return $LeftWall.is_colliding()

#func on_killed():
	
func quitar_vida_player(value):
	PropPlayer.Vida -= value
	if not _ghost_state:
		playback.call_deferred("travel","damage")
	else:
		$AnimationPlayerg.call_deferred("play","damage")


		
func _fire():
	if _can_shoot:
		var Bullet=bullet.instance()
		get_parent().add_child(Bullet)
		Bullet.global_position=$bulletspawn.global_position
		$castspell.play()
		if not _facing_right:
			Bullet.rotation= PI
		bullettimer=0
		
func on_ataquemelee_body_entered(body: Node):
	if body.is_in_group("enemigo") and body.has_method("quitar_vida"):
		body.quitar_vida(10)

func muerte_player():
	#PropPlayer.Vida = PropPlayer.VIDAMAX
	#LevelManager.reload_scene()
	$deathmenu/Panel.show()
	get_tree().paused = true
	PropPlayer.Vida = PropPlayer.VIDAMAX
	is_alive = true
	movil = true
	
	
# dejar al final
func _unhandled_key_input(event: InputEventKey) -> void:
	if event.pressed and event.scancode == KEY_0:
		PropPlayer.Vida -= 10
		playback.travel('damage')
	if event.pressed and event.scancode == KEY_R:
		PropPlayer.Vida = PropPlayer.VIDAMAX
		LevelManager.reload_scene()
