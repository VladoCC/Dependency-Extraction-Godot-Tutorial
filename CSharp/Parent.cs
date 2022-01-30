using Godot;
using Godot.Collections;
using System;

public class Parent : Node
{
	// path to a data storage file 
	// it might be either json or csv
	const String path = "res://example_data.json";

	// static variable, which stores mob data and can be
	// accessed from any instance of Mob class
	private static Dictionary _dataModel = null;

	// lazy getter for mob model, which loads it from hard drive
	// once and then stores it in static variable
	public static Dictionary dataModel {
		get {
			if (_dataModel == null) {
				var file = new File();
				file.Open(path, File.ModeFlags.Read);
				
				// LoadJson and LoadCSV are interchangebale, select depending on your file type
				_dataModel = LoadJson(file);
				// after that point _dataModel will never be equal to null anymore
			} 
			return dataModel;
		}
	}

	private static Dictionary LoadJson(File file) {
		var text = file.GetAsText();
		return JSON.Parse(text).Result as Dictionary;
	}

	// we want to be able to parse the same types of data from csv,
	// as we're able to parse from json
	// specifically, we want to have: number, boolean, null, string, array, dict
	private static Dictionary LoadCSV(File file) {
		var dictionary = new Dictionary();
		
		var header = file.GetCsvLine();
		while (!file.EofReached()) {
			var entity = new Dictionary();

			var row = file.GetCsvLine();
			for (int i = 1; i < row.Length; i++)
			{
				// making sure that value in this column is presented for this class
				if (row[i] != " ") {
					entity[header[i]] = ParseField(row[i]);
				}
			}
			dictionary[row[0]] = entity;
		}
		return dictionary;
	}

	private static object ParseField(string field) {
		try {
			return int.Parse(field);
		} catch (FormatException _) {}

		try {
			return float.Parse(field);
		} catch (FormatException _) {}

		if (field == "<true>")
			return true;
		else if (field == "<false>")
			return false;
		else if (field == "<null>")
			return null;
		else if (field.StartsWith("{") && field.EndsWith("}"))
			return JSON.Parse(field).Result as Dictionary;
		else if (field.StartsWith("[") && field.EndsWith("]"))
			return JSON.Parse(field).Result as Godot.Collections.Array;
		else
			return field;
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
