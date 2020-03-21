extends StaticBody2D

onready var crafting_grid = $terminal_ui/terminal_interface/grid_container/crafting_window

func toggle_visibility():
	$terminal_ui.toggle_visibility()
	if $terminal_ui/terminal_interface.visible == true:
		Game.current_terminal = self
	else:
		Game.current_terminal = null
	pass

func load_container(container):
	$terminal_ui.load_container(container)

#				material_instance.connect("selected", Game.current_terminal, "move_window_to_top")
#				material_instance.connect("selected", Game.current_terminal, "remove_material_from_grid")
#				material_instance.connect("dropped", Game.current_terminal, "snap_material_to_grid")

func move_window_to_top(node):
	crafting_grid.move_window_to_top(node)
	pass

func remove_material_from_grid(node):
	crafting_grid.remove_material_from_grid(node)
	pass

func snap_material_to_grid(node):
	crafting_grid.snap_material_to_grid(node)
	pass
