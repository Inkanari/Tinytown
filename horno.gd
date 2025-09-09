extends StaticBody2D

var jugador_cerca: bool = false
@onready var horno_menu = $HornoMenu

func _ready() -> void:
	horno_menu.visible = false

func _on_area_deteccion_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		jugador_cerca = true
		print("¡Estás cerca del horno! Presiona F para abrir.")

func _on_area_deteccion_body_exited(body: Node2D) -> void:
	if body.name == "Jugador":
		jugador_cerca = false
		horno_menu.visible = false

func _input(event: InputEvent) -> void:
	if jugador_cerca and event.is_action_pressed("abrir_horno"):
		horno_menu.visible = !horno_menu.visible
		if horno_menu.visible:
			horno_menu.actualizar_labels()

func _on_fundir_button_pressed() -> void:
	print("Botón presionado! Iniciando fundición.")
	horno_menu.fundir_receta("lingote de hierro")
