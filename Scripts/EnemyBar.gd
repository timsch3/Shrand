extends Area2D

const Target01 = preload("res://Scenes/Target01.tscn")


func _on_SpawnDelay_timeout():
	var t = Target01.instance()
	add_child(t)
