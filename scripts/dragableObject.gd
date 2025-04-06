extends TextureRect

class_name DragableObject

enum{
	IN_CURSOR,
	IN_SLOT,
}

@onready var dragPos = position
var offset = Vector2.ZERO
var mouseInside = false

var state = IN_SLOT

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
func _process(_delta: float) -> void:
	match state:
		IN_CURSOR:
			global_position = get_global_mouse_position() + offset

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if mouseInside:
				state = IN_CURSOR
				offset = global_position - event.position
				if self is CharacterCard:
					Global.main.targetChoosen.emit(self)
		elif event.is_released():
			if state == IN_CURSOR:
				get_parent().locateObjects()
				state = IN_SLOT
				moveTo()

func moveTo():
	var tween = create_tween().bind_node(self)
	tween.tween_property(self,"position", dragPos,0.1)
	tween.play()

func _is_point_inside_button_area(point: Vector2) -> bool:
	var x: bool = point.x >= global_position.x and point.x <= global_position.x + (size.x * get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= global_position.y and point.y <= global_position.y + (size.y * get_global_transform_with_canvas().get_scale().y)
	return x and y


func _on_mouse_entered() -> void:
	mouseInside = true


func _on_mouse_exited() -> void:
	mouseInside = false
