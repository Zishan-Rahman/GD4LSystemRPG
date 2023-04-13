extends TileMap

@onready var l_system: LSystem = $LSystem

var x_tile_range: int = ProjectSettings.get_setting("display/window/size/viewport_width") / tile_set.tile_size.x
var y_tile_range: int = ProjectSettings.get_setting("display/window/size/viewport_height") / tile_set.tile_size.y

const PLAYER_SPRITE: Vector2i = Vector2i(24, 7)
var player_placement_cell: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var start_time: float = Time.get_ticks_msec()
	l_system.paint()
	var new_time: float = Time.get_ticks_msec() - start_time
	print("Time taken: " + str(new_time) + "ms")
	place_player()

func _get_player_placement_cell() -> Vector2i:
	return Vector2i(randi() % x_tile_range, randi() % y_tile_range)

func place_player():
	while get_used_cells(0).has(player_placement_cell):
		player_placement_cell = _get_player_placement_cell()
	set_cell(0, player_placement_cell, 0, PLAYER_SPRITE)

func _is_not_out_of_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < x_tile_range and cell.y >= 0 and cell.y < y_tile_range

func _physics_process(_delta):
	var previous_cell: Vector2i = player_placement_cell
	var direction: Vector2i = Vector2i.ZERO
	if Input.is_action_pressed("ui_up"): direction = Vector2i.UP
	elif Input.is_action_pressed("ui_down"): direction = Vector2i.DOWN
	elif Input.is_action_pressed("ui_left"): direction = Vector2i.LEFT
	elif Input.is_action_pressed("ui_right"): direction = Vector2i.RIGHT
	var new_placement_cell: Vector2i = player_placement_cell + direction
	if (not get_used_cells(0).has(new_placement_cell) or l_system.trees.has(get_cell_atlas_coords(0, new_placement_cell))) and _is_not_out_of_bounds(new_placement_cell):
		player_placement_cell = new_placement_cell
		set_cell(0, previous_cell, 0)
		set_cell(0, player_placement_cell, 0, PLAYER_SPRITE)

# ALGORITHM IS IN LSYSTEM NODE
