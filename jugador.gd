extends CharacterBody2D

#inventario
var inventario = {}
#variables generales
@export var speed = 120
@export var daño: int = 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_single"):
		abrir_inventario()
#inventario
func abrir_inventario():
	$"../../Inventario".visible = not $"../../Inventario".visible
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
#daño
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("golpe"):
		$AnimatedSprite2D.play("golpe")
		var cuerpos = $Hitbox.get_overlapping_bodies()
		for body in cuerpos:
			if body.has_method("recibir_golpe"):
				body.recibir_golpe(daño)
#movimiento
func mover(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("izquierda", "derecha")
	input_vector.y = Input.get_axis("arriba", "abajo")
	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	move_and_slide()
func _physics_process(delta: float) -> void:
	mover(delta)
