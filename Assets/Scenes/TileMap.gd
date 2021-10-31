tool
extends TileMap

export var counter = 0
export var generate_autotile_collision = false

var tile_size = 32
var sprite_sheet_size = Vector2(4,2)

func _ready():
	if Engine.editor_hint:
		_generate_autotile_collision()

func _generate_autotile_collision():
	for x in sprite_sheet_size.x:
		for y in sprite_sheet_size.y:
			var shape = ConvexPolygonShape2D.new()
			shape.points = [Vector2(0,0), Vector2(0,tile_size), Vector2(tile_size, tile_size), Vector2(tile_size, 0)]
			tile_set.tile_add_shape(0,shape, Transform2D(0.0, Vector2(0,0)), false, Vector2(x,y))
