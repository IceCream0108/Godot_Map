extends Area2D
class_name  InteractArea

signal Mouse_Pressed
signal Mouse_Released
signal Mouse_Enter
signal Mouse_Exit


var mouse_on := false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if mouse_on:
			if event.is_pressed():
				Mouse_Pressed.emit()
			else:
				Mouse_Released.emit()


func _on_mouse_entered() -> void:
	Mouse_Enter.emit()
	mouse_on = true


func _on_mouse_exited() -> void:
	Mouse_Exit.emit()
	mouse_on = false
