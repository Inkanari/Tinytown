extends StaticBody2D

@export var vida: int = 2
@export var drop_escene: PackedScene
#shake
var shake_magnitud = 5
var shake_duracion = 0.2

#shake
func shake():
	var tiempo = 0.0
	var pos_original = position
	while tiempo < shake_duracion:
		var offset = Vector2(randf_range(-shake_magnitud, shake_magnitud), randf_range(-shake_magnitud, shake_magnitud))
		position = pos_original + offset
		await get_tree().process_frame
		tiempo += get_process_delta_time()
	position = pos_original
#talacion
func recibir_golpe(daño: int = 1):
	await get_tree().create_timer(0.3).timeout
	vida -= daño
	shake()
	if vida <= 0:
		picar()
func picar():
	if drop_escene:
		for i in range(4):
			var loot = drop_escene.instantiate()
			var x = randf_range(10, -10)
			var y = randf_range(-10, 10)
			loot.position = position + Vector2(x, y)
			get_parent().add_child(loot)
	await get_tree().process_frame
	queue_free()
