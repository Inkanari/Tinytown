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
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and arrastrando:
		if posicion_inicial:
			construir(posicion_inicial, mouse_posicion)
			arrastrando = false
			limpiar()
			posicion_inicial = Vector2i.ZERO
			posicion  = Vector2i.ZERO
func _process(delta: float) -> void:
	if arrastrando:
		posicion = local_to_map(to_local(get_global_mouse_position()))
		marcar_area(posicion_inicial, posicion)
func construir(posicion1: Vector2i, posicion2: Vector2i) -> void:
	var x_ini = min(posicion1.x, posicion2.x)
	var x_end = max(posicion1.x, posicion2.x)
	var y_ini = min(posicion1.y, posicion2.y)
	var y_end = max(posicion1.y, posicion2.y)
	var total_costo = 0
	var celdas_a_desbloquear = []
	for x in range(x_ini, x_end + 1):
		for y in range(y_ini, y_end + 1):
			var cell_pos = Vector2i(x, y)
			if get_cell_source_id(cell_pos) != desbloqueado or get_cell_source_id(cell_pos) == seleccion:
				celdas_a_desbloquear.append(cell_pos)
				total_costo += tile_precio
	if not Inventario.has_item("dinero", total_costo):
		print("no tienes suficiente dinero")
		return
	Inventario.remover_item("dinero", total_costo)
	for celda in celdas_a_desbloquear:
		set_cell(celda, desbloqueado, Vector2i(1, 1))
func marcar_area(posicion1: Vector2i, posicion2: Vector2i):
	var x_ini = min(posicion1.x, posicion2.x)
	var x_end = max(posicion1.x, posicion2.x)
	var y_ini = min(posicion1.y, posicion2.y)
	var y_end = max(posicion1.y, posicion2.y)
	for x in range(x_ini, x_end + 1):
		for y in range(y_ini, y_end + 1):
			var cell_pos = Vector2i(x, y)
			if not get_cell_source_id(cell_pos) == desbloqueado:
				set_cell(cell_pos, seleccion, Vector2i(1, 1))
func limpiar() -> void:
	var tamaño = get_used_rect()
	for x in range(tamaño.position.x, tamaño.position.x + tamaño.size.x):
		for y in range(tamaño.position.y, tamaño.position.y + tamaño.size.y):
			var cell_pos = Vector2i(x, y)
			if get_cell_source_id(cell_pos) == seleccion:
				set_cell(cell_pos, bloqueado, Vector2i(1, 1))
