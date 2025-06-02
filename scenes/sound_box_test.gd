extends RigidBody2D

@onready var death_layer: TileMapLayer = $"../Death"
@onready var area: Area2D = $DeathDetector

var checkpoint_position: Vector2

func _ready() -> void:
	checkpoint_position = global_position

func _physics_process(_delta: float) -> void:
	if check_death_collision():
		trigger_respawn()

func check_death_collision() -> bool:
	var shape = area.get_node("CollisionShape2D").shape
	if typeof(shape) != TYPE_OBJECT:
		return false

	var extents = Vector2.ZERO
	if shape is RectangleShape2D:
		extents = shape.extents
	else:
		return false

	var corners = [
		global_position + Vector2(-extents.x, -extents.y),
		global_position + Vector2( extents.x, -extents.y),
		global_position + Vector2(-extents.x,  extents.y),
		global_position + Vector2( extents.x,  extents.y),
	]

	for corner in corners:
		var tile_pos = death_layer.local_to_map(death_layer.to_local(corner))
		if death_layer.get_cell_source_id(tile_pos) != -1:
			return true

	return false


func trigger_respawn() -> void:
	global_position = checkpoint_position
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	rotation = 0
