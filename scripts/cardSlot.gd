extends Control

class_name CardSlot

@export var isReward = false
var center = get_rect().size / 2
@onready var childrenByX : Array[Node] = get_children()
var cardIndex = 0
var actionIndex = 0
var allCharactersSet = false
var reversed = true

func _ready() -> void:
	child_order_changed.connect(locateObjects)
	for object in get_children():
		object.dragPos = center - object.get_rect().size / 2 + Vector2(object.get_index(), 0)
	await get_tree().create_timer(0.1).timeout
	locateObjects()

func locateObjects():
	var numOfChildren = get_child_count()
	if numOfChildren > 0:
		childrenByX = get_children()
		childrenByX.sort_custom(compareX)
		if !reversed:
			childrenByX.reverse()
		var step : float = get_rect().size.x / (numOfChildren + 1)
		var finalWidth = step * (numOfChildren - 1) + 94
		var offset = center.x - finalWidth / 2.0
		for i in range(0,numOfChildren):
			childrenByX[i].dragPos = Vector2(step * i + offset,center.y - 104 / 2)
			childrenByX[i].moveTo()
	else:
		if !isReward:
			Global.main.fightEnded.emit()

func compareX(a,b):
	if a != null && b != null:
		return a.position.x <= b.position.x

func nextCard():
	if !allCharactersSet && Global.main.isFighting:
		if get_child(cardIndex) != null:
			get_child(cardIndex).myTurn()
		cardIndex += 1
		if cardIndex >= get_children().size():
			allCharactersSet = true
			cardIndex = 0
	else:
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
				for i in range(0,character.actionRepeats):
					var actionName = character.actionButtons[i].actionName
					character.get_node("actions").add_child(load("res://prefabs/actions/%s.tscn" % actionName).instantiate())
					var action : Action = character.get_node("actions").get_child(0)
					if action.friendly:
						action.target = childrenByX[0]
					else:
						action.target = Global.main.getCardSlot("team").childrenByX[0]
			if character.get_node("actions").get_child_count() > 0:
				if Global.main.isFighting:
					for i in range(0,character.actionRepeats):
						character.get_node("actions").get_child(0).act(i)
						await character.get_node("actions").get_child(0).actionFinished
	allCharactersSet = false
	cardIndex = 0
	Global.main.giveTurn()
