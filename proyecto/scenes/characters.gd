extends Node2D

func _input(event):
  if event.is_action_pressed("switch_player"):
	# Just an ugly boolean switch :D
	var temp_state = $player2.active
	$player2.active = $player1.active
	$player1.active = temp_state
