extends TileMap

@onready var l_system: LSystem = $LSystem

var x_tile_range: int = ProjectSettings.get_setting("display/window/size/viewport_width") / tile_set.tile_size.x
var y_tile_range: int = ProjectSettings.get_setting("display/window/size/viewport_height") / tile_set.tile_size.y

const GRASS_1: Vector2i = Vector2i(5, 0)
const GRASS_2: Vector2i = Vector2i(5, 1)

func pick_grass_tile() -> Vector2i:
	return [GRASS_1, GRASS_2].pick_random()

func cover_map_with_grass() -> void:
	for x in range(-50, x_tile_range + 50):
		for y in range(-50, y_tile_range + 50):
			set_cell(0, Vector2i(x, y), 0, pick_grass_tile())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	cover_map_with_grass()
	var start_time: float = Time.get_ticks_msec()
	l_system.paint()
	var new_time: float = Time.get_ticks_msec() - start_time
	print("Time taken: " + str(new_time) + "ms")
