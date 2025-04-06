extends DragableObject

class_name CharacterCard

signal actionChoosen

const buttonSize = 60
const maxAmountOfChips = 3

@export var maxHp : int = 10
@onready var hp : int = maxHp
@export var dmg : int = 1
@export var actions : Array[String]
@export var title : String = "Depression"

var chips : Array[Chip]
var actionButtons : Array[ActionButton] = []
@onready var defaultStats = {
	"hp" : maxHp,
	"dmg" : dmg,
	"actions" : []
}

func _ready() -> void:
	super()
	texture = load("res://sprites/card.png")
	defaultStats["actions"].append_array(actions)
	for action in actions:
		var button = ActionButton.new()
		button.actionName = action
		actionButtons.append(button)
	if get_parent().name == "enemies":
		$action.text = title
	update()
	await $statusAnim.animation_finished
	await get_tree().create_timer(randf_range(0,1)).timeout
	$anim.play("idle")

func myTurn():
	#print(actions)
	#for button in actionButtons:
		#print(button.actionName)
	$action.text = ""
	var numOfActions = actionButtons.size()
	for i in range(0,numOfActions):
		var actionButton = ActionButton.new()
		actionButton.actionName = actionButtons[i].actionName
		actionButton.initialPos = Vector2(0,-60 - (numOfActions - i - 1) * buttonSize)
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
	actions.append(title)
	var button = ActionButton.new()
	button.actionName = t
	actionButtons.append(button)

func toTarget(target : CharacterCard):
	var startPos = $creature.global_position
	var tween = create_tween().bind_node(self)
	var direction = int(startPos.y >= target.global_position.y) * 2 - 1
	var targetPos = target.get_node("creature").global_position
	tween.tween_property($creature, "global_position", targetPos + Vector2(0,50) * direction, 0.3)
	tween.play()
	await tween.finished
	$anim.play("punch")
	await $anim.animation_finished
	$anim.play("idle")
	var tween2 = create_tween().bind_node(self)
	tween2.tween_property($creature, "global_position", startPos, 0.5)
	tween2.play()
	return await tween2.finished

func reset():
	maxHp = defaultStats["hp"]
	dmg = defaultStats["dmg"]
	actions.clear()
	actions.append_array(defaultStats["actions"])
	actionButtons.clear()
	for action in actions:
		var button = ActionButton.new()
		button.actionName = action
		actionButtons.append(button)
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
	chip.activate()

func getCreatureCenter():
	return $creature.global_position + $creature.get_rect().size / 2

func update():
	%hp.text = str(hp)
	%dmg.text = str(dmg)

func getHit(value : int):
	hp -= value
	update()
	await get_tree().create_timer(0.3).timeout
	$statusAnim.play("hit")
	if hp <= 0:
		queue_free()

func heal(value : int):
	hp += value
	await get_tree().create_timer(0.3).timeout
	$statusAnim.play("heal")
	if hp > maxHp:
		hp = maxHp
	update()

func power(value : int):
	dmg += value
	update()

func weak(value : int):
	dmg -= value
	if dmg < 0:
		dmg = 0
	update()
