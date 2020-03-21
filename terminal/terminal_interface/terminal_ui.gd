extends CanvasLayer

signal consume(materials)

func toggle_visibility():
	$terminal_interface.visible = not $terminal_interface.visible

func load_container(container):
	$terminal_interface/grid_container/crafting_window.container = container

func new_grid_pattern():
	pass

func _on_Button_pressed():
	emit_signal("consume", $terminal_interface/grid_container/crafting_window.grid_to_string($terminal_interface/grid_container/crafting_window.grid))
	pass # Replace with function body.

func _on_terminal_ui_consume(materials):
	return
	$terminal_interface/Label.text = str(materials)
