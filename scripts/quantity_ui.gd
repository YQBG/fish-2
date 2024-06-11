extends CanvasLayer

@onready var label = $PanelContainer/MarginContainer/HBoxContainer/Label

func _ready():
	label.text = str(0)

func add_count(count):
	label.text = str(count)
