extends CanvasLayer

onready var HealthBar = $Control/HealthBar

func _ready() -> void:
	var _er = PropPlayer.connect("health_change",self,"on_health_change")
	HealthBar.value = PropPlayer.Vida

func on_health_change(Vida):
	HealthBar.value = Vida
