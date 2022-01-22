using Godot;
using Godot.Collections;
using System;

public class Parent : Node
{
	// static variable, which stores mob data and can be
	// accessed from any instance of Mob class
	private static Dictionary _dataModel = null;

	// lazy getter for mob model, which loads it from hard drive
	// once and then stores it in static variable
	public Dictionary dataModel {
		get {
			if (_dataModel == null) {
				var file = new File();
				file.Open("res://example_data.json", File.ModeFlags.Read);
				var text = file.GetAsText();
				// after that point _dataModel will never be equal to null anymore
				_dataModel = JSON.Parse(text).Result as Dictionary;
			} 
			return dataModel;
		}
	}

	[Export]
	public String key = "";

	// data previously stored in export variable
	public int prop;
	
	public Dictionary model;

	public override void _Ready()
	{
		model = dataModel[key] as Dictionary;

		// not going to deal with default values to make this example shorter
		// it works identically to gdscript version
		prop = (int) model["prop_key"];
	}
}
