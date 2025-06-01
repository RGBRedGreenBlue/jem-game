extends Camera2D

@export var tilemap_path: NodePath = '../../BoundsSYSTEM'
var tilemap: TileMapLayer
var tileSize = Vector2i(16, 16)

func _ready():
	if tilemap_path and has_node(tilemap_path):
		tilemap = get_node(tilemap_path) as TileMapLayer
	else:
		tilemap = get_tree().get_current_scene().get_node("Ground") as TileMapLayer
		
	var mapRect = tilemap.get_used_rect()
	var worldSize = mapRect.size * tileSize

	limit_top = 0
	limit_left = 0

	limit_right = worldSize.x - tileSize.x * 2
	limit_bottom = worldSize.y - tileSize.y * 2
