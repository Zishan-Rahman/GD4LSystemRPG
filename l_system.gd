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
				pass
			elif string[i] == "W":
				tile_map.set_cell(0, Vector2i(x, y), 0, trees.pick_random())
			elif string[i] == "B":
				tile_map.set_cell(0, Vector2i(x, y), 0, buildings.pick_random())
