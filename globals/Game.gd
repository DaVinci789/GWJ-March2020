extends Node

var player: Node = null
var current_terminal: Node = null

# Crafted materials will display the appropriate lowercase letter for each
# grid spot they occupy
const material_names_raw = {
	"material": "A",
	"material1": "B",
	"material2": "C",
	"Thing 1": "a",
	"Thing 2": "b",
}

const recipes = {
	"AB": "Thing 1",
	"AB--C": "Thing 2",
}

const crafted_recipes = {
	"bb-bb-aa": "Cooked 1",
}