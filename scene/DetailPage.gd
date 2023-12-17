extends CanvasLayer
class_name DetailPage



@export var ID: String

@onready var viewport = get_viewport()
@onready var detail_page: DetailPage = $"."

@onready var back_ground_canvas_layer: CanvasLayer = $BackGroundCanvasLayer
@onready var title_canvas_layer: CanvasLayer = $TitleCanvasLayer
#Title
@onready var title_panel: Panel = $TitleCanvasLayer/TitleHBoxContainer/TitlePanel
@onready var title_h_box_container: HBoxContainer = $TitleCanvasLayer/TitleHBoxContainer
@onready var title_label: Label = $TitleCanvasLayer/TitleHBoxContainer/TitlePanel/TitleLabel

# Imgs
@onready var imgs: Panel = $ScrollContainer/WholeVBoxContainer/Imgs
@onready var img_grid_container: GridContainer = $ScrollContainer/WholeVBoxContainer/Imgs/ImgGridContainer

@onready var scroll_container: ScrollContainer = $ScrollContainer

@onready var width = viewport.get_visible_rect().size.x
@onready var height = viewport.get_visible_rect().size.y

var img_delta := 0.0
var speed := 30
var mouse_on_img_grid_container := false
var dragging := false
var drag_start = Vector2()

var change := false
var show := false

var X_offset: float:
	set(v):
		back_ground_canvas_layer.offset.x = v
		title_canvas_layer.offset.x = v
		detail_page.offset.x = v
		X_offset = v
		

signal detach


func _ready() -> void:
	img_grid_container.size.x = width * img_grid_container.columns
	img_grid_container.size.y = imgs.custom_minimum_size.y
	X_offset = viewport.get_visible_rect().size.x
	#X_offset = 0
	
func _process(delta: float) -> void:
	# Title
	var scroll_v := scroll_container.scroll_vertical
	if scroll_v <= height:
		title_panel.modulate.a = 0
	else:
		var coeff = clampf((scroll_v-height)/(400.0-height), 0, 1)
		title_panel.modulate.a = lerpf(0, 1, coeff)
		
	# Img Switch
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
			
	if change and show:
		X_offset = clampf(X_offset + 20, 0, viewport.get_visible_rect().size.x)
		if X_offset == viewport.get_visible_rect().size.x:
			show = false
			change = false
			
	if change and not show:
		X_offset = clampf(X_offset - 20, 0, viewport.get_visible_rect().size.x)
		if X_offset == 0.0:
			show = true
			change = false
	
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

# 取整数函数		
func _f2i(a: float) -> int:
	return int(a) if a - int(a) < 0.5 else int(a) + 1
	


func _on_img_grid_container_mouse_entered() -> void:
	if not dragging:
		mouse_on_img_grid_container = true

func _on_img_grid_container_mouse_exited() -> void:
	if not dragging:
		mouse_on_img_grid_container = false


func _on_detach_button_pressed() -> void:
	detach.emit()
