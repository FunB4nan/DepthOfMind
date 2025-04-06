extends Node

signal localeChanged

var main : Main
var isDevBuild = false
var isTutorialPassed = false
var level = 0

var musicValume = 100
var sfxValume = 100
var crtOn = true

const languages = ["english","русский"]

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
