extends Area2D

@export var item_name = "lingote de hierro"
@export var amount: int = 1

func _ready():
	await get_tree().create_timer(300.0).timeout
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		Inventario.agregar_item(item_name, amount)
	queue_free()
