# GDExtension setup plugin

Scons is required to be installed on your system (and in your PATH) in order for this plugin to work.
Currently it only works on Windows as I don't have a Linux machine to test it on.

To run the plugin, go to `Project -> Tools -> Setup GDExtension`. The plugin should be enabled already.

Pretty much - it runs `OS.execute()` to unzip the downloaded package. On Windows it relies on Powershell v5+.
This is because there is no native way in Godot to unzip a folder. Most machines should be able to do so through the shell however.

This is just an inital idea on how to do a little plugin to set up GDExtension
This only downloads, unzips, and builds the required files. Setting up the desired native
language files (C++, Rust, Haxe, etc...) would require much more work, but is possible.
Setting up the correct directory and editing the project.godot file for the correct .dll
is possible as well, but would again, require more work. This is just a showcasing and helps
solve some of the pain of setting up GDExtension. Ideally this plugin also sets more, but there
is a possibility that there will always be manual work involved. Scons is required to be installed.

This also showcases a proposed way of [**structuring**](https://github.com/godotengine/godot-proposals/issues/4608) the project when Godot creates a new project.
Currently, you will need to set the project up like this by hand or use a custom project manager that creates a new project like this. That is the reason behind the proposal.