extends Area2D

@export var recuperacion: int = 15
@export var item_name = "manzana"
@export var amount: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("recuperar_vida"):
		print("el duende tomo la manzana")
		body.recuperar_vida(recuperacion)
	if body.name == "Jugador":
		Inventario.agregar_item(item_name, amount)
	queue_free()
