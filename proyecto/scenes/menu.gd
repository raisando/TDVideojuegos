extends CanvasLayer


onready var play_button=$VBoxContainer/Play
onready var Credits_button=$VBoxContainer/Credits
onready var Quit_button=$VBoxContainer/Quit

func _ready():
	play_button.connect("pressed", self, "on_play_pressed")
	Credits_button.connect("pressed", self, "on_credits_pressed")
	Quit_button.connect("pressed", self, "on_quit_pressed")


func on_play_pressed():
	LevelManager.change_scene(2) # Lobby

func on_credits_pressed():
	LevelManager.change_scene(1) # Créditos
	
func on_quit_pressed():
	get_tree().quit()
