extends CanvasLayer


onready var pause_menu = $Panel
onready var retry_btn = $Panel/VBoxContainer/Retry
onready var lobby_btn = $Panel/VBoxContainer/Lobby
onready var quit_btn = $Panel/VBoxContainer/Quit


func _ready() -> void:
	retry_btn.connect("pressed", self, "on_retry_pressed")
	lobby_btn.connect("pressed", self, "on_lobby_pressed")
	quit_btn.connect("pressed", self, "__on_quit_pressed")
	
	pause_menu.hide()

func on_retry_pressed():
		!pause_menu.hide()
		LevelManager.reload_scene()
		get_tree().paused = false

	
func on_lobby_pressed():
	LevelManager.change_scene(2) #lobby
	get_tree().paused = false


func __on_quit_pressed():
	get_tree().quit()



