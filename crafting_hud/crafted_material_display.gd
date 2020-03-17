extends Panel

var material_scene := preload("res://materials/material.tscn")

var crafted_material_textures := {
	"Thing 1": preload("res://assets/materials/2vert_block.png"),
	"Thing 2": preload("res://assets/materials/l_block.png"),
}

func spawn_crafted_material(material_to_craft: String) -> void:
	var crafted_material: TextureRect = material_scene.instance()
	crafted_material.texture = crafted_material_textures[material_to_craft]
	crafted_material.rect_scale = Vector2(1,1)
	
	# centers the material.
	# magic numbers derived from centering the $Label child
	crafted_material.margin_left = 30
	crafted_material.margin_top  = 10
	crafted_material.margin_right = -30
	crafted_material.margin_bottom = 10
	add_child(crafted_material)
	pass
