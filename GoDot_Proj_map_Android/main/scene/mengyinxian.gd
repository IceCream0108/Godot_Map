extends CanvasLayer

@onready var img_grid_container: GridContainer = $ScrollContainer/VBoxContainer/Panel/ImgGridContainer
@onready var music_1_audio_stream_player: AudioStreamPlayer = $ScrollContainer/VBoxContainer/VBoxContainer/Music1/Music1AudioStreamPlayer
@onready var music_2_audio_stream_player: AudioStreamPlayer = $ScrollContainer/VBoxContainer/VBoxContainer/Music2/Music2AudioStreamPlayer
@onready var music_3_audio_stream_player: AudioStreamPlayer = $ScrollContainer/VBoxContainer/VBoxContainer/Music3/Music3AudioStreamPlayer
@onready var music_4_audio_stream_player: AudioStreamPlayer = $ScrollContainer/VBoxContainer/VBoxContainer/Music4/Music4AudioStreamPlayer
@onready var music_5_audio_stream_player: AudioStreamPlayer = $ScrollContainer/VBoxContainer/VBoxContainer/Music5/Music5AudioStreamPlayer
@onready var music_6_audio_stream_player: AudioStreamPlayer = $ScrollContainer/VBoxContainer/VBoxContainer/Music6/Music6AudioStreamPlayer

@onready var panel: Panel = $TitleCanvasLayer/Panel

@onready var scroll_container: ScrollContainer = $ScrollContainer

@onready var viewport = get_viewport()

var mouse_on_img_grid_container := false
var dragging := false
var drag_start = Vector2()
@onready var Panel_theme = Theme.new()

var img_delta := 0.0
var speed := 30

var height := 200

signal detach

func _ready() -> void:
	img_grid_container.size.x = img_grid_container.columns * viewport.get_visible_rect().size.x

	
func _process(delta: float) -> void:
	var scroll_v := scroll_container.scroll_vertical
	if scroll_v <= height:
		panel.modulate.a = 0
	else:
		var coeff = clampf((scroll_v-height)/(400.0-height), 0, 1)
		panel.modulate.a = lerpf(0, 1, coeff)
		
	
	if img_delta > 0:
		img_delta -= speed
		if img_delta > 0:
			img_grid_container.position.x += speed
		else:
			img_grid_container.position.x += img_delta + speed
			img_delta = 0.0
	elif img_delta < 0:
		img_delta += speed
		if img_delta < 0:
			img_grid_container.position.x -= speed
		else:
			img_grid_container.position.x += img_delta - speed
			img_delta = 0.0
			

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_start = event.position
			else:
				dragging = false
				var index := _f2i(abs(img_grid_container.position.x) / viewport.get_visible_rect().size.x)
				img_delta = -index * viewport.get_visible_rect().size.x - img_grid_container.position.x
				
				
				

			
	elif event is InputEventMouseMotion:
		var drag_delta = drag_start - event.position
		if dragging:
			if mouse_on_img_grid_container:
				img_grid_container.position.x -= drag_delta.x
				img_grid_container.position.x = clampf(img_grid_container.position.x, -viewport.get_visible_rect().size.x * (img_grid_container.columns - 1), 0)
		drag_start = event.position




func _on_img_grid_container_mouse_entered() -> void:
	if not dragging:
		mouse_on_img_grid_container = true
	



func _on_img_grid_container_mouse_exited() -> void:
	if not dragging:
		mouse_on_img_grid_container = false
	
	
func _f2i(a: float) -> int:
	return int(a) if a - int(a) < 0.5 else int(a) + 1



func _on_music_1_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		music_1_audio_stream_player.play()
	else:
		music_1_audio_stream_player.playing = false
		
func _on_music_2_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		music_2_audio_stream_player.play()
	else:
		music_2_audio_stream_player.playing = false
		
func _on_music_3_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		music_3_audio_stream_player.play()
	else:
		music_3_audio_stream_player.playing = false

func _on_music_4_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		music_4_audio_stream_player.play()
	else:
		music_4_audio_stream_player.playing = false

func _on_music_5_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		music_5_audio_stream_player.play()
	else:
		music_5_audio_stream_player.playing = false

func _on_music_6_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		music_6_audio_stream_player.play()
	else:
		music_6_audio_stream_player.playing = false

func _on_button_pressed() -> void:
	detach.emit()


