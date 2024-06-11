extends Node2D

signal fish_caught(fish)

func _on_area_2d_body_entered(body):
	fish_caught.emit(body)
