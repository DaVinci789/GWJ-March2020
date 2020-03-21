extends Panel

export (NodePath) var disposal_path: NodePath
export (NodePath) var material_supply_path: NodePath
export (NodePath) var crafting_path: NodePath
export (NodePath) var material_container_path: NodePath
onready var disposal_node = get_node(disposal_path)
onready var supply_node   = get_node(material_supply_path)
onready var crafting_node = get_node(crafting_path)
onready var material_container_node = get_node(material_container_path)

var material_scene := preload("res://materials/material.tscn")

var crafted_material_textures := {
	"Thing 1": preload("res://assets/materials/2vert_block.png"),
	"Thing 2": preload("res://assets/materials/l_block.png"),
}

func spawn_crafted_material(material_to_craft: String, materials_used: Array) -> void:
	var crafted_material: TextureRect = material_scene.instance()
	crafted_material.add_to_group(material_to_craft)
	crafted_material.texture = crafted_material_textures[material_to_craft]
	crafted_material.composed_of = materials_used
	crafted_material.crafted = true
	crafted_material.rect_scale = Vector2(1,1)
	crafted_material.connect("dropped", disposal_node, "remove_material")
	crafted_material.connect("selected", crafting_node, "move_window_to_top")
	crafted_material.connect("disposed", self, "crafted_material_destroyed")
	
	crafted_material.connect("dropped", crafting_node, "snap_material_to_grid")
	crafted_material.connect("selected", crafting_node, "remove_material_from_grid")
	
	if Game.current_terminal:
		crafted_material.connect("selected", Game.current_terminal, "move_window_to_top")
		crafted_material.connect("selected", Game.current_terminal, "remove_material_from_grid")
		crafted_material.connect("dropped", Game.current_terminal, "snap_material_to_grid")
	
	# centers the material.
	# magic numbers derived from centering the $Label child
	crafted_material.margin_left = 30
	crafted_material.margin_top  = 10
	crafted_material.margin_right = -30
	crafted_material.margin_bottom = 10
	
	crafted_material.rect_position.x = rect_position.x + (rect_size.x / 3)
	crafted_material.rect_position.y = rect_position.y
	
	supply_node.add_child(crafted_material)
	pass

func crafted_material_destroyed(crafted_material):
	if crafted_material.crafted:
		for display in material_container_node.get_children():
			var material_display = display.get_child(0)
			material_display.increment_label(crafted_material)
