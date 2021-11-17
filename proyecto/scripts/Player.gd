extends KinematicBody2D

signal health_change(health)
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




var _dashing_time = 0
var _can_dash= false
var _dashing = false


onready var playback = $AnimationTree.get("parameters/playback")
onready var playbackg = $AnimationTreeg.get("parameters/playback")


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
			

func nextToWall():
	return nextToRightWall() or nextToLeftWall()

func nextToRightWall():
	return $RightWall.is_colliding()
	
func nextToLeftWall():
	return $LeftWall.is_colliding()
