extends CharacterBody2D

@export var speed = 120
@export var daño: int = 1
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
