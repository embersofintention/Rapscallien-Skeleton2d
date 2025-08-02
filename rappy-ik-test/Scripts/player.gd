extends CharacterBody2D

# PLAYER CONTROL SCRIPT 
# calls upon RappyParts for animations etc

# Variables and Constants:
var direction # Player direction -- 1=right, -1 = left
const SPEED = 600 # base player movement speed

@onready var rappy = %RappyParts # node with our animations and functions

func _ready() -> void:
	rappy.is_idle()

# MOVEMENT LOGIC FUNCTIONS: 

func determine_direction():
	# get direction from player input
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Player faces direction
	if direction: 
		if velocity.x != 0 and velocity.y == 0: # if moving horizontally
			rappy.all_parts.scale.x = sign(direction.x)
		
func determine_velocity(): 
	# set player velocity (simple for now)
	velocity = direction * SPEED


func head_looks_at_mouse():
	rappy.head.look_at(get_global_mouse_position())


# Physics Process Stuff
func _physics_process(delta: float) -> void:
	determine_direction()
	determine_velocity()
	#head_looks_at_mouse()
	
	# Determining animation state (simple for now)
	if velocity.length() == 0.0: # not moving
		rappy.is_idle()
	if velocity.length() > 0.0: # moving
		rappy.is_running()
		
		
	# apply movement
	move_and_slide()
	# apply animation speed
	rappy.animation_player.speed_scale = rappy.anim_base_speed









# :D
