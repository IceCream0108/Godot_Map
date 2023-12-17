extends Node2D

var path = null


enum State {
	IDLE,
	LIST,
	INTRO,
	DETAIL,
	DRAGGING_MAP,
	DRAGGING_LIST
}

enum Detail {
	FEIXIAN,
	JUNANXIAN,
	MENGYINXIAN,
	PINGYIXIAN,
	LANLINGXIAN,
	LINSHUXIAN,
	RIZHAOSHI,
	SISHUIXIAN,
	YANCHENGXIAN,
	YISHUIXIAN,
	ZAOZHUANGSHI,
	LINYISHI,
	YINANXIAN,
}

var current_detail = null:
	set(v):
		current_detail = v
		_change_intro_label()
		_change_intro_texture()

@onready var intro_canvas_layer: CanvasLayer = $IntroCanvasLayer
@onready var intro_texture_rect: TextureRect = $IntroCanvasLayer/IntroPanel/HBoxContainer/TextureRect
@onready var intro_label: Label = $IntroCanvasLayer/IntroPanel/HBoxContainer/Label


@onready var list_canvas_layer: CanvasLayer = $ListCanvasLayer
@onready var state_machine: StateMachine = $StateMachine
@onready var camera_2d: Camera2D = $Camera2D
@onready var click_wait_timer: Timer = $ClickWaitTimer

@onready var viewport = get_viewport()
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var on_map := false
var on_headline := false
var on_trigger := false

var dragging_area := -1
var drag_start := Vector2()

var click_area := -1
var trigger_position := Vector2()

var pressing := false
var to_detail := false
var detach_detail := false

var real_detail


func tick(state: State, delta: float) -> void:
	print(state, ", ",current_detail)
	match state:
		State.IDLE:
			#intro_canvas_layer.offset.y = viewport.get_visible_rect().size.y-160
			intro_canvas_layer.offset.y = clamp(intro_canvas_layer.offset.y + 20, viewport.get_visible_rect().size.y-160, viewport.get_visible_rect().size.y)
			if intro_canvas_layer.offset.y == viewport.get_visible_rect().size.y:
				if list_canvas_layer.offset.y > viewport.get_visible_rect().size.y-128:
					list_canvas_layer.offset.y = clampf(list_canvas_layer.offset.y - 20, viewport.get_visible_rect().size.y-128, viewport.get_visible_rect().size.y)
				else:
					list_canvas_layer.offset.y = clampf(list_canvas_layer.offset.y + 20, 100, viewport.get_visible_rect().size.y-128)
		State.LIST:
			list_canvas_layer.offset.y = clampf(list_canvas_layer.offset.y - 20, 100, viewport.get_visible_rect().size.y-128)
		State.INTRO:
			list_canvas_layer.offset.y = clampf(list_canvas_layer.offset.y + 20, viewport.get_visible_rect().size.y-128, viewport.get_visible_rect().size.y)
			if list_canvas_layer.offset.y == viewport.get_visible_rect().size.y:
				intro_canvas_layer.offset.y = clamp(intro_canvas_layer.offset.y - 20, viewport.get_visible_rect().size.y-160, viewport.get_visible_rect().size.y)
		State.DETAIL:
			pass
		State.DRAGGING_MAP:
			pass
		State.DRAGGING_LIST:
			pass
	
func get_next_state(state: State) -> int:
	match state:
		State.IDLE:
			if dragging_area == 0:
				return State.DRAGGING_MAP
			elif dragging_area == 1:
				return State.DRAGGING_LIST
			if click_area == 2:
				return State.INTRO
		State.LIST:
			if dragging_area == 1:
				return State.DRAGGING_LIST
			if to_detail:
				return State.DETAIL
		State.INTRO:
			if dragging_area == 0:
				return State.DRAGGING_MAP
			if click_area == 0:
				return State.IDLE
			if to_detail:
				return State.DETAIL
		State.DETAIL:
			if detach_detail:
				return State.IDLE
		State.DRAGGING_MAP:
			if dragging_area == -1:
				return State.IDLE
		State.DRAGGING_LIST:
			if dragging_area == -1:
				if list_canvas_layer.offset.y < viewport.get_visible_rect().size.y / 2:
					return State.LIST
				else:
					return State.IDLE
	return StateMachine.KEEP_CURRENT
	
func transition_state(from : State, to: State) -> void:
	print("[%s] %s => %s" % [
		Engine.get_physics_frames()	,
		State.keys()[from] if from != -1 else "<START>",
		State.keys()[to],
	])

	match to:
		State.IDLE:
			if detach_detail:
				match real_detail:
					Detail.FEIXIAN:
						$Details/DetailFeiXian.change = true
					Detail.JUNANXIAN:
						$Details/DetailJuNanXian.change = true
					Detail.MENGYINXIAN:
						$Details/DetailMengYinXian.change = true
					Detail.PINGYIXIAN:
						$Details/DetailPingYiXian.change = true
					Detail.LANLINGXIAN:
						$Details/DetailLanLinXian.change = true
					Detail.LINSHUXIAN:
						$Details/DetailLinShuXian.change = true
					Detail.RIZHAOSHI:
						$Details/DetailRiZhaoShi.change = true
					Detail.SISHUIXIAN:
						$Details/DetailPageSiShuiXian.change = true
					Detail.YANCHENGXIAN:
						$Details/DetailYanChengXian.change = true
					Detail.YISHUIXIAN:
						$Details/DetailYiShuiXian.change = true
					Detail.ZAOZHUANGSHI:
						$Details/DetailZaoZhuangShi.change = true
					Detail.LINYISHI:
						$Details/DetailLinYiShi.change = true
					Detail.YINANXIAN:
						$Details/DetailYiNanXian.change = true
				current_detail = null
				detach_detail = false
		State.LIST:
			pass
		State.INTRO:
			pass
		State.DETAIL:
			real_detail = current_detail
			match real_detail:
				Detail.FEIXIAN:
					$Details/DetailFeiXian.change = true
				Detail.JUNANXIAN:
					$Details/DetailJuNanXian.change = true
				Detail.MENGYINXIAN:
					$Details/DetailMengYinXian.change = true
				Detail.PINGYIXIAN:
					$Details/DetailPingYiXian.change = true
				Detail.LANLINGXIAN:
					$Details/DetailLanLinXian.change = true
				Detail.LINSHUXIAN:
					$Details/DetailLinShuXian.change = true
				Detail.RIZHAOSHI:
					$Details/DetailRiZhaoShi.change = true
				Detail.SISHUIXIAN:
					$Details/DetailPageSiShuiXian.change = true
				Detail.YANCHENGXIAN:
					$Details/DetailYanChengXian.change = true
				Detail.YISHUIXIAN:
					$Details/DetailYiShuiXian.change = true
				Detail.ZAOZHUANGSHI:
					$Details/DetailZaoZhuangShi.change = true
				Detail.LINYISHI:
					$Details/DetailLinYiShi.change = true
				Detail.YINANXIAN:
					$Details/DetailYiNanXian.change = true
			to_detail = false
		State.DRAGGING_MAP:
			pass
		State.DRAGGING_LIST:
			pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not to_detail:
			if event.pressed:
				pressing = true
				click_wait_timer.start()
			else:
				pressing = false
				if not click_wait_timer.is_stopped() and dragging_area == -1:
					click_area = _mouse_priority_judgement()
					if state_machine.current_state == State.IDLE or state_machine.current_state == State.INTRO:
						camera_2d.position = trigger_position
						camera_2d.position_smoothing_enabled = true
					if state_machine.current_state == State.LIST:
						if current_detail != null:
							to_detail = true
				dragging_area = -1
	elif event is InputEventMouseMotion:
		if pressing:
			dragging_area = _mouse_priority_judgement()
			click_area = -1
		var drag_delta = drag_start - event.position
		if state_machine.current_state == State.DRAGGING_MAP:
			camera_2d.position_smoothing_enabled = false
			camera_2d.position += drag_delta
			camera_2d.position_smoothing_enabled = false
		elif state_machine.current_state == State.DRAGGING_LIST:
			list_canvas_layer.offset.y -= drag_delta.y
		drag_start = event.position

func _mouse_priority_judgement() -> int:
	if on_headline:
		return 1
	if on_trigger:
		return 2
	return 0





func _change_intro_label() -> void:
	match current_detail:
		Detail.FEIXIAN:
			intro_label.text = " 费 县"
		Detail.JUNANXIAN:
			intro_label.text = " 莒南县"
		Detail.MENGYINXIAN:
			intro_label.text = " 蒙阴县"
		Detail.PINGYIXIAN:
			intro_label.text = " 平邑县"
		Detail.LANLINGXIAN:
			intro_label.text = " 兰陵县"
		Detail.LINSHUXIAN:
			intro_label.text = " 临沭县"
		Detail.RIZHAOSHI:
			intro_label.text = " 日照市"
		Detail.SISHUIXIAN:
			intro_label.text = " 泗水县"
		Detail.YANCHENGXIAN:
			intro_label.text = " 郯城县"
		Detail.YISHUIXIAN:
			intro_label.text = " 沂水县"
		Detail.ZAOZHUANGSHI:
			intro_label.text = " 枣庄市"
		Detail.LINYISHI:
			intro_label.text = " 临沂市"
		Detail.YINANXIAN:
			intro_label.text = " 沂南县"

			
func _change_intro_texture() -> void:
	match current_detail:
		Detail.FEIXIAN:
			intro_texture_rect.texture = load("res://main/assets/texture/feixian/景点图片/大青山胜利突围纪念馆2.jpeg")
		Detail.MENGYINXIAN:
			intro_texture_rect.texture = load("res://main/assets/texture/mengyin/蒙阴景点图片/微信图片_202310261309023.jpg")
		Detail.PINGYIXIAN:
			intro_texture_rect.texture = load("res://main/assets/texture/pingyi/平邑景点图片/微信图片_202310261335468.jpg")
		Detail.JUNANXIAN:
			intro_texture_rect.texture = load("res://main/assets/texture/lvnan/图片1.png")
		Detail.LANLINGXIAN:
			intro_texture_rect.texture = load("res://main/assets/texture/lanlin/图片1.png")
		Detail.LINSHUXIAN:
			intro_texture_rect.texture = load("res://main/assets/texture/linchu/滨海红色文化纪念园.png")
		Detail.RIZHAOSHI:
			intro_texture_rect.texture = load("res://main/assets/texture/rizhao/与会人员合影（前排右一为罗荣桓）.png")
		Detail.SISHUIXIAN:
			intro_texture_rect.texture = load("res://main/assets/texture/sishui/景点图片/微信图片_202310291652142.jpg")
		Detail.YANCHENGXIAN:
			intro_texture_rect.texture = load("res://main/assets/texture/yancheng/图片1.png")
		Detail.YISHUIXIAN:
			intro_texture_rect.texture = load("res://main/assets/texture/yishui/风景图片/沂水图片.jpeg")
		Detail.ZAOZHUANGSHI:
			intro_texture_rect.texture = load("res://main/assets/texture/zaozhuang/台儿庄区/台儿庄大战纪念馆01.png")
		Detail.LINYISHI:
			intro_texture_rect.texture = load("res://main/assets/texture/linyi/兰山区1.png")
		Detail.YINANXIAN:
			intro_texture_rect.texture = load("res://main/assets/texture/yinan/红色景点4.png")




func _on_map_iteract_area_mouse_enter() -> void:
	on_map = true

func _on_map_iteract_area_mouse_exit() -> void:
	on_map = false

func _on_head_line_iteract_area_mouse_enter() -> void:
	on_headline = true

func _on_head_line_iteract_area_mouse_exit() -> void:
	on_headline = false
	
	
	
# ___________________________________________________________
func _on_intro_button_button_down() -> void:
	to_detail = true
	

# ********************************************************* #
# Inrto_2_Detail
func _on_费县_mouse_entered() -> void:
	current_detail = Detail.FEIXIAN
func _on_莒南县_mouse_entered() -> void:
	current_detail = Detail.JUNANXIAN
func _on_蒙阴_mouse_entered() -> void:
	current_detail = Detail.MENGYINXIAN
func _on_平邑县_mouse_entered() -> void:
	current_detail = Detail.PINGYIXIAN
func _on_兰陵县_mouse_entered() -> void:
	current_detail = Detail.LANLINGXIAN
func _on_临沭县_mouse_entered() -> void:
	current_detail = Detail.LINSHUXIAN
func _on_日照市_mouse_entered() -> void:
	current_detail = Detail.RIZHAOSHI
func _on_泗水县_mouse_entered() -> void:
	current_detail = Detail.SISHUIXIAN
func _on_郯城县_mouse_entered() -> void:
	current_detail = Detail.YANCHENGXIAN
func _on_沂水县_mouse_entered() -> void:
	current_detail = Detail.YISHUIXIAN
func _on_枣庄市_mouse_entered() -> void:
	current_detail = Detail.ZAOZHUANGSHI
func _on_临沂市_mouse_entered() -> void:
	current_detail = Detail.LINYISHI
func _on_沂南县_mouse_entered() -> void:
	current_detail = Detail.YINANXIAN
	
	

	
# ********************************************************* #
func _on_trigger_fei_xian_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.FEIXIAN
	trigger_position = $Triggers/TriggerFeiXian.position
func _on_trigger_fei_xian_mouse_exit() -> void:
	on_trigger = false

func _on_trigger_ju_nan_xian_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.JUNANXIAN
	trigger_position = $Triggers/TriggerJuNanXian.position
func _on_trigger_ju_nan_xian_mouse_exit() -> void:
	on_trigger = false
	
func _on_trigger_meng_yin_xian_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.MENGYINXIAN
	trigger_position = $Triggers/TriggerMengYinXian.position
func _on_trigger_meng_yin_xian_mouse_exit() -> void:
	on_trigger = false
	
func _on_trigger_ping_yi_xian_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.PINGYIXIAN
	trigger_position = $Triggers/TriggerPingYiXian.position
func _on_trigger_ping_yi_xian_mouse_exit() -> void:
	on_trigger = false
	
func _on_trigger_lan_ling_xian_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.LANLINGXIAN
	trigger_position = $Triggers/TriggerLanLingXian.position
func _on_trigger_lan_ling_xian_mouse_exit() -> void:
	on_trigger = false

func _on_trigger_lin_shui_xian_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.LINSHUXIAN
	trigger_position = $Triggers/TriggerLinShuXian.position
func _on_trigger_lin_shui_xian_mouse_exit() -> void:
	on_trigger = false

func _on_trigger_ri_zhao_xian_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.RIZHAOSHI
	trigger_position = $Triggers/TriggerRiZhaoXian.position
func _on_trigger_ri_zhao_xian_mouse_exit() -> void:
	on_trigger = false

func _on_trigger_si_shui_xian_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.SISHUIXIAN
	trigger_position = $Triggers/TriggerSiShuiXian.position
func _on_trigger_si_shui_xian_mouse_exit() -> void:
	on_trigger = false

func _on_trigger_yan_cheng_xian_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.YANCHENGXIAN
	trigger_position = $Triggers/TriggerYanChengXian.position
func _on_trigger_yan_cheng_xian_mouse_exit() -> void:
	on_trigger = false

func _on_trigger_yi_shui_xian_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.YISHUIXIAN
	trigger_position = $Triggers/TriggerYiShuiXian.position
func _on_trigger_yi_shui_xian_mouse_exit() -> void:
	on_trigger = false

func _on_trigger_zao_zhuang_shi_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.ZAOZHUANGSHI
	trigger_position = $Triggers/TriggerZaoZhuangShi.position
func _on_trigger_zao_zhuang_shi_mouse_exit() -> void:
	on_trigger = false

func _on_trigger_lin_yi_shi_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.LINYISHI
	trigger_position = $Triggers/TriggerLinYiShi.position
func _on_trigger_lin_yi_shi_mouse_exit() -> void:
	on_trigger = false
	
func _on_trigger_yi_nan_xian_mouse_enter() -> void:
	on_trigger = true
	current_detail = Detail.YINANXIAN
	trigger_position = $Triggers/TriggerYiNanXian.position
func _on_trigger_yi_nan_xian_mouse_exit() -> void:
	on_trigger = false

# ********************************************************* #
func _on_detail_fei_xian_detach() -> void:
	detach_detail = true
func _on_detail_ju_nan_xian_detach() -> void:
	detach_detail = true
func _on_detail_meng_yin_xian_detach() -> void:
	detach_detail = true
func _on_detail_ping_yi_xian_detach() -> void:
	detach_detail = true
func _on_detail_lan_lin_xian_detach() -> void:
	detach_detail = true
func _on_detail_lin_shu_xian_detach() -> void:
	detach_detail = true
func _on_detail_ri_zhao_shi_detach() -> void:
	detach_detail = true
func _on_detail_page_si_shui_xian_detach() -> void:
	detach_detail = true
func _on_detail_yan_cheng_xian_detach() -> void:
	detach_detail = true
func _on_detail_yi_shui_xian_detach() -> void:
	detach_detail = true
func _on_detail_zao_zhuang_shi_detach() -> void:
	detach_detail = true
func _on_detail_lin_yi_shi_detach() -> void:
	detach_detail = true
func _on_detail_yi_nan_xian_detach() -> void:
	detach_detail = true
