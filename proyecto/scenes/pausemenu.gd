extends CanvasLayer


onready var pause_menu = $Panel
onready var continue_btn = $Panel/VBoxContainer/Continue
onready var lobby_btn = $Panel/VBoxContainer/Lobby
onready var quit_btn = $Panel/VBoxContainer/Quit


func _ready() -> void:
	continue_btn.connect("pressed", self, "on_continue_pressed")
	lobby_btn.connect("pressed", self, "on_lobby_pressed")
	quit_btn.connect("pressed", self, "__on_quit_pressed")
	
	pause_menu.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not event.is_echo():
		pause_menu.show()
		get_tree().paused = true

func on_continue_pressed():
		!pause_menu.hide()
		get_tree().paused = !get_tree().paused

	
func on_lobby_pressed():
	get_tree().change_scene("res://scenes/Lobby.tscn")
	get_tree().paused = false


func __on_quit_pressed():
	get_tree().quit()


