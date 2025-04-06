extends Camera2D

class_name Camera

var shake_amount = 0
@onready var shakeTimer = $Timer

var default_offset = offset

func _ready() -> void:
	set_process(false)
	Global.camera = self

func _process(delta):
	offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(shake_amount, -shake_amount)) * delta + default_offset

func shake(newShake, shakeTime=0.4, shakeLimit=300):
	var tween = create_tween().bind_node(self)
	shake_amount += newShake
	if shake_amount > shakeLimit:
		shake_amount = shakeLimit
	shakeTimer.wait_time = shakeTime
	tween.stop()
	set_process(true)
	shakeTimer.start()

func _on_timer_timeout():
	var tween = create_tween().bind_node(self)
	shake_amount = 0
	set_process(false)
	tween.tween_property(self, "offset", offset, 0.1)
	tween.play()
	offset = default_offset
	shake(1)

func zoomTo(pos : Vector2, needZoom : Vector2):
	var posTween = create_tween().bind_node(self)
	var zoomTween = create_tween().bind_node(self)
	posTween.tween_property(self, "position", pos, 0.3)
	zoomTween.tween_property(self, "zoom", needZoom, 0.3)
	posTween.play()
	zoomTween.play()
