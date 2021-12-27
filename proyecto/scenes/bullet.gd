extends Area2D

export var SPEED = 350

func _ready():
	connect("body_entered", self, "_on_body_entered")
func _physics_process(delta):
	position+= transform.x * SPEED * delta

func _on_body_entered(body: Node):
	queue_free()
