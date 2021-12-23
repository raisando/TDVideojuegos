extends CanvasLayer

export (NodePath) var Player_path
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var HealthBar = $Control/HealthBar

var Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = get_node(Player_path)
	
	var _er = Player.connect("health_change",self,"on_health_change")

func on_health_change(Vida):
	HealthBar.value = Vida
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
