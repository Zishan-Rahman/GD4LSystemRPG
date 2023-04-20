extends Node

class_name LSystem

@onready var tile_map: TileMap = get_parent()
## The starting string from which the grammar starts applying its rules. Here it may be self defined, or randomly defined when use_random_axiom is true.
@export var axiom: String = "OWB"
## Uses a random axiom with the currently set grammar, computed upon runtime, with a length up to (but not strictly) the value of upper_limit. For example, if upper_limit is set to 15, the generated axiom can be 15 characters, or it can be just 5 characters.
@export var use_random_axiom: bool = true
## Defines how many characters a random axiom can have MAXIMUM. Only used when use_random_axiom is true.
@export var upper_limit: int = 10
## Allows the use of a customly defined ruleset made through amending the rules array in the editor.
@export var use_custom_ruleset: bool = false
@onready var string: String = axiom
## Denotes a series of pre-defined rulesets for this L-System grammar, of alphabet O (blank space), W (trees and fauna) and B (buildings), that can be chosen and then used on runtime. Can choose between a default ruleset, a ruleset that produces more buildings, a ruleset that produces more trees and a ruleset that produces more empty space.
@export_enum("Default", "More Buildings (IMPOSSIBLE)", "More Trees", "More Space") var ruleset: String = "Default"
## The set of rules that the L-System grammar uses. Shows the "default" ruleset in the Godot editor for the user to see. If use_custom_ruleset is set to true, this array can be edited with a custom defined ruleset that will be used on runtime, so long as it adheres to the alphabet of O (blank space), W (trees and fauna) and B (buildings).
@export var rules: Array[Dictionary] = DEFAULT

const DEFAULT: Array[Dictionary] = [
	{
		"from": "O",
		"to": "OWO"
	},
	{
		"from": "W",
		"to": "WB"
	},
	{
		"from": "B",
		"to": "BWO"
	}
]
const MORE_BUILDINGS: Array[Dictionary] = [
	{
		"from": "O",
		"to": "BWOB"
	},
	{
		"from": "W",
		"to": "WBOBO"
	},
	{
		"from": "B",
		"to": "BB"
	}
]
const MORE_TREES: Array[Dictionary] = [
	{
		"from": "O",
		"to": "WWO"
	},
	{
		"from": "W",
		"to": "WBWO"
	},
	{
		"from": "B",
		"to": "BWWO"
	}
]
const MORE_SPACE: Array[Dictionary] = [
	{
		"from": "O",
		"to": "OOBWO"
	},
	{
		"from": "W",
		"to": "OB"
	},
	{
		"from": "B",
		"to": "OW"
	}
]

const buildings: Array[Vector2i] = [
	Vector2i(0, 19),
	Vector2i(1, 19),
	Vector2i(2, 19),
	Vector2i(3, 19),
	Vector2i(4, 19),
	Vector2i(5, 19),
	Vector2i(6, 19),
	Vector2i(7, 19),
	Vector2i(8, 20),
	Vector2i(0, 20),
	Vector2i(1, 20),
	Vector2i(2, 20),
	Vector2i(3, 20),
	Vector2i(4, 20),
	Vector2i(5, 20),
	Vector2i(6, 20),
	Vector2i(7, 20),
	Vector2i(8, 20),
	Vector2i(0, 21),
	Vector2i(1, 21),
	Vector2i(2, 21),
	Vector2i(3, 21),
	Vector2i(4, 21),
	Vector2i(5, 21),
	Vector2i(6, 21),
	Vector2i(7, 21),
	Vector2i(8, 21)
]
const trees: Array[Vector2i] = [
	Vector2i(0,1),
	Vector2i(1,1),
	Vector2i(2,1),
	Vector2i(3,1),
	Vector2i(4,1),
	Vector2i(5,1),
	Vector2i(6,1),
	Vector2i(7,1),
	Vector2i(0,2),
	Vector2i(1,2),
	Vector2i(2,2),
	Vector2i(3,2),
	Vector2i(4,2)
]

func _get_ruleset() -> Array[Dictionary]:
	match ruleset:
		"More Buildings (IMPOSSIBLE)": return MORE_BUILDINGS
		"More Trees": return MORE_TREES
		"More Space": return MORE_SPACE
		_: return DEFAULT

func get_new_replacement(character: String) -> String:
	for rule in rules:
		if rule["from"] == character:
			return rule["to"]
	return character

func _size() -> int:
	return tile_map.x_tile_range * tile_map.y_tile_range

func rand_axiom() -> String:
	var string_buffer: String = ""
	var limit: int = randi_range(1, upper_limit)
	for i in range(limit):
		string_buffer += ["O", "W", "B"].pick_random()
	return string_buffer

func parse() -> String:
	if use_random_axiom:
		axiom = rand_axiom()
		string = axiom
	if not use_custom_ruleset or ruleset != "Default":
		rules = _get_ruleset()
	print("Axiom length: " + str(len(axiom)))
	var size: int = _size()
	while len(string) <= size:
		var new_string = ""
		for character in string:
			new_string += get_new_replacement(character)
		string = new_string
	string = string.substr(0, size)
	return string

func paint() -> void:
	string = parse()
	var i: int = -1
	for x in range(tile_map.x_tile_range):
		for y in range(tile_map.y_tile_range):
			i += 1
			if string[i] == "O": # "O" = BLANK
				pass # Do not paint any cell.
			elif string[i] == "W": # "W" = TREE
				tile_map.set_cell(0, Vector2i(x, y), 0, trees.pick_random())
			elif string[i] == "B": # "B" = BUILDING
				tile_map.set_cell(0, Vector2i(x, y), 0, buildings.pick_random())
