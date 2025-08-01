@tool
extends Node

@export var skeleton_path: NodePath
@export var animation_player_path: NodePath
@export var ik_animation_name: String = "ik_anim"
@export var baked_animation_name: String = "baked_anim"
@export var frame_rate: int = 30

@export var bake_animation: bool = false: 
	set(value):
		bake_animation = value
		if bake_animation: 
			set_bake_animation(value)
			# uncheck in editor
			bake_animation = false



var skeleton: Skeleton2D
var animation_player: AnimationPlayer
var baking = false
var timer := 0.0
var animation_length = 0.0
var current_key_time = 0.0



func _ready():
	
	# Cache nodes for ease of use and safety checks
	if skeleton_path != null:
		skeleton = get_node_or_null(skeleton_path)
	if animation_player_path != null:
		animation_player = get_node_or_null(animation_player_path)

	# Ensure animation player exists and has the IK animation
	if animation_player and ik_animation_name != "":
		var anim = animation_player.get_animation(ik_animation_name)
		if anim:
			animation_length = anim.length

func set_bake_animation(value):
	bake_animation = value
	if bake_animation:
		# Start baking process
		if not skeleton or not animation_player:
			push_error("Skeleton2D or AnimationPlayer node not set or not found!")
			bake_animation = false
			return
		var anim = animation_player.get_animation(ik_animation_name)
		if not anim:
			push_error("IK animation '%s' not found in AnimationPlayer!" % ik_animation_name)
			bake_animation = false
			return

		baking = true
		timer = 0.0
		current_key_time = 0.0

		# Create blank baked animation or clear existing one
		if animation_player.has_animation(baked_animation_name):
			animation_player.remove_animation(baked_animation_name)
		animation_player.add_animation(baked_animation_name, Animation.new())

		animation_player.play(ik_animation_name)
		animation_player.seek(0.0, true)
		# Set active animation so skeleton updates properly
		animation_player.set_active(true)

func _process(delta):
	if baking:
		timer += delta
		var frame_duration = 1.0 / frame_rate
		var expected_key_time = floor(timer / frame_duration) * frame_duration

		# Only insert keys when we reach next frame time (avoid duplicating keys)
		if expected_key_time > current_key_time and expected_key_time <= animation_length:
			current_key_time = expected_key_time
			animation_player.seek(current_key_time, true)
			# Make sure skeleton updates immediately before reading bone poses
			skeleton._update_global_pose()  # This is internal, but usually works; otherwise rely on next frame

			var baked_anim = animation_player.get_animation(baked_animation_name)

			for i in range(skeleton.get_bone_count()):
				var bone_name = skeleton.get_bone_name(i)
				var bone_transform = skeleton.get_bone_global_pose(i)
				var track_name = "pose/bones/%s/transform" % bone_name

				var track_idx = baked_anim.find_track(track_name, Animation.TYPE_TRANSFORM)
				if track_idx == -1:
					track_idx = baked_anim.add_track(Animation.TYPE_TRANSFORM)
					baked_anim.track_set_path(track_idx, track_name)

				baked_anim.track_insert_key(track_idx, current_key_time, bone_transform)

		# Check if finished baking
		if current_key_time >= animation_length:
			baking = false
			bake_animation = false  # Uncheck toggle automatically
			animation_player.stop()
			print("Baking complete. Created animation: '%s'" % baked_animation_name)

func _get_property_list():
	# Show bake_animation toggle in inspector even if false (custom property hint)
	var props = []
	props.append({
		"name": "bake_animation",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_EDITOR,
		"hint": PROPERTY_HINT_NONE
	})
	return props
