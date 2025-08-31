extends Area2D

@export var item_name = "gajo"
@export var amount: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		Inventario.agregar_item(item_name, amount)
	queue_free()
