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

	if not timer:
		var new_timer = Timer.new()
		new_timer.name = "Timer"
		add_child(new_timer)
		timer = new_timer
	timer.wait_time = pause_time
	timer.one_shot = true
	timer.connect("timeout", _on_timer_timeout)

	is_moving = false
	timer.start()

func _physics_process(delta):
	if is_moving:

		var direction = (patrol_target - global_position).normalized()
		velocity = direction * speed
		

		if global_position.distance_to(patrol_target) < 10:
			velocity = Vector2.ZERO
			is_moving = false
			timer.start()
	else:

		velocity = Vector2.ZERO

	move_and_slide()

func choose_patrol_target():
	var random_angle = randf_range(0, 2 * PI)
	var random_distance = randf_range(50, patrol_range)
	patrol_target = initial_position + Vector2(cos(random_angle), sin(random_angle)) * random_distance

func _on_timer_timeout():
	choose_patrol_target()
	is_moving = true
