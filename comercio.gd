extends GridContainer

#productos
var manzana = preload("res://icons_textura/manzana.tres")
var lingote_oro: Texture2D = preload("res://icons_textura/lingote_oro.tres")

var productos = [
	lingote_oro,
	manzana
]

func _ready() -> void:
	randomize()
	var textura_random = productos.pick_random()
	$casilla_1/TextureRect.texture = textura_random
