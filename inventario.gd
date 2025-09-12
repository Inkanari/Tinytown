extends CanvasLayer

var inventario = {}
var contadores = {}

@export var item_name: String
@export var amount: int = 1

func _ready() -> void:
	for contador in get_tree().get_nodes_in_group("cantidad"):
		if contador is Label and contador.is_in_group("cantidad"):
			contadores[contador.name] = contador
	actualizar_contadores(inventario)
func agregar_item(item_name: String, amount: int = 1) -> void:
	if inventario.has(item_name):
		inventario[item_name] += amount
	else:
		inventario[item_name] = amount
	actualizar_contadores(inventario)
	print("", inventario)
	print("", contadores)
func remover_item(item_name: String, amount: int = 1) -> void:
	if inventario.has(item_name):
		inventario[item_name] -= amount
		if inventario[item_name] <= 0:
			inventario.erase(item_name)
	print("inventario: ", inventario)
func has_item(item_name: String, amount: int = 1) -> bool:
	return inventario.has(item_name) and inventario[item_name] >= amount
func actualizar_contadores(inventario):
	for item_name in contadores.keys():
		if inventario.has(item_name):
			contadores[item_name].text = str(inventario[item_name])
		else:
			contadores[item_name].text = "0"

func _on_alimentos_pressed() -> void:
	$Control/materiales_basicos.visible = false
	$Control/alimentos.visible = true
	$Control/comercio.visible = false
func _on_materiales_basicos_pressed() -> void:
	$Control/materiales_basicos.visible = true
	$Control/alimentos.visible = false
	$Control/comercio.visible = false
