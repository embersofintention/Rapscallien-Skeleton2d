extends Node2D

# BODY ANIMATIONS
# This script handles our animation functions, called within Player script 

# Note:  face swapping is an AnimatedSprite2D called "Faces", and a child of head2 bone

# Variables
var current_animation:= "" # Storage for Animation Helper Function
var current_face := "" # Storage for Face Swap
var anim_base_speed = 1.0 # animation playback speed; default = 1

@onready var all_parts = %ALL_PARTS # contains polygons, skeleton, IK targets and faces
@onready var head = %head

@onready var animation_player = %AnimationSet # AnimationPlayer node reference
	# ANIM LIST: 
	# idle 1, walk 1, run 1
@onready var face = %Faces # face swapper node
	# FACE LIST: 
	# default, blush, excited


# HELPER FUNCTIONS: 

# Set animation only if it's changed
func change_animation(anim_name: String):
	if current_animation != anim_name: 
		animation_player.play(anim_name)
		current_animation = anim_name
		
# Set face only if it's changed
func change_face(face_name: String):
	if current_face != face_name: 
		face.play(face_name)
		current_face = face_name


# ANIMATION SWAPPING FUNCTION THINGS
# (replace with proper state machine later)

func is_idle():
	change_animation("idle 1")
	change_face("default")
	anim_base_speed = 1

func is_running():
	change_animation("run 1")
	change_face("excited")
	anim_base_speed = 2








# :D
