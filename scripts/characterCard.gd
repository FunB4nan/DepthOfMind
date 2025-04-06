extends DragableObject

class_name CharacterCard

signal actionChoosen
signal attacked

const buttonSize = 70
const maxAmountOfChips = 3

@export var maxHp : int = 10
@onready var hp : int = maxHp
@export var dmg : int = 1
@export var actions : Array[String]
@export var title : String = "Depression"
@export var actionRepeats : int = 1

var chips : Array[Chip]
var actionButtons : Array[ActionButton] = []

var startPos = Vector2.ZERO
@onready var defaultStats = {
	"hp" : maxHp,
	"dmg" : dmg,
	"repeats" : actionRepeats
}

func _ready() -> void:
	super()
	for action in actions:
		addAction(action)
	if get_parent().name == "enemies":
		$action.text = title
	update()
	await get_tree().create_timer(0.1).timeout
	$appear.play()
	$statusAnim.play("appear")
	await $statusAnim.animation_finished
	%shadowCreature.texture = $creature.texture
	%shadowCreature.size = $creature.size
	await get_tree().create_timer(randf_range(0,1)).timeout
	$anim.play("idle")

func drop():
	$anim.play("drop")
	await $anim.animation_finished
	$anim.play("idle")

func myTurn():
	$action.text = ""
	var numOfActions = actionButtons.size()
	for action in $actions.get_children():
		action.queue_free()
	for i in range(0,numOfActions):
		var actionButton = ActionButton.new()
		actionButton.actionName = actionButtons[i].actionName
		actionButton.initialPos = Vector2(-50,-60 - (numOfActions - i - 1) * buttonSize)
		add_child(actionButton)
	await actionChoosen
	for action in get_children():
		if action is ActionButton:
			action.hideMe()
	await get_tree().create_timer(0.3).timeout
	if $actions.get_child(0).needOneTarget:
		$actions.get_child(0).target = await Global.main.chooseTarget(self)
	$action.text = $actions.get_child(0).name
	get_parent().nextCard()

func addAction(t : String):
	var button = ActionButton.new()
	button.actionName = t
	actionButtons.append(button)

func toTarget(target : CharacterCard):
	startPos = $creature.global_position
	var tween = create_tween().bind_node(self)
	var direction = int(startPos.y >= target.global_position.y) * 2 - 1
	var targetPos = target.get_node("creature").global_position
	tween.tween_property($creature, "global_position", targetPos + Vector2(0,50) * direction, 0.3)
	tween.play()
	Global.camera.zoomTo(target.global_position, Vector2(1.5,1.5))
	await tween.finished
	$anim.play("punch")
	return await $anim.animation_finished
	

func fromTarget():
	$anim.play("idle")
	var tween = create_tween().bind_node(self)
	tween.tween_property($creature, "global_position", startPos, 0.5)
	tween.play()
	Global.camera.zoomTo(Vector2(640,360), Vector2(1,1))
	return await tween.finished

func reset():
	maxHp = defaultStats["hp"]
	hp = defaultStats["hp"]
	dmg = defaultStats["dmg"]
	actionRepeats = defaultStats["repeats"]
	actionButtons.clear()
	for action in actions:
		addAction(action)
	for chip in $chips.get_children():
		chip.activate()
		await chip.chipActivated
	update()

func canAddChip():
	return $chips.get_child_count() < maxAmountOfChips

func addChip(t : String):
	var chip = load("res://prefabs/chips/%s.tscn" % t).instantiate()
	chip.used = true
	$chips.add_child(chip)

func getCreatureCenter():
	return $creature.global_position + $creature.get_rect().size / 2

func update():
	%hp.text = str(hp)
	%dmg.text = str(dmg)

func getHit(value : int):
	hp -= value
	update()
	$statusAnim.play("hit")
	$hit.play()
	checkHp()
	return await $statusAnim.animation_finished

func checkHp():
	if hp <= 0:
		$death.play()
		await $statusAnim.animation_finished
		queue_free()

func heal(value : int):
	hp += value
	$heal.play()
	$statusAnim.play("heal")
	if hp > maxHp:
		hp = maxHp
	update()
	return await $statusAnim.animation_finished

func power(value : int):
	dmg += value
	$power.play()
	$statusAnim.play("power")
	update()
	return await $statusAnim.animation_finished

func weak(value : int):
	dmg -= value
	$weak.play()
	$statusAnim.play("weak")
	if dmg < 0:
		dmg = 0
	update()
	return await $statusAnim.animation_finished
