extends CharacterBody2D
@export var speed = 100.0
@export var patrol_range = 200.0
@export var pause_time = 2.0

var patrol_target = Vector2.ZERO
var initial_position = Vector2.ZERO
var is_moving = false

@onready var timer = $Timer

func _ready():
	initial_position = global_position
	choose_patrol_target()
	timer.wait_time = pause_time
	timer.one_shot = true
	is_moving = false
	timer.start()
func _physics_process(delta: float) -> void:
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
