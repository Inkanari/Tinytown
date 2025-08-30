extends StaticBody2D

signal destruir(piedra_node)
var ocupado: bool = false

@export var vida: int = 10
@export var drop_escene: PackedScene
@export var drop_escene_2: PackedScene
@export var flash_duracion: float = 0.2

var shake_magnitud = 3 
var shake_duracion = 0.1


func shake():
	var tiempo = 0.0
	var pos_original = position
	while tiempo < shake_duracion:
		var offset = Vector2(randf_range(-shake_magnitud, shake_magnitud)
		, randf_range(-shake_magnitud, shake_magnitud))
		position = pos_original + offset
		await get_tree().process_frame
		tiempo += get_process_delta_time()
	position = pos_original
	
func flash():
	
	var tiempo = 0.0
	var duracion = flash_duracion
	var color_original = modulate
	var color_destello = Color(2, 2, 2)

	
	while tiempo < duracion:
		var t = tiempo / duracion
		var color = lerp(color_destello, color_original, t)
		modulate = color
		await get_tree().process_frame
		tiempo += get_process_delta_time()
	
	modulate = color_original
	
func recibir_golpe(daño: int = 1):
	await get_tree().create_timer(0.3).timeout
	vida -= daño
	shake()
	flash()
	if vida <= 0:
		picar()
	
func picar():
	if drop_escene:
		emit_signal("destruir", self)
		for i in range(7):
			var loot = drop_escene.instantiate()
			var x = randf_range(10, -10)
			var y = randf_range(-10, 10)
			loot.position = position + Vector2(x, y)
			get_parent().add_child(loot)
	if drop_escene_2:
		for i in range(2):
			var loot = drop_escene_2.instantiate()
			var x = randf_range(10, -10)
			var y = randf_range(-10, 10)
			loot.position = position + Vector2(x, y)
			get_parent().add_child(loot)
	ocupado = false
	await get_tree().process_frame
	queue_free()
