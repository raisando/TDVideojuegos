extends Area2D

export var melee = true
export var fantasma = false


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var vida_enemigo = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
	print(body.name)
	pass # Replace with function body.

func quitar_vida(value):
	vida_enemigo -= value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if vida_enemigo <= 0:
		queue_free()
