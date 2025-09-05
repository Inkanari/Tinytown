extends TileMapLayer

@export var tile_precio: int = 10

const bloqueado = 1
const desbloqueado = 0
const seleccion = 2
#arrastre_new
var posicion_inicial
var posicion 
var arrastrando: bool = false

func _input(event: InputEvent) -> void:
	var mouse_posicion: Vector2i = local_to_map(to_local(get_global_mouse_position()))
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		posicion_inicial = mouse_posicion
		arrastrando = true
		posicion = mouse_posicion
		posicion_inicial = Vector2i.ZERO
		posicion = Vector2i.ZERO
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and arrastrando:
		if posicion_inicial:
			construir(posicion_inicial, mouse_posicion)
			arrastrando = false
			limpiar()
			posicion_inicial = Vector2i.ZERO
			posicion  = Vector2i.ZERO
func construir(posicion1: Vector2i, posicion2: Vector2i) -> void:
	var x_ini = min(posicion1.x, posicion2.x)
	var x_end = max(posicion1.x, posicion2.x)
	var y_ini = min(posicion1.y, posicion2.y)
	var y_end = max(posicion1.y, posicion2.y)
	for x in range(x_ini, x_end + 1):
		for y in range(y_ini, y_end + 1):
			var cell_pos = Vector2i(x, y)
			if get_cell_source_id(cell_pos) == bloqueado:
				if Inventario.has_item("dinero", tile_precio):
					set_cell(cell_pos, desbloqueado, Vector2i(1, 1))
					Inventario.remover_item("dinero", tile_precio)
				else:
					print("no tienes dinero")
func limpiar():
	pass #aqui
