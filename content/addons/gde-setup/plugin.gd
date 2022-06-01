@tool
extends EditorPlugin

## Run by going to Project -> Tools -> Setup GDExtension

var menu

func _enter_tree() -> void:
	add_tool_menu_item('Setup GDExtension', Callable(create_menu))


func _exit_tree() -> void:
	remove_tool_menu_item('Setup GDExtension')
	if menu != null:
		menu.queue_free()


func create_menu() -> void:
	menu = load('res://addons/Menu.tscn').instantiate()
	get_editor_interface().add_child(menu)
