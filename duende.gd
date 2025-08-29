extends CharacterBody2D

#Estados
enum estado {
	Quieto,
	Patrullar,
	Al_arbol,
	Talar
}
#IA
@export var identificacion_minima: float = 28.0
@export var daño: int = 2
@export var daño_intervalo: float = 0.3
var objetivo_arbol: StaticBody2D = null
@onready var deteccion = $Deteccion
@onready var cadencia: Timer = $cadencia
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D 
var rng := RandomNumberGenerator.new()
#movimiento
var estado_actual: estado = estado.Quieto
@export var speed = 100.0
@export var patrol_range = 200.0
@export var pause_time = 2.0
var patrol_target = Vector2.ZERO
var initial_position = Vector2.ZERO
var is_moving = false
@onready var timer = $Timer
func _set_anim(v):
	anim = v

#movimiento 
func _ready():
	#IA
	var random = rng.randf()
	#movimiento
	initial_position = global_position
	choose_patrol_target()
	timer.wait_time = pause_time
	timer.one_shot = true
	is_moving = false
	timer.start()
	#cadencia
	cadencia.wait_time = daño_intervalo
	cadencia.one_shot = false
	cadencia.connect("timeout", Callable(self, "_on_cadencia"))
	cadencia.stop()
	#patrulla
	estado_actual = estado.Quieto 
	_iniciar_pausa_despues_patrullar()
	#señales
	deteccion.connect("body_entered", Callable(self, "_on_detection_body_entered"))
	deteccion.connect("body_exited", Callable(self, "_on_detection_body_exited"))
func _physics_process(delta: float) -> void:
	#IA
	match estado_actual:
		estado.Patrullar:
			_process_patrullar(delta)
		estado.Al_arbol:
			_process_al_arbol(delta)
		estado.Talar:
			velocity = Vector2.ZERO
		estado.Quieto:
			velocity = Vector2.ZERO
	#movimiento
	if is_moving:
		var direction = (patrol_target - global_position).normalized()
		velocity = direction * speed
		if global_position.distance_to(patrol_target) < 10.0:
			velocity = Vector2.ZERO
			is_moving = false
			timer.start()
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
func choose_patrol_target() -> void:
	var random_angle = randf_range(0.0, 2.0 * PI)
	var random_distance = randf_range(50.0, patrol_range)
	patrol_target = initial_position + Vector2(cos(random_angle), sin(random_angle)) * random_distance
func _on_timer_timeout() -> void:
	choose_patrol_target()
	is_moving = true
#maquina de estados"
func _process_patrullar(delta: float) -> void:
	var direccion = patrol_target - global_position
	if direccion.length() < 8.0:
		estado_actual = estado.Quieto
		_iniciar_pausa_despues_patrullar()
		return
	velocity = direccion.normalized() * speed
	_play_anim("caminar")
func _process_al_arbol(delta: float) -> void:
	if not is_instance_valid(objetivo_arbol):
		_cancela_objetivo()
		return
	var direccion = objetivo_arbol.global_position - global_position
	var distancia = direccion.length()
	if distancia <= identificacion_minima:
		estado_actual = estado.Talar
		_play_anim("talar")
		cadencia.start()
		return
	velocity = direccion.normalized() * speed
	_play_anim("caminar")
#deteccion
func _on_deteccion_body_entered(body: Node2D) -> void:
	if body.is_in_group("arboles") and body.has_method("recibir_golpe") and not body.get("ocupado"):
		body.set("ocupado", true)
		if estado_actual == estado.Talar:
			return
		objetivo_arbol = body
		estado_actual = estado.Al_arbol #al otro arbol
		if body.has_signal("caer"):
			body.caer.connect(Callable(self, "_on_arbol_caida"))
func _on_deteccion_body_exited(body: Node2D) -> void:
	if body == objetivo_arbol:
		_cancela_objetivo()
#talar
func on_cadencia_tick () -> void: #se refiere a cada golpe del hacha
	if not is_instance_valid(objetivo_arbol):
		_cancela_objetivo()
		return
	if objetivo_arbol.has_method("recibir_golpe"):
		objetivo_arbol.recibir_golpe(daño)
func _on_arbol_caida(arbol_node: Node) -> void:
	pass #aqui me quede 

func _cancela_objetivo() -> void:
	pass

func _iniciar_pausa_despues_patrullar() -> void:
	pass

func _play_anim(name: String) -> void:
	if anim:
		if anim.animation != name:
			anim.play(name)
