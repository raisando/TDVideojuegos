extends Area2D

export var Cambia_escena = true
export (PackedScene) var escena_destino

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var Posicion_salida = $Position2D


func activar(Player):
	if Cambia_escena:
		get_tree().change_scene_to(escena_destino)
	else:
		Player.global_position = Posicion_salida.global_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
