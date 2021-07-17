extends Area2D

const Shot01 = preload("res://Scenes/Shot01.tscn")


func _on_SpawnDelay_timeout():
	var s = Shot01.instance()
	add_child(s)
