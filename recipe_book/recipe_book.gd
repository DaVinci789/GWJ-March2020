extends Control

# Recipe Book Structure
# Left Page
## Name
## Ingredients Needed
# Right Page
## Image of final product
## Flavor text

onready var pages = {
	"lpage": $binding/page_container/lpage,
	"rpage": $binding/page_container/rpage,
}

onready var page_contents_nodes = {
	"lpage": pages["lpage"].get_node("page_contents"),
	"rpage": pages["rpage"].get_node("page_contents"),
}

const CORNER_HOVER_COLOR = Color.yellow
const CORNER_UNHOVER_COLOR = Color.white

var current_page := 0

var recipes = Game.recipes
var crafted_recipes = Game.crafted_recipes

func _ready():
	pages["lpage"].connect("mouse_entered", self, "_on_lpage_mouse_enter")
	pages["lpage"].connect("mouse_exited", self, "_on_lpage_mouse_exit")
	pages["rpage"].connect("mouse_entered", self, "_on_rpage_mouse_enter")
	pages["rpage"].connect("mouse_exited", self, "_on_rpage_mouse_exit")

func render_page(page_number = -1) -> void:
	if page_number == -1:
		# use current_page variable
		return
	else:
		# render page_number
		return
	pass

func next_page() -> void:
	pass

func prev_page() -> void:
	pass

func _on_lpage_mouse_enter():
	pages["lpage"].get_node("corner").modulate = CORNER_HOVER_COLOR
	return

func _on_lpage_mouse_exit():
	pages["lpage"].get_node("corner").modulate = CORNER_UNHOVER_COLOR
	return

func _on_rpage_mouse_enter():
	pages["rpage"].get_node("corner").modulate = CORNER_HOVER_COLOR
	return

func _on_rpage_mouse_exit():
	pages["rpage"].get_node("corner").modulate = CORNER_UNHOVER_COLOR
	return