extends Area2D

const ExplosionTarget = preload("res://Scenes/ExplosionTarget.tscn")

var speed = 60
var turning_point = 170

func _ready():
	randomize()
	var r = randi() % 2
	if r == 1:
		speed = -speed
	else:
		pass
	$AnimationPlayer.play("respawn")
	$ColorRect.color = "00ffffff"

func _process(delta):
	position.x += speed * delta
	if position.x >= turning_point or position.x <= -turning_point:
		speed = -speed

func _on_Target01_area_entered(_area):
	get_node("/root/MAIN").points += 1
	
	var e = ExplosionTarget.instance()
	e.position = position
	e.get_node("AnimationPlayer").play("fade_out")
	get_parent().add_child(e)
	
	get_parent().get_node("SpawnDelay").start()
	
	queue_free()
