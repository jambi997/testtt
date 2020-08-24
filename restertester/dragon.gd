extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var fball  = preload("res://fireball.tscn")
enum states {CHASE , ATTACK , CHILL , DEATH, SHOOT}
var state
var velocity = Vector2.ZERO
var run_speed = 100
var rush_speed = 700
var start_health = 500
var health = start_health
var alive = true
export (int) var damage = 5
var player = null
var y = false
var parent
export (float) var rotation_speed = 1.5
var rotation_dir = 0
var canshoot = true

var xax = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	alive = true
	#emit_signal("health_changed", health)
	parent = get_parent()
func shoot():
	canshoot= false
	var b = fball.instance()
	b.start_at($mouth.global_position, $mouth.global_rotation)
	$bullet.add_child(b)
	$shoottimer.start()
	
func _physics_process(delta):
	choose_action()
	#$shoottimer.start()
	
	
	if velocity.length() != 0 and y == false :
		$AnimationPlayer.play("run")
	if velocity.length() == 0 and y == false :
		$AnimationPlayer.play("chill")
	velocity = move_and_slide(velocity)
	rotation += rotation_dir * rotation_speed * delta
	#if player != null and state == states.CHASE: #and state != states.ATTACK :
	#	look_at(player.position)
	
	
func start_at(pos ):
	position = pos
	#rotation = dir
	
func choose_action():
	velocity = Vector2.ZERO
	var target
	match state:
		states.CHASE:
			target= player
			velocity = Vector2(run_speed,0).rotated((rotation)) #(target.position - position).normalized() * run_speed
			#$Sprite.rotation_degrees = -90
			look_at(player.position)
		states.ATTACK:
			y = true
			target = player
			$AnimationPlayer.play("rush")
			velocity = Vector2(rush_speed,0).rotated((rotation))  
			#$Sprite.rotate(-10)         #velocity = (target.position - position).normalized() * rush_speed
			#$timer.start()
		states.CHILL:
			velocity = Vector2.ZERO
		states.SHOOT:
			
			look_at(player.position)
			$AnimationPlayer.play("attack")
			if canshoot == true:
				shoot()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func take_damage(amount):
	#$HealthBar.show()
	health -= amount
	emit_signal("health_changed", (health * 100 / start_health))
	health * 100 / start_health
	$Bar.rect_size.x = 64 * health / start_health
	if health <= 0:
		alive = false
		queue_free()


func _on_sense_body_entered(body):
	player = body
	if xax == 2:
		state = states.ATTACK
	if xax == 1:
		state = states.CHASE


func _on_sense_body_exited(body):
	player = null
	state = states.CHILL


func _on_Area2D2_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)


func _on_Timer_timeout():
	y = false
	if player != null and state != states.SHOOT:
		state = states.CHASE



func _on_Timer2_timeout():
	#state= states.ATTACK
	if xax == 1:
		xax= 2
	elif xax == 2:
		xax = 1

func _on_damage_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)



func _on_shootsense_body_entered(body):
	player = body
	if state != states.ATTACK:
		state = states.SHOOT


func _on_shootsense_body_exited(body):
	player = body
	if xax == 2:
		state = states.ATTACK
	if xax == 1:
		state = states.CHASE

func _on_shoottimer_timeout():
	canshoot = true
