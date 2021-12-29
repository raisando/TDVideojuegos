extends Area2D

export var Cambia_escena = true
export var escena_destino: int
export var desactivado= false

onready var Posicion_salida = $Position2D


func activar(Player):
	if not desactivado:
		if Cambia_escena:
			LevelManager.change_scene(escena_destino)
		else:
			Player.global_position = Posicion_salida.global_position

func _ready() -> void:
	if desactivado:
		$Sprite.hide()
		

func habilitar():
	print("owo")
	$Sprite.show()
	desactivado=false

