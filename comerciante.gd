extends CharacterBody2D
var esta_en_zona = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		esta_en_zona = true 
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Jugador":
		esta_en_zona = false
		$"../Inventario".visible = false
		$"../Inventario/Control/comercio".visible = false
func comerciar():
	if esta_en_zona:
		$"../Inventario".visible = !$"../Inventario".visible
		$"../Inventario/Control/comercio".visible = !$"../Inventario/Control/comercio".visible

func _ready() -> void:
	Global.connect("interactuar", Callable(self, "comerciar"))
