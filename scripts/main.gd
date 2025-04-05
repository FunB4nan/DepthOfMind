extends Node2D

class_name Main

signal targetChoosen
signal chipPicked
signal fightEnded

var turn = "enemies"
var isFighting = true

func _ready() -> void:
	Global.main = self
	nextEncounter()

func _process(delta: float) -> void:
	%arrow.position = %targetLine.points[1]
	%targetLine.points[1] = get_global_mouse_position() + Vector2(0,30)

func nextEncounter():
	for card in $team.get_children():
		card.reset()
	for enemy in Global.encounters[Global.level]:
		var enemyInst = load("res://prefabs/characters/%s.tscn" % enemy).instantiate()
		$enemies.add_child(enemyInst)
	await get_tree().create_timer(0.5).timeout
	Global.level += 1
	isFighting = true
	$team.cardIndex = 0
	turn = "enemies"
	giveTurn()
	await fightEnded
	isFighting = false
	Global.chips.shuffle()
	for i in range(0,3):
		var chip = load("res://prefabs/chips/%s.tscn" % Global.chips[i])
		$rewards.add_child(chip.instantiate())
	await chipPicked
	for reward in $rewards.get_children():
		reward.queue_free()
	if Global.level < Global.encounters.size():
		nextEncounter()
	else:
		get_tree().quit()

func giveTurn():
	match turn:
		"player":
			turn  = "enemies"
			$enemies.doTurn()
		"enemies":
			turn = "player"
			$team.nextCard()
			$endTurn.disabled = false

func getCardSlot(title : String):
	return get_node(title)

func chooseTarget(source):
	$targetArrow.visible = true
	%targetLine.points[0] = source.getCreatureCenter()
	var target = await targetChoosen
	print(target)
	$targetArrow.visible = false
	return target

func checkCharacters():
	for char in $team.get_children():
		if char._is_point_inside_button_area(get_global_mouse_position()):
			return char
	return false

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("removeObject"):
		#$enemies.get_child(0).queue_free()

func _on_end_turn_pressed() -> void:
	$team.doTurn()
	$endTurn.disabled = true
