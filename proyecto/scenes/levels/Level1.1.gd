extends Node2D
var enemigos
export (Array, NodePath) var portales
func _ready():
	enemigos=$Enemigos.get_child_count()
	var Enemigos = $Enemigos.get_children()
	for enemigo in Enemigos:
		enemigo.connect("enemigomuerto",self,"on_enemigomuerto")
func on_enemigomuerto():
	enemigos-=1
	if enemigos<=0:
		activarportal()

func activarportal():
	for path in portales:
		var nodo = get_node(path)
		nodo.habilitar()
