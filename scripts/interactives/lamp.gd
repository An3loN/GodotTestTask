extends Interactive

@export var sprite_renderer: Sprite2D
var activated = false

@onready var data_provider = PersistentDataProvider.new(
		func(): return UmbrellaPersistentData.new(activated),
		func(data: UmbrellaPersistentData):
			activated = data.activated
			update_state(),
		get_path())

func _ready():
	super()
	update_state()

func _activate():
	activated = not activated
	update_state()

func update_state():
	sprite_renderer.region_rect.position.x = 16 if activated else 0
