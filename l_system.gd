extends Node

class_name LSystem

@onready var tile_map: TileMap = get_parent()
@export var axiom: String = "OWB"
@onready var string: String = axiom
@export var rules: Array[Dictionary] = [
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

const FLOWERS_1: Vector2i = Vector2i(3, 7) # "O" = ORANGE
const FLOWERS_2: Vector2i = Vector2i(3, 10) # "W" = WHITE
const FLOWERS_3: Vector2i = Vector2i(3, 13) # "B" = BLUE

func get_new_replacement(character: String) -> String:
	for rule in rules:
		if rule["from"] == character:
			return rule["to"]
	return ""

func size() -> int:
	return tile_map.x_tile_range * tile_map.y_tile_range

func parse() -> String:
	var size: int = size()
	while len(string) <= size:
		var new_string = ""
		for character in string:
			new_string += get_new_replacement(character)
		string = new_string
	string = string.substr(0, size)
	return string

func paint() -> void:
	string = parse()
	var size: int = size()
	var i: int = -1
	for x in range(tile_map.x_tile_range):
		for y in range(tile_map.y_tile_range):
			i += 1
			if string[i] == "O":
				tile_map.set_cell(1, Vector2i(x, y), 0, FLOWERS_1)
			elif string[i] == "W":
				tile_map.set_cell(1, Vector2i(x, y), 0, FLOWERS_2)
			elif string[i] == "B":
				tile_map.set_cell(1, Vector2i(x, y), 0, FLOWERS_3)
