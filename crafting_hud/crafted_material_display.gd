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
	add_child(crafted_material)
	pass
