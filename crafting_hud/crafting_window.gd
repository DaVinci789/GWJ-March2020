extends Control

signal item_crafted(item_name)

export (NodePath) var container_path

onready var work_grid = $work_grid
onready var container = get_node(container_path)
var grid := {}

const recipes = {
	"AB": "Thing 1",
	"AB--C": "Thing 2",
}

# recipes from largest to smallest.
var sorted_recipes = recipes.keys()

class StringSorter:
	static func sort_by_length(str1: String,  str2: String):
		if str1.length() > str2.length():
			return str1
		else:
			return str2

func _ready():
	sorted_recipes.sort_custom(StringSorter, "sort_by_length")
	pass

func move_window_to_top(node):
	container.move_child(node, container.get_child_count() - 1)
	pass

func remove_material_from_grid(node):
	if work_grid.get_item_under_position(node.rect_position):
		if work_grid.get_item_under_position(node.rect_position).name != node.name:
			return
	work_grid.grab_item(node.rect_position)
	pass

func snap_material_to_grid(node):
	work_grid.insert_item(node)
	pass

func grid_to_string(raw_grid: Dictionary) -> String:
	var grid_as_string := ""
	# Goes downward and to the right
	# 1 4 7
	# 2 5 8
	# 3 6 9
	for column in raw_grid.keys(): # not necessarily true for all cases, just this grid
		for row in raw_grid[column]:
			var grid_value = "" # String representation of grid
			if str(raw_grid[column][row]) == "False": # False becomes "-"
				grid_value = "-"
			else:
				grid_value = str(raw_grid[column][row])
			grid_as_string += grid_value # append to string
	return grid_as_string
	pass

func clear_grid():
	$work_grid.clear_grid()
	pass

# returns the items used to craft
func get_material_list() -> Array:
	var item_names_in_grid := []
	for item in $work_grid.items:
		item_names_in_grid.append(item.get_groups()[0])
	return item_names_in_grid

func _on_work_grid_grid_updated(_grid):
	grid = _grid
	var grid_as_string := grid_to_string(grid)
	for recipe in sorted_recipes:
		if recipe in grid_as_string:
			emit_signal("item_crafted", recipes[recipe])
			break # so it doesn't fall through to "Nothing"
		else:
			emit_signal("item_crafted", "Nothing")
