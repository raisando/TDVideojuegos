extends KinematicBody2D

var linear_vel = Vector2.ZERO
var MAX_SPEED = 300
var JUMP_SPEED = 300
var DASH_SPEED = 800
var ACCELERATION = 100

var GRAVITY = 400

var _facing_right = true
var _airborne_time = 0
var _MAX_AIRBORNE_TIME = 0.1
var _ghost_state=false

onready var playback = $AnimationTree.get("parameters/playback")
onready var playbackg = $AnimationTreeg.get("parameters/playback")

func _physics_process(delta):
	if Input.is_action_pressed("change_char"): #me cambia el estado del personaje
		_ghost_state=not _ghost_state
		
	if _ghost_state==false:  #para modo humano
		$spriteg.visible=false
		$Sprite.visible=true
		
		linear_vel = move_and_slide(linear_vel,Vector2.UP)
		var on_floor = is_on_floor()
		
		linear_vel.y += GRAVITY * delta
		
		var target_vel = Input.get_action_strength("right") - Input.get_action_strength("left")
		linear_vel.x = move_toward(linear_vel.x,target_vel * MAX_SPEED,ACCELERATION) 
		
		if on_floor:
			_airborne_time = 0
		else:
			_airborne_time += delta
			
		if (on_floor or _airborne_time <= _MAX_AIRBORNE_TIME) and Input.is_action_just_pressed("jump"):
			linear_vel.y = -JUMP_SPEED
			_airborne_time = _MAX_AIRBORNE_TIME
			
		if (on_floor or _airborne_time <= _MAX_AIRBORNE_TIME) and Input.is_action_just_pressed("dash"):
			if _facing_right:
				linear_vel.x = DASH_SPEED
			else:
				linear_vel.x = -DASH_SPEED
				
			
			
		#animations
		if on_floor:
			if abs(linear_vel.x)> 10:
				playback.travel("run")
			elif Input.is_action_pressed("dash"):
				playback.travel("dash")
			else:
				playback.travel("idle")
		
		else:
			if linear_vel.y >0:
				playback.travel("fall")
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
		
		var jump_count=false
		
		linear_vel = move_and_slide(linear_vel,Vector2.UP)
		var on_floor = is_on_floor()
		
		linear_vel.y += GRAVITY * delta
		
		var target_vel = Input.get_action_strength("right") - Input.get_action_strength("left")
		linear_vel.x = move_toward(linear_vel.x,target_vel * MAX_SPEED,ACCELERATION) 
		
		if on_floor:
			_airborne_time = 0
			jump_count=false
		else:
			_airborne_time += delta
			
		if Input.is_action_just_pressed("jump") and !jump_count:
			linear_vel.y = -JUMP_SPEED
			_airborne_time = _MAX_AIRBORNE_TIME
			jump_count=true
		if Input.is_action_just_pressed("jump") and jump_count:
			_airborne_time=0
			
			
		if (on_floor or _airborne_time <= _MAX_AIRBORNE_TIME) and Input.is_action_just_pressed("dash"):
			if _facing_right:
				linear_vel.x = DASH_SPEED
			else:
				linear_vel.x = -DASH_SPEED
				
			
		#animations
		if on_floor:
			if abs(linear_vel.x)> 10:
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
	
	
