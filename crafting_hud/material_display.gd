extends TextureRect

signal material_spawned(object)

export (NodePath) var crafting_table

onready var crafting_table_node = get_node(crafting_table)
onready var material_template = load("res://materials/material.tscn")

func _on_material_display_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var material_instance = material_template.instance()
			material_instance.texture = self.texture
			material_instance.connect("selected", crafting_table_node, "move_window_to_top")
			material_instance.connect("selected", crafting_table_node, "remove_material_from_grid")
			material_instance.connect("dropped", crafting_table_node, "snap_material_to_grid")
			
			emit_signal("material_spawned", material_instance)
			add_child(material_instance)
