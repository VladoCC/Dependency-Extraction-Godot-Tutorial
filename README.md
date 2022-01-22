# Dependency-Extraction-Godot-Tutorial
Video tutorial about this tool: [YouTube](https://youtu.be/EmZX3qhe4_4)

Export variables in Godot allow you to redefine properties of base class in its children.    
The problem with exports is that values of it are store in child scne file, thus spliting data into many small files, making maintainability of project incrementally difficult.   
Any changes to base class are impossible without going through every child of it and editing exports.
Code in this repository lets you extract all the data from your export variables into JSON file (central storage of your dependencies) and then inject them back when neccessary.

## Structure
You can find versions of code for both `GDScript` and `CSharp` in corresponding folders.   
`Parent` file represents a base class of your hierarchy, it stores model of specific object and responsible for working with JSON data storage.   
`Child` file represents any child of your base class, which previously stored values of export variables. Now it only stores key for data storage and calls `_ready()` of base class (important, nothing would work without this line).   

`example_data.json` in root directory of this repository shows an example of how you can define your JSON data storage.

`Database.gd` file is a language-specific thing for GDScript. It's used to define a static variable, which is filled once by accessing file on hard drive.   
Without it `Parent` would load data from hard drive every time it's created.

## Complex hierarchies
In many cases in games complex hierarchies are used. In such hierarachies there are more then one element that defines variables like `Mob` and `Boss` in the example.   
In that cases you can treat the root element as `Parent` and use `model` defined in it to extract neccessary fields for all of the other nodes.
![Example 3-levelhierarchy](https://i.imgur.com/866tHgk.png)
