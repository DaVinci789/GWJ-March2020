extends StaticBody2D

signal recipe_consumed(grid)

var correct_pattern := ""

onready var tex_size: Vector2 = $Sprite.texture.get_size()

onready var crafted_recipes: Dictionary = Game.crafted_recipes
onready var crafting_grid = $terminal_ui/terminal_interface/grid_container/crafting_window

func _ready():
	correct_pattern = new_grid_pattern()
	$terminal_ui/terminal_interface/Label.text = crafted_recipes[correct_pattern]

func new_grid_pattern() -> String:
	var recipe_keys := crafted_recipes.keys()
	randomize()
	var random_index = randi() % recipe_keys.size()
	return recipe_keys[random_index]

func toggle_visibility():
	$terminal_ui.toggle_visibility()
	if $terminal_ui/terminal_interface.visible == true:
		Game.current_terminal = self
	else:
		Game.current_terminal = null
	pass

func load_container(container):
	$terminal_ui.load_container(container)

func move_window_to_top(node):
	crafting_grid.move_window_to_top(node)
	pass

func remove_material_from_grid(node):
	crafting_grid.remove_material_from_grid(node)
	pass

func snap_material_to_grid(node):
	crafting_grid.snap_material_to_grid(node)
	pass

func _on_terminal_ui_consume(materials: String):
	if correct_pattern in materials:
		$terminal_ui/terminal_interface/Label.text = "Correct!"
		$terminal_ui.clear_grid()
		emit_signal("recipe_consumed", correct_pattern)
		return
