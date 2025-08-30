extends CharacterBody2D

# Estados del esqueleto
enum estado {
	Quieto,
	Patrullar,
	A_la_piedra,
	Minar
}

# Propiedades de IA
@export var identificacion_minima: float = 30.0
@export var daño: int = 1
@export var daño_intervalo: float = 0.5
var objetivo_piedra: Node2D = null
@onready var deteccion = $Deteccion
@onready var cadencia: Timer = $cadencia 
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D 
var rng := RandomNumberGenerator.new()      # Generador de números aleatorios

# Propiedades de movimiento
var estado_actual: estado = estado.Quieto       # Estado inicial
@export var speed = 80.0
@export var patrol_range = 180.0 
@export var pause_time = 3.0 
var patrol_target = Vector2.ZERO
var initial_position = Vector2.ZERO
var is_moving = false
@onready var timer = $Timer


func _set_anim(v):
	anim = v

# Configuración inicial
func _ready():
	initial_position = global_position  # Guarda posición inicial
	_selecciona_objetivo()             # Selecciona un punto de patrulla
	timer.wait_time = pause_time       # Configura pausa
	timer.one_shot = true              # Temporizador de un solo disparo
	is_moving = false                  # No se mueve al inicio
	timer.start()                      # Inicia temporizador
	cadencia.wait_time = daño_intervalo  # Configura intervalo de golpes
	cadencia.one_shot = false          # Temporizador repetitivo
	cadencia.connect("timeout", Callable(self, "_on_cadencia_tick"))  # Conecta señal
	cadencia.stop()                    # Detiene cadencia hasta minar
	estado_actual = estado.Quieto      # Estado inicial
	_iniciar_pausa_despues_patrullar() # Inicia pausa antes de patrullar
	# Conecta señales de detección
	deteccion.connect("body_entered", Callable(self, "_on_deteccion_body_entered"))
	deteccion.connect("body_exited", Callable(self, "_on_deteccion_body_exited"))

# Procesa física y movimiento cada frame
func _physics_process(delta: float) -> void:
	# Ejecuta lógica según el estado
	match estado_actual:
		estado.Patrullar:
			_process_patrullar(delta)
		estado.A_la_piedra:
			_process_a_la_piedra(delta)
		estado.Minar:
			velocity = Vector2.ZERO  # Sin movimiento al minar
		estado.Quieto:
			velocity = Vector2.ZERO  # Sin movimiento al estar quieto
	
	# Mueve hacia el punto de patrulla solo si está patrullando
	if is_moving and estado_actual == estado.Patrullar:
		var direction = (patrol_target - global_position).normalized()
		velocity = direction * speed
		if global_position.distance_to(patrol_target) < 10.0:
			velocity = Vector2.ZERO
			is_moving = false
			timer.start()
	
	move_and_slide()

# Maneja el temporizador de pausa
func _on_timer_timeout() -> void:
	if estado_actual == estado.Quieto:
		_selecciona_objetivo()
		is_moving = true
		estado_actual = estado.Patrullar

# Procesa el estado Patrullar
func _process_patrullar(delta: float) -> void:
	var direccion = patrol_target - global_position
	if direccion.length() < 8.0:  # Si está cerca del objetivo
		estado_actual = estado.Quieto
		_iniciar_pausa_despues_patrullar()
		return
	velocity = direccion.normalized() * speed
	_play_anim("Patrullar")  # Reproduce animación de caminar

# Procesa el estado A_la_piedra
func _process_a_la_piedra(delta: float) -> void:
	if not is_instance_valid(objetivo_piedra):  # Verifica si la piedra es válida
		_cancela_objetivo()
		return
	var direccion = objetivo_piedra.global_position - global_position
	var distancia = direccion.length()
	if distancia <= identificacion_minima:  # Si está cerca, empieza a minar
		velocity = Vector2.ZERO  # Detiene el movimiento
		estado_actual = estado.Minar
		_play_anim("Minar")
		cadencia.start()
		return
	velocity = direccion.normalized() * speed
	_play_anim("Patrullar")  # Reproduce animación de caminar

# Detecta cuando una piedra entra en el área
func _on_deteccion_body_entered(body: Node2D) -> void:
	if body.is_in_group("piedras") and body.has_method("recibir_golpe") and not body.get("ocupado"):
		body.set("ocupado", true)  # Marca la piedra como ocupada
		if estado_actual == estado.Minar:
			return
		objetivo_piedra = body  # Asigna la piedra como objetivo
		is_moving = false  # Desactiva movimiento de patrulla
		estado_actual = estado.A_la_piedra
		if body.has_signal("destruir"):
			body.connect("destruir", Callable(self, "_on_piedra_destruida"))  # Conecta señal

# Detecta cuando una piedra sale del área
func _on_deteccion_body_exited(body: Node2D) -> void:
	# Solo cancela si no está minando
	if body == objetivo_piedra and estado_actual != estado.Minar:
		_cancela_objetivo()

# Aplica daño a la piedra en cada tick de cadencia
func _on_cadencia_tick() -> void:
	if not is_instance_valid(objetivo_piedra):
		_cancela_objetivo()
		return
	if objetivo_piedra.has_method("recibir_golpe"):
		objetivo_piedra.recibir_golpe(daño)
	else:
		_cancela_objetivo()  # Cancela si la piedra no puede recibir golpes

# Maneja la destrucción de una piedra
func _on_piedra_destruida(piedra_node: Node) -> void:
	_cancela_objetivo()
	estado_actual = estado.Quieto
	await get_tree().create_timer(0.3).timeout  # Espera breve
	_selecciona_objetivo()
	estado_actual = estado.Patrullar

# Selecciona un nuevo punto de patrulla aleatorio
func _selecciona_objetivo():
	var angle = rng.randf_range(0.0, TAU)  # TAU = 2π
	var distancia = rng.randf_range(40.0, patrol_range)
	patrol_target = initial_position + Vector2(cos(angle), sin(angle)) * distancia

# Inicia una pausa antes de patrullar
func _iniciar_pausa_despues_patrullar() -> void:
	await get_tree().create_timer(pause_time).timeout
	if estado_actual == estado.Quieto:
		_selecciona_objetivo()
		estado_actual = estado.Patrullar

# Cancela el objetivo actual (piedra)
func _cancela_objetivo() -> void:
	if is_instance_valid(objetivo_piedra) and objetivo_piedra.has_signal("destruir"):
		if objetivo_piedra.is_connected("destruir", Callable(self, "_on_piedra_destruida")):
			objetivo_piedra.disconnect("destruir", Callable(self, "_on_piedra_destruida"))
		if objetivo_piedra.has_method("set"):
			objetivo_piedra.set("ocupado", false)
	objetivo_piedra = null
	cadencia.stop()
	_play_anim("Quieto")
	_selecciona_objetivo()
	estado_actual = estado.Patrullar

# Reproduce una animación
func _play_anim(name: String) -> void:
	if anim:
		if anim.animation != name:
			anim.play(name)
