extends Control

@onready var carbon_icon: TextureRect = $Panel/CarbonIcon
@onready var carbon_count: Label = $Panel/CarbonIcon/CarbonCount
@onready var hierro_icon: TextureRect = $Panel/HierroIcon
@onready var hierro_count: Label = $Panel/HierroIcon/HierroCount
@onready var texture_progress_bar: TextureProgressBar = $Panel/TextureProgressBar
@onready var timer: Timer = $Panel/Timer
@onready var fundir_button: TextureButton = $Panel/FundirButton

# Carga las cinco texturas de progreso
var progress_textures: Array = [
	preload("uid://btryblhc0c33s"),
	preload("uid://fhxklnxt7jbp"),
	preload("uid://n1u8417vdjfu"),
	preload("uid://m2b087oukm14"),
	preload("uid://bc8axab14mtgw"),
	preload("uid://b7rc6aoenqvrm"),
	preload("uid://bpuq2aonbhfeo")
]

var recetas = {
	"lingote de hierro": {
		"inputs": {"hierro bruto": 2, "carbon": 1},
		"output_amount": 1,
		"fundir_tiempo": 5.0
	}
}

var receta_actual: String = ""

func _ready() -> void:
	visible = false
	if timer == null:
		push_error("Error: Nodo Timer no encontrado en $Panel/Timer")
		return
	if fundir_button == null:
		push_error("Error: Nodo FundirButton no encontrado en $Panel/FundirButton")
		return
	timer.one_shot = true
	actualizar_labels()
	print("Inventario inicial (HornoMenu):", Inventario.inventario)

func actualizar_labels() -> void:
	carbon_count.text = str(Inventario.inventario.get("carbon", 0))
	hierro_count.text = str(Inventario.inventario.get("hierro bruto", 0))
	Inventario.actualizar_contadores(Inventario.inventario)  # Actualizar HUD
	print("Interfaz horno actualizada - Carbon:", carbon_count.text, "Hierro:", hierro_count.text)

func fundir_receta(receta_name: String) -> void:
	if timer.time_left > 0:  # Evitar fundir si el Timer está activo
		print("¡Fundición en curso, espera a que termine!")
		return
	print("Intentando fundir:", receta_name)
	print("Inventario actual:", Inventario.inventario)
	var receta = recetas[receta_name]
	var can_fundir = true
	for item in receta["inputs"].keys():
		if not Inventario.has_item(item, receta["inputs"][item]):
			can_fundir = false
			break
	if can_fundir:
		for item in receta["inputs"].keys():
			Inventario.remover_item(item, receta["inputs"][item])
		receta_actual = receta_name
		timer.wait_time = receta["fundir_tiempo"]
		timer.start()
		fundir_button.disabled = true  # Deshabilitar botón
		texture_progress_bar.value = 0
		texture_progress_bar.texture_progress = progress_textures[0]
		actualizar_labels()
		print("¡Fundiendo " + receta_name + "...!")
	else:
		print("¡Faltan materiales para " + receta_name + "!")

func _on_timer_timeout() -> void:
	print("Timer timeout disparado.")
	var receta = recetas[receta_actual]
	Inventario.agregar_item(receta_actual, receta["output_amount"])
	fundir_button.disabled = false  # Habilitar botón
	actualizar_labels()
	texture_progress_bar.value = 0
	texture_progress_bar.texture_progress = progress_textures[0]
	print("¡" + receta_actual.capitalize() + " listo! Inventario:", Inventario.inventario)
	receta_actual = ""

func _process(delta: float) -> void:
	if timer.time_left > 0:
		var progress = (1 - timer.time_left / timer.wait_time) * 100
		texture_progress_bar.value = progress
		if progress < 14:
			texture_progress_bar.texture_progress = progress_textures[0]
		elif progress < 28:
			texture_progress_bar.texture_progress = progress_textures[1]
		elif progress < 42:
			texture_progress_bar.texture_progress = progress_textures[2]
		elif progress < 56:
			texture_progress_bar.texture_progress = progress_textures[3]
		elif progress < 70:
			texture_progress_bar.texture_progress = progress_textures[4]
		elif progress < 84:
			texture_progress_bar.texture_progress = progress_textures[5]
		else:
			texture_progress_bar.texture_progress = progress_textures[6]
		
