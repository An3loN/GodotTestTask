class_name PersistentDataController

static var data_dict := {}
static var current_level_name: String:
	get: return level_controller.active_level_data.level_name
static var level_controller: LevelController
static var providers: Array[PersistentDataProvider]

static func load_all_providers() -> void:
	for provider in providers:
		if provider.id in data_dict:
			provider.set_data.call(data_dict[provider.id] as PersistentData)

static func save_all_providers() -> void:
	for provider in providers:
		data_dict[provider.id] = provider.get_data.call() as PersistentData

static func clear_providers() -> void:
	providers.clear()

static func add_provider(provider: PersistentDataProvider) -> void:
	providers.append(provider)
