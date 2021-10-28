extends RigidBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var AreaVision = get_node("Area2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	AreaVision.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
	print(body.name)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
