extends CollisionShape2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var health=100
func body_entered(body):
	health-=5
	print (health)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
