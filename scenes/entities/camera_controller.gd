extends Node3D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:

		rotation_degrees.y -= event.relative.x
		rotation_degrees.x -= event.relative.y
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
