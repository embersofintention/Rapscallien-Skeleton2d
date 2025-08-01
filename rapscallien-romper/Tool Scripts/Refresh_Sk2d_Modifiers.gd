@tool
extends Skeleton2D

const EXECUTION_MODE_PROCESS = 0

func _rebind_modifications():
	var mod_stack = self.get_modification_stack()
	if not mod_stack:
		print("No modification stack found.")
		return
	for i in mod_stack.get_modification_count():
		var mod = mod_stack.get_modification(i)
		# Handle common modifier types (customize for your use case)
		if mod.has_method("set_bone_name"):  # For single-bone mods
			var current_bone = mod.get_bone_name()
			mod.set_bone_name(current_bone)  # Forces a reassignment
		elif mod.has_method("set_bone_names"):  # For multi-bone mods
			var bones = mod.get_bone_names()
			mod.set_bone_names(bones)  # Reassigns all at once
		# You may need extra handling for target nodes or other props
	self.execute_modifications(0.0, EXECUTION_MODE_PROCESS)  # Optionally, refresh mods immediately
	print("Reassigned all assigned bones in modifier stack.")
