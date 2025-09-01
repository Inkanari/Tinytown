extends StaticBody2D

@export var drop_escene: PackedScene 

func _ready() -> void:
	Global.connect("interactuar", Callable(self, "abrir_cofre"))
func abrir_cofre() -> void:
	print("abrio")
	var aleatorio = randi_range(1, 50)
	if drop_escene:
		for i in range(aleatorio):
			var manzana = drop_escene.instantiate()
			var x = randf_range(10, -10)
			var y = randf_range(-10, 10)
			manzana.position = position + Vector2(x, y)
			get_parent().add_child(manzana)
