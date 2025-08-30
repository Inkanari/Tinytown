extends CanvasLayer
var inventario = {}

func agregar_item(item_name: String, amount: int = 1) -> void:
	if inventario.has(item_name):
		inventario[item_name] += amount
	else:
		inventario[item_name] = amount
	print("inventario: ", inventario)
func remover_item(item_name: String, amount: int = 1) -> void:
	if inventario.has(item_name):
		inventario[item_name] -= amount
		if inventario[item_name] <= 0:
			inventario.erase(item_name)
	print("inventario: ", inventario)
func has_item(item_name: String, amount: int = 1) -> bool:
	return inventario.has(item_name) and inventario[item_name] >= amount
