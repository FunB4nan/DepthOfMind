extends Control

class_name CardSlot

@export var isReward = false
var center = get_rect().size / 2
@onready var childrenByX : Array[Node] = get_children()
var cardIndex = 0
var actionIndex = 0
var allCharactersSet = false

func _ready() -> void:
	child_order_changed.connect(locateObjects)
	for object in get_children():
		object.dragPos = center - object.get_rect().size / 2 + Vector2(object.get_index(), 0)
	await get_tree().create_timer(1).timeout
	locateObjects()

func locateObjects():
	var numOfChildren = get_child_count()
	if numOfChildren > 0:
		childrenByX = get_children()
		childrenByX.sort_custom(compareX)
		var step : float = get_rect().size.x / (numOfChildren + 1)
		var finalWidth = step * (numOfChildren - 1) + get_child(get_child_count() - 1).get_rect().size.x
		var offset = center.x - finalWidth / 2.0
		for i in range(0,numOfChildren):
			childrenByX[i].dragPos = Vector2(step * i + offset,center.y - childrenByX[i].get_rect().size.y / 2)
			childrenByX[i].moveTo()
	else:
		if !isReward:
			Global.main.fightEnded.emit()

func compareX(a,b):
	if a != null && b != null:
		return a.position.x <= b.position.x

func nextCard():
	if !allCharactersSet && Global.main.isFighting:
		get_child(cardIndex).myTurn()
		cardIndex += 1
		if cardIndex >= childrenByX.size():
			allCharactersSet = true
			cardIndex = 0
			Global.main.allActionsChoosen.emit()

func doTurn():
	for character in childrenByX:
		if character != null:
			if Global.main.turn == "player":
				for button in character.get_children():
					if button is ActionButton:
						button.hideMe()
						await get_tree().create_timer(0.1).timeout
			else:
				character.actionButtons.shuffle()
				var actionName = character.actionButtons[0].actionName
				character.get_node("actions").add_child(load("res://prefabs/actions/%s.tscn" % actionName).instantiate())
				var action : Action = character.get_node("actions").get_child(0)
				if action.friendly:
					action.target = childrenByX[0]
				else:
					action.target = Global.main.getCardSlot("team").childrenByX[0]
			if character.get_node("actions").get_child_count() > 0:
				if Global.main.isFighting:
					character.get_node("actions").get_child(0).act()
					await character.get_node("actions").get_child(0).actionFinished
	allCharactersSet = false
	Global.main.giveTurn()
