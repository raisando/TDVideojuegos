extends Area2D

var linear_vel = Vector2.ZERO
var MAX_SPEED = 300
var JUMP_SPEED = 300
var DASH_SPEED = 800
var ACCELERATION = 100

var GRAVITY = 400

var _facing_right = true
var _airborne_time = 0
var _MAX_AIRBORNE_TIME = 0.1

