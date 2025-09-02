extends Area2D

@export var item_name = "hierro bruto"
@export var amount: int = 1

func _ready():
	await get_tree().create_timer(300.0).timeout
	queue_free()
