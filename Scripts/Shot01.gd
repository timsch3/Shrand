extends Area2D

const ExplosionShot = preload("res://Scenes/ExplosionShot.tscn")

var speed = 0
var prev_speed_hi = false
var dir = false
var shot = false
var turning_point = 170
var turning = false
var dying = false


func _ready():
	# shuffle starting direction (false = left, true = right)
	randomize()
	var r = randi() % 2
	if r == 1:
		dir = true
	else:
		dir = false
	dying = false
	$ParticleTrail.visible = false
	$AnimationPlayer.play("respawn")
	$ColorRect.visible = true
	$ColorRect.color = "00ffffff"
	

func _process(delta):	
	# moving along x-axis with speed variable
	if !shot and !dying:
		position.x += speed * delta
		
		# checking near the edges, animation end triggers flipping speed direction
		if !turning:
			if position.x > turning_point or position.x < -turning_point:
				turning = true
				speed = 0
				change_dir()
		elif turning and (position.x < turning_point-50 or position.x > -turning_point+50):
			turning = false
				
		# get direction from speed (- / +) to dir (false = left, true = right)
		if speed < 0:
			dir = false
		elif speed > 0:
			dir = true
		
		# checking for input
		if Input.is_action_just_pressed("ui_accept") and !shot:
			$AnimationPlayer.play("shooting")
			$ParticleTrail.visible = true
			shot = true
			get_parent().get_node("SpawnDelay").start()
	
	# shooting up
	elif shot and !dying:
		speed = 0
		position.y -= 800 * delta
	
	# not moving while dying
	elif shot and dying:
		position.y = position.y

# ANIMATION SIGNALS
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "reload" and !turning:
		change_dir()
	elif anim_name == "turn" and !turning:
		$AnimationPlayer.play("reload")
	elif anim_name == "respawn":
		change_dir()

# dying
func _on_Shot01_area_entered(_area):
	get_node("/root/MAIN").shots -= 1
	$ColorRect.visible = false
	var e = ExplosionShot.instance()
	e.position = position
	get_parent().add_child(e)
	queue_free()
	
		
func change_dir():
	if !prev_speed_hi:
		randomize()
		if dir:
			speed = rand_range(-400, -250)
			$ParticleDir.process_material.gravity.x = 1
			
		elif !dir:
			speed = rand_range(250, 400)
			$ParticleDir.process_material.gravity.x = -1
		prev_speed_hi = true
			
	elif prev_speed_hi:
		randomize()
		if dir:
			speed = rand_range(-200, -80)
			$ParticleDir.process_material.gravity.x = 1
			
		elif !dir:
			speed = rand_range(80, 200)
			$ParticleDir.process_material.gravity.x = -1
		prev_speed_hi = false
		
	$ParticleDir.get_node("AnimationPlayer").play("fade_out")
	$AnimationPlayer.play("turn")
	$ParticleDir.emitting = true
	$ParticleDir.speed_scale = abs(speed) / 100
