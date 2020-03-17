extends TextureRect

signal grid_updated(grid)

const material_names_raw = {
	"material": "A",
	"material1": "B",
	"material2": "C",
}

var items = []
var grid = {}

var cell_size = 32
var grid_width = 0
var grid_height = 0

func _ready():
	var grid_size := get_grid_size(self)
	grid_width = grid_size.x
	grid_height = grid_size.y
	
	for x_pos in range(grid_width):
		grid[x_pos] = {}
		for y_pos in range(grid_height):
			grid[x_pos][y_pos] = false

func get_grid_size(selected_material) -> Dictionary:
	var results := {} # Dict instead of Vector2 since a Vector2 can cast to float unexpectedly
	var material_size: Vector2 = selected_material.rect_size
	results.x = clamp(int(material_size.x / cell_size), 1, 500) # 500 is just arbitrarily large
	results.y = clamp(int(material_size.y / cell_size), 1, 500)
	return results

func position_to_grid_coord(position) -> Dictionary:
	var local_pos = position - rect_global_position
	var results = {}
	results.x = int(local_pos.x / cell_size)
	results.y = int(local_pos.y / cell_size)
	return results

func is_grid_space_avaliable(x, y, w, h) -> bool:
	if x < 0 or y < 0:
		return false
	if (x + w) > grid_width or (y + h) > grid_height:
		return false
	for x_pos in range(x, x + w):
		for y_pos in range(y, y + h):
			if grid[x_pos][y_pos]:
				return false
	return true

func set_grid_space(x, y, w, h, state) -> void:
	for x_pos in range(x, x + w):
		for y_pos in range(y, y + h):
			grid[x_pos][y_pos] = state

func insert_item(item) -> bool:
	var item_position = item.rect_global_position + Vector2(cell_size / 2,  cell_size / 2)
	var grid_position = position_to_grid_coord(item_position)
	var item_size = get_grid_size(item)
	# I have no idea why the item is sometimes added to the idle_process group.
	if item.is_in_group("idle_process"):
		item.remove_from_group("idle_process")
	if is_grid_space_avaliable(grid_position.x, grid_position.y, item_size.x, item_size.y):
		# item.get_groups[0] returns the material type of item.
		set_grid_space(grid_position.x, grid_position.y, item_size.x, item_size.y, material_names_raw[item.get_groups()[0]])
		item.rect_global_position = rect_global_position + Vector2(grid_position.x, grid_position.y) * cell_size
		# items aren't perfectly snapping to the grid
		item.rect_global_position.y -= 1
		items.append(item)
		emit_signal("grid_updated", grid)
		return true
	else:
		return false

func get_item_under_position(search_position):
	for item in items:
		if item.get_global_rect().has_point(search_position):
			return item
	return null

func grab_item(grab_position):
	var item = get_item_under_position(grab_position)
	if not item:
		return null

	var item_position = item.rect_global_position + Vector2(cell_size / 2, cell_size / 2)
	var grid_position = position_to_grid_coord(item_position)
	var item_size = get_grid_size(item)
	set_grid_space(grid_position.x, grid_position.y, item_size.x, item_size.y, false)
	
	items.remove(items.find(item))
	emit_signal("grid_updated", grid)
	return item

func clear_grid():
	for column in range(0,grid_width):
		for row in range(0,grid_height):
			# "1, 1" because we're assuiming we're focusing on the grid already
			set_grid_space(row, column, 1, 1, false)
	for item in items:
		item.queue_free()
	items = []
