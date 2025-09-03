extends StaticBody2D

@export var cofre_abierto: Texture2D
@export var drop_escene: PackedScene 
var abierto = false

func abrir_cofre() -> void:
	var aleatorio = randi_range(1, 50)
	if abierto:
		return
	if drop_escene:
		for i in range(aleatorio):
			var dinero = drop_escene.instantiate()
			var x = randf_range(10, -10)
			var y = randf_range(-10, 10)
			dinero.position = position + Vector2(x, y)
			get_parent().add_child(dinero)
			abierto = true
func _process(delta: float) -> void:
	if abierto:
		$Sprite2D.texture = cofre_abierto
func _ready() -> void:
	Global.connect("interactuar", Callable(self, "abrir_cofre"))
