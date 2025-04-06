extends Node

signal localeChanged

var main : Main
var camera : Camera
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
	["worm", "worm", "skeleton"],
	["skeleton", "skeleton", "slime", "slime"],
	["split"],
]
var chips = [
	"giveAttackAll", "giveHeal", "giveAttack",
	"giveWeak", "givePower", "moreHP", "moreDMG",
	"vampire", "addRepeat"
]
