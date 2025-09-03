extends GridContainer

#productos
var productos = [
	{
		"nombre": "lingote_de_oro",
		"icon": preload("res://icons_textura/lingote_oro.tres"),
		"precio": 100
	},
	{
		"nombre": "manzana",
		"icon": preload("res://icons_textura/manzana.tres"),
		"precio": 10
	}
]

func _ready() -> void:
	randomize()
	var copia = productos.duplicate() #se crea una copia de los productos
	copia.shuffle() #shuffle significa barajear para cambiar el orden de los productos
	for i in range(min(get_child_count(), copia.size())):
		var casilla = get_child(i)
		var producto = copia[i]
		casilla.get_node("TextureRect").texture = producto["icon"]
		casilla.get_node("Label").text = str(producto["precio"]) + "$"

func _on_casilla_1_pressed() -> void:
	pass # Replace with function body.
