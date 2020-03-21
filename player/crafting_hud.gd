extends CanvasLayer

var item_crafted := "Nothing"

func _on_craft_button_pressed():
	$crafting_area/crafted_material_display/Label.text = item_crafted
	print($crafting_area/crafting_table.grid_to_string($crafting_area/crafting_table.grid))
	if item_crafted != "Nothing":
		$crafting_area/crafted_material_display.spawn_crafted_material(item_crafted, $crafting_area/crafting_table.get_material_list())
		$crafting_area/crafting_table.clear_grid()
		item_crafted = "Nothing"
	pass # Replace with function body.


func _on_crafting_table_item_crafted(item_name: String):
	item_crafted = item_name
	pass # Replace with function body.

