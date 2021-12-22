extends KinematicBody2D

signal health_change(Vida)
signal killed()

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
var _ghost_state=false
var jump_count=0


var Vida = 100

var _dashing_time = 0
var _can_dash= false
var _dashing = false

var player_en_portal = false
var portal_seleccionado

onready var Player = get_parent().get_node("Player")
onready var playback = $AnimationTree.get("parameters/playback")
onready var playbackg = $AnimationTreeg.get("parameters/playback")
onready var Entrada = $Entrada

func _physics_process(delta):
	if Input.is_action_just_released("change_char"): #me cambia el estado del personaje
		_ghost_state=not _ghost_state
		
	if _ghost_state==false:  #para modo humano
		$spriteg.visible=false
		$Sprite.visible=true
		jump_count=2
		
			
		
		linear_vel = move_and_slide(linear_vel,Vector2.UP)
		var on_floor = is_on_floor()
		
		linear_vel.y += GRAVITY * delta
		
		var target_vel = Input.get_action_strength("right") - Input.get_action_strength("left")
		linear_vel.x = move_toward(linear_vel.x,target_vel * MAX_SPEED,ACCELERATION) 
		
		if on_floor or nextToWall():
			_airborne_time = 0
		else:
			_airborne_time += delta
			
		if (on_floor or _airborne_time <= _MAX_AIRBORNE_TIME or nextToWall()) and Input.is_action_just_pressed("jump"):
			if nextToWall():
				if nextToRightWall():
					print("ntrw")
					linear_vel.x -= 1000
					linear_vel.y -= JUMP_SPEED
				if nextToLeftWall():
					print("ntlw")
					linear_vel.x += 1000
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
		$spriteg.visible=true
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
				
				
			
		#animations
		if on_floor:
			if abs(linear_vel.x)> 10 and not _dashing:
				playbackg.travel("run")
			elif Input.is_action_pressed("dash"):
				playbackg.travel("dash")
			else:
				playbackg.travel("idle")
		
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


func vida_modificada():
	emit_signal("health_change", Vida)


func nextToWall():
	return nextToRightWall() or nextToLeftWall()

func nextToRightWall():
	return $RightWall.is_colliding()
	
func nextToLeftWall():
	return $LeftWall.is_colliding()


