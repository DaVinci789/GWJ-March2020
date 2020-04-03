extends Node

var player: Node = null
var current_terminal: Node = null

const material_images = {
	"material": preload("res://assets/materials/block1.png"),
	"material1": preload("res://assets/materials/block2.png"),
	"material2": preload("res://assets/materials/block3.png"),
	"Thing 1": preload("res://assets/materials/2vert_block.png"),
	"Thing 2": preload("res://assets/materials/l_block.png"),
	"Thing 3": preload("res://assets/materials/cross_block.png"),
}

# Crafted materials will display the appropriate lowercase letter for each
# grid spot they occupy
const material_names_raw = {
	"material": "A",
	"material1": "B",
	"material2": "C",
	"Thing 1": "a",
	"Thing 2": "b",
	"Thing 3": "c",
}

const recipes = {
	"AB": "Thing 1",
	"AB--C": "Thing 2",
	"-A-ACA-A-": "Thing 3",
}

const crafted_recipes = {
	"bb-bb-aa": "Cooked 1",
	"ccccccccc": "Cooked 2",
}
