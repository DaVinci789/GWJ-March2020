extends Panel

func remove_material(material_node: TextureRect):
	# maybe change this to an Area2D...
	if rect_position.x < material_node.rect_position.x+material_node.rect_size.x \
	and material_node.rect_position.x < rect_position.x+rect_size.x \
	and material_node.rect_position.y < rect_position.y+material_node.rect_size.y \
	and rect_position.y < material_node.rect_position.y+rect_size.y:
		material_node.queue_free()
	pass
