extends Node2D


func _ready():
	LevelManager.Main = self
	LevelManager.change_scene(0)
