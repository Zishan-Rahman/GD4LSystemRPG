extends TileMap

@onready var l_system: LSystem = $LSystem

var x_tile_range: int = ProjectSettings.get_setting("display/window/size/viewport_width") / tile_set.tile_size.x
var y_tile_range: int = ProjectSettings.get_setting("display/window/size/viewport_height") / tile_set.tile_size.y

const PLAYER_SPRITE: Vector2i = Vector2i(24, 7)
var player_placement_cell: Vector2i
const rings: Array[Vector2i] = [
	Vector2i(43, 6),
	Vector2i(44, 6),
	Vector2i(45, 6),
	Vector2i(46, 6)
]
var ring_placement_cell: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var start_time: float = Time.get_ticks_msec()
	l_system.paint()
	place_player()
	place_ring()
	var new_time: float = Time.get_ticks_msec() - start_time
	print("Time taken: " + str(new_time) + "ms")
	$AcceptDialog.dialog_text = "You're a hollow Golem who seeks the ultimate treasure; a ring that's got something on top of it. It's somewhere in this large village and barely visible to your naked eyes, which took us " + str(new_time) + " milliseconds to generate (" + str(new_time / 1000.0) + " seconds), but you'll stop at nothing to get what you want. You can chow down every tree and fauna that stands in your way of the ring, but your Achilles heel is any bricks and mortar, which will make you stop at your tracks. Are you ready to attain your treasure?w Golem in a black-and-white world, in search for your most desired treasure. It's a ring with something on top of it. And you'll stop at nothing to get what you want. You can chow down every tree and fauna that stands in your way of the ring, but your Achilles heel is any bricks and mortar, which will make you stop at your tracks. Are you ready to attain the treasure that is rightfully yours?!"
	$AcceptDialog.visible = true
	$AcceptDialog.confirmed.connect(_on_AcceptDialog_closed)
	$AcceptDialog.canceled.connect(_on_AcceptDialog_closed)
	$WinDialog.confirmed.connect(_on_WinDialog_confirmed)
	$WinDialog.canceled.connect(_on_WinDialog_canceled)
	get_tree().paused = true

func _on_WinDialog_confirmed() -> void:
	get_tree().reload_current_scene()

func _on_WinDialog_canceled() -> void:
	get_tree().quit()

func _on_AcceptDialog_closed() -> void:
	$AcceptDialog.visible = false
	get_tree().paused = false

func _get_random_placement_cell() -> Vector2i:
	return Vector2i(randi() % x_tile_range, randi() % y_tile_range)

func place_player() -> void:
	while get_used_cells(0).has(player_placement_cell):
		player_placement_cell = _get_random_placement_cell()
	set_cell(0, player_placement_cell, 0, PLAYER_SPRITE)

func place_ring() -> void:
	while get_used_cells(0).has(ring_placement_cell):
		ring_placement_cell = _get_random_placement_cell()
	set_cell(0, ring_placement_cell, 0, rings.pick_random())

func _is_not_out_of_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < x_tile_range and cell.y >= 0 and cell.y < y_tile_range

func _physics_process(_delta: float) -> void:
	var previous_cell: Vector2i = player_placement_cell
	var direction: Vector2i = Vector2i.ZERO
	if Input.is_action_pressed("ui_up"): direction = Vector2i.UP
	elif Input.is_action_pressed("ui_down"): direction = Vector2i.DOWN
	elif Input.is_action_pressed("ui_left"): direction = Vector2i.LEFT
	elif Input.is_action_pressed("ui_right"): direction = Vector2i.RIGHT
	var new_placement_cell: Vector2i = player_placement_cell + direction
	if (not get_used_cells(0).has(new_placement_cell) or l_system.trees.has(get_cell_atlas_coords(0, new_placement_cell)) or new_placement_cell == ring_placement_cell) and _is_not_out_of_bounds(new_placement_cell):
		player_placement_cell = new_placement_cell
		set_cell(0, previous_cell, 0)
		set_cell(0, player_placement_cell, 0, PLAYER_SPRITE)
		if player_placement_cell == ring_placement_cell:
			$WinDialog.visible = true
			get_tree().paused = true

# ALGORITHM IS IN LSYSTEM NODE
