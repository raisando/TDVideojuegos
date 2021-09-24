extends Node2D


onready var p1 = $Human
onready var p2 = $Ghost
onready var active_player = p1
func _ready():
	switch_player(p1)
func _input(event):
	if event.is_action_pressed("change_char"):
		if p1==active_player:
			active_player=p2
		if p2==active_player:
			active_player=p1
		


func switch_player (new_player):
	active_player = new_player
