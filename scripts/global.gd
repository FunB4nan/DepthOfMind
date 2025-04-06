extends Node

var main : Main
var isDevBuild = false
var isTutorialPassed = false
var level = 0

var encounters = [
	["demon", "demon"],
	["worm", "slime", "slime"],
	["troll", "demon"],
	["worm", "worm", "demon"],
	["demon", "demon", "slime", "slime"],
	["troll", "troll"],
]
var chips = [
	"giveAttackAll", "giveHeal", "giveAttack",
	"giveWeak", "givePower"
]
