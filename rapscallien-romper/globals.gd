extends Node

func _physics_process(delta: float) -> void:
	
	# GLOBAL CONTROLS #
	
	#restart scene
	if Input.is_action_just_pressed("Restart"): 
		get_tree().reload_current_scene()
	
	# exit game
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()
