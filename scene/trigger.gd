extends InteractArea




func _on_mouse_enter() -> void:
	scale *= 1.5


func _on_mouse_exit() -> void:
	scale /= 1.5
