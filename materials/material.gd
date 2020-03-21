extends TextureRect

signal selected(object)
signal dropped(object)
signal disposed(object)

var drag_position = null

# used for when material is spawned from material_display
var spawned_in := false

# individual materials that this material is made of
var composed_of := []

# whether the player crafted this or if it is a raw material.
var crafted := false

# Godot doesn't react to input events if it didn't start *on* material
func _process(delta):
	if spawned_in:
		rect_global_position = get_global_mouse_position() - Vector2(16,16)
	if spawned_in and Input.is_action_just_released("drag"):
		spawned_in = false
		drag_position = null
		emit_signal("dropped", self)

func dispose():
	emit_signal("disposed", self)
	queue_free()

func get_material_type() -> String:
	if not crafted:
		# material type is stored in group
		# usually there's only one group per material...
		if get_groups()[0] == "idle_process":
			return get_groups()[1]
		else:
			return get_groups()[0]
	else:
		return "Crafted"

func _on_material_gui_input(event):
	# FIXME: Hack so spawned in resources are dragged along when created.
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
			emit_signal("selected", self)
		else:
			drag_position = null
			spawned_in = false
			emit_signal("dropped", self)
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
	pass # Replace with function body.

