@tool
extends Control

## This is just an inital idea on how to do a little plugin to set up GDExtension
## This only downloads, unzips, and builds the required files. Setting up the desired native
## language files (C++, Rust, Haxe, etc...) would require much more work, but is possible.
## Setting up the correct directory and editing the project.godot file for the correct .dll
## is possible as well, but would again, require more work. This is just a showcasing and helps
## solve some of the pain of setting up GDExtension. Ideally this plugin also sets more, but there
## is a possibility that there will always be manual work involved. Scons is required to be installed.

## Also note - I don't know how to use the new "Window" node in 4.0, that's why I created this abomination.

var processor_count
var processor_count_box
var status_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer/VBoxContainer/ButtonContainer/OkayBtn.button_down.connect(_on_okay_btn_down)
	$PanelContainer/VBoxContainer/ButtonContainer/CancelBtn.button_down.connect(_on_cancel_btn_down)
	processor_count = OS.get_processor_count()
	processor_count_box = $PanelContainer/VBoxContainer/HBoxContainer/ProcessorCountBox
	processor_count_box.max_value = processor_count
	processor_count_box.value = processor_count
	processor_count_box.apply()
	
	status_label = $PanelContainer/VBoxContainer/StatusLabel


func _gui_input(event: InputEvent) -> void:
	# handle when the user clicks outside of the dialog
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			queue_free()


func _on_cancel_btn_down() -> void:
	queue_free()


func _on_okay_btn_down() -> void:
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_http_request_completed)

	http.download_file = 'master.zip'
	status_label.text = 'Trying to get files...'
	var error = http.request('https://github.com/godotengine/godot-cpp/archive/refs/heads/master.zip')
	if error:
		print('Error with the http request. Error Code: %d' % error)


func _http_request_completed(result, response_code, headers, body):
	if response_code != 200:
		return
	status_label.text = 'Files successfully downloaded...'
	var dir = Directory.new()
	dir.open(ProjectSettings.globalize_path('res://'))
	var actual = dir.get_current_dir().trim_suffix('/content')

	# set the OS specific directory
	var orig = ProjectSettings.globalize_path('res://master.zip')
	var dest = dir.get_current_dir().trim_suffix('/content')
	dest = dest + '/source'

	status_label.text = 'Unzipping files...'
	# unzip and place the contents in the directories
	if (OS.get_name() == 'Windows'):
		OS.execute("powershell.exe", ['-Command', 'Expand-Archive %s -DestinationPath %s' % [orig, dest]])
	elif (OS.get_name() == 'Linux'):
		pass

	# remove the zip - it is no longer needed
	dir.remove('res://master.zip')

	status_label.text = 'Building the GDE source directory...'
	# get the correct directory so we can build the required things for GDE
	dir.open(dest + '/godot-cpp-master')
	var path = dir.get_current_dir()

	# build the GDE directory
	print_debug('Building the GDE directory...')
	if (OS.get_name() == 'Windows'):
		OS.execute("powershell.exe", ['-Command', 'cd %s; scons -j%d target=debug' % [path, processor_count]])
	print_debug('Finished building')
	queue_free()
