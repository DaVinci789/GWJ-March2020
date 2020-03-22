extends StaticBody2D

var material_images: Dictionary = Game.material_images

export (String, "material", "material1", "material2") var material_supply_type := "material"

func _ready():
	$Sprite.texture = material_images[material_supply_type]
	pass

func _process(delta):
	$Sprite.texture = material_images[material_supply_type]
	pass
