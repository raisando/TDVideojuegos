extends Node

export (Array, PackedScene) var Escenas

var Main: Node2D
var Actual = -1

func change_scene(value):
	if value >= 0 and value < Escenas.size():
		for children in Main.get_children():
			children.queue_free()
		var nueva_escena = Escenas[value].instance()
		Main.add_child(nueva_escena)
		Actual = value
		
func reload_scene():
	change_scene(Actual)
