extends CanvasLayer

var item_crafted := "Nothing"

func _on_craft_button_pressed():
	$crafting_area/crafted_material_display/Label.text = item_crafted
	if item_crafted != "Nothing":
		$crafting_area/crafting_table.clear_grid()
		$crafting_area/crafted_material_display.spawn_crafted_material(item_crafted)
		item_crafted = "Nothing"
	pass # Replace with function body.


func _on_crafting_table_item_crafted(item_name: String):
	item_crafted = item_name
	pass # Replace with function body.

