extends CharacterBody2D
var esta_en_zona = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		esta_en_zona = true 
		print("estas en zona")
func comerciar():
	if esta_en_zona:
		$"../Inventario".visible = !$"../Inventario".visible
		print("comerciaste")

func _ready() -> void:
	Global.connect("interactuar", Callable(self, "comerciar"))
