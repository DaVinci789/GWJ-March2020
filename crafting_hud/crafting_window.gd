extends Control

signal item_crafted(item_name)

export (NodePath) var container_path

onready var work_grid = $work_grid
onready var container = get_node(container_path)
var grid := {}

const recipes = {
	"ABC": "Thing 1",
	"AB--C": "Thing 2",
	"A--B-": "Thing 3",
}

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

func grid_to_string(grid: Dictionary) -> String:
	var grid_as_string := ""
	# Goes downward and to the right
	# 1 4 7
	# 2 5 8
	# 3 6 9
	for column in grid.keys(): # not necessarily true for all cases, just this grid
		for row in grid[column]:
			var grid_value = "" # String representation of grid
			if str(grid[column][row]) == "False": # False becomes "-"
				grid_value = "-"
			else:
				grid_value = str(grid[column][row])
			grid_as_string += grid_value # append to string
	return grid_as_string
	pass

func clear_grid():
	$work_grid.clear_grid()
	pass

func _on_work_grid_grid_updated(_grid):
	grid = _grid
	var grid_as_string := grid_to_string(grid)
	for recipe in recipes:
		if recipe in grid_as_string:
			emit_signal("item_crafted", recipes[recipe])
			break # so it doesn't fall through to "Nothing"
		else:
			emit_signal("item_crafted", "Nothing")
