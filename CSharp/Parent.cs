using Godot;
using Godot.Collections;
using System;

public class Mob : Node
{
	// static variable, which stores mob data and can be
	// accessed from any instance of Mob class
	private static Dictionary _mobModel = null;

	// lazy getter for mob model, which loads it from hard drive
	// once and then stores it in static variable
	public Dictionary mobModel {
		get {
			if (_mobModel == null) {
				var file = new File();
				file.Open("res://mob_model.json", File.ModeFlags.Read);
				var text = file.GetAsText();
				// after that point _mobModel will never be equal to null anymore
				_mobModel = JSON.Parse(text).Result as Dictionary;
			} 
			return mobModel;
		}
	}

	[Export]
	public String mobName = "";

	public int health = 100;
	public int gold = 0;
	public String description = "";
	public bool passive = false;

	public Dictionary model;

	public override void _Ready()
	{
		GD.Print("Sharp");
		model = mobModel[mobName] as Dictionary;

		// not going to deal with default values to make this example shorter
		// it works identically to gdscript version
		health = (int) model["health"];
		gold = (int) model["gold"];
		description = (String) model["description"];
		passive = (bool) model["passive"];
	}
}
