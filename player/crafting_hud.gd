extends CanvasLayer

var item_crafted := "Nothing"

func _on_craft_button_pressed():
	$crafting_area/Label.text = item_crafted
	pass # Replace with function body.


func _on_crafting_table_item_crafted(item_name: String):
	item_crafted = item_name
	pass # Replace with function body.

