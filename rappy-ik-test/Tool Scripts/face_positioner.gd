@tool
extends Node2D

@onready var skeleton: Skeleton2D = %Skeleton2D
@onready var animated_sprite: AnimatedSprite2D = %Faces

@onready var bone_name := %head
var bone_idx := -1

func _ready():
	set_process(true) # enable _process in the editor and runtime
	bone_idx = skeleton.find_bone(bone_name)
	if bone_idx == -1:
		push_error("Could not find bone: %s" % bone_name)

func _process(delta):
	if bone_idx >= 0:
		var global_bone_transform = skeleton.global_transform * skeleton.get_bone_global_pose(bone_idx)
		animated_sprite.global_transform = global_bone_transform
