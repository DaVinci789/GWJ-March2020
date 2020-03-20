extends TextureRect

signal material_spawned(object)

export (NodePath) var crafting_table
export (NodePath) var disposal_path

onready var crafting_table_node = get_node(crafting_table)
onready var disposal_node  = get_node(disposal_path)
onready var material_template = load("res://materials/material.tscn")

# maybe refactor this to be a part of material container?
func _on_material_display_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var material_instance = material_template.instance()
			material_instance.texture = self.texture
			material_instance.connect("selected", crafting_table_node, "move_window_to_top")
			material_instance.connect("selected", crafting_table_node, "remove_material_from_grid")
			material_instance.connect("dropped", crafting_table_node, "snap_material_to_grid")
			material_instance.connect("dropped", disposal_node, "remove_material")
			
			# set material_instance's material type
			material_instance.add_to_group(self.get_groups()[0])
			
			# half of the texture width and height
			material_instance.rect_global_position = get_global_mouse_position() -  Vector2(16,16)
			material_instance.spawned_in = true

			emit_signal("material_spawned", material_instance)
			$"../..".add_child(material_instance)
			material_instance.drag_position = get_global_mouse_position() - material_instance.rect_global_position
