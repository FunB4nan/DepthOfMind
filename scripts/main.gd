extends Node2D

class_name Main

const textDelay = 0.02

signal targetChoosen
signal chipPicked
signal fightEnded
signal someKeyPressed
signal allActionsChoosen

var turn = "enemies"
var isFighting = true

func _ready() -> void:
	Global.main = self
	await get_tree().create_timer(0.01).timeout
	$team.reversed = false
	$team.add_child(load("res://prefabs/characters/wizard.tscn").instantiate())
	$team.add_child(load("res://prefabs/characters/cowBoy.tscn").instantiate())
	$team.add_child(load("res://prefabs/characters/robot.tscn").instantiate())
	$team.reversed = true
	await saySmth("This is mind of human")
	await hideText()
	await saySmth("Your goal is clear mind from all diseases")
	await hideText()
	await get_tree().create_timer(1).timeout
	nextEncounter()
	await allActionsChoosen
	await saySmth("You can change the sequence of the move")
	await hideText()
	await saySmth("You can change the sequence of the move")
	await hideText()
	await saySmth("Just drag your team members to reorder them")
	await hideText()

func _process(_delta: float) -> void:
	%targetLine.points[1] = get_global_mouse_position() + Vector2(0,30)

func nextEncounter():
	for card in $team.get_children():
		card.reset()
	for enemy in Global.encounters[Global.level]:
		addEnemy(enemy)
	await get_tree().create_timer(0.5).timeout
	Global.level += 1
	isFighting = true
	$team.cardIndex = 0
	turn = "enemies"
	giveTurn()
	await fightEnded
	isFighting = false
	if $team.get_child_count() > 0:
		saySmth("Attach one of the memory chips to your ally.")
		generateReward()
		await chipPicked
		for reward in $rewards.get_children():
			reward.queue_free()
		await hideText()
		$anim.play("nextEncounter")
		await $anim.animation_finished
		if Global.level < Global.encounters.size():
			nextEncounter()
		else:
			await saySmth("You win!")
			await hideText()
			await saySmth("Thank you for playing! Game was made for Ludum Dare 57")
			await hideText()
			Global.level = 0
			get_tree().reload_current_scene()
	else:
		gameOver()

func addEnemy(enemy : String):
	var enemyInst = load("res://prefabs/characters/%s.tscn" % enemy).instantiate()
	$enemies.add_child(enemyInst)

func gameOver():
	$background.stop()
	await saySmth("Click to try again")
	await hideText()
	Global.level = 0
	get_tree().reload_current_scene()

func saySmth(line : String):
	if %mainText != null:
		%mainText.text = line
		%mainText.visible_characters = 0
		while %mainText.visible_characters < line.length():
			%mainText.visible_characters += 1
			$textSound.stream = load("res://sfx/textSound%s.mp3" % randi_range(1,3))
			$textSound.play()
			if Input.is_anything_pressed():
				return await get_tree().create_timer(0.01).timeout
			await get_tree().create_timer(textDelay).timeout
		return await someKeyPressed

func hideText():
	while %mainText.visible_characters > 0:
		%mainText.visible_characters -= 1
		$textSound.stream = load("res://sfx/textSound%s.mp3" % randi_range(1,3))
		$textSound.play()
		await get_tree().create_timer(textDelay).timeout
	return await get_tree().create_timer(0.05).timeout

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

func generateReward():
	Global.chips.shuffle()
	for i in range(0,3):
		var chip = load("res://prefabs/chips/%s.tscn" % Global.chips[i])
		$rewards.add_child(chip.instantiate())

func chooseTarget(source):
	saySmth("Choose target")
	$targetArrow.visible = true
	%targetLine.points[0] = source.getCreatureCenter()
	var target = await targetChoosen
	$targetArrow.visible = false
	hideText()
	return target

func checkCharacters():
	for c in $team.get_children():
		if c._is_point_inside_button_area(get_global_mouse_position()):
			return c
	return false

func dropCharacters():
	for c in $team.get_children():
		c.drop()

func _input(event: InputEvent) -> void:
	if Global.isDevBuild:
		if event.is_action_pressed("removeObject"):
			$enemies.get_child(0).queue_free()
	if event.is_pressed():
		someKeyPressed.emit()

func _on_end_turn_pressed() -> void:
	$team.doTurn()
	$endTurn.disabled = true
