extends KinematicBody2D

enum states {CHASE, ATTACK, CHILL, DEATH}
var state
export (int) var start_health = 100
var health = start_health
export (int) var damage = 10
var state_machine
var alive
var velocity = Vector2.ZERO
var enemy = KinematicBody2D
var player = null
var run_speed = 300
var attacks = ["attack" , "attack2"]
var parent
var fbomb  = preload("res://fireball.tscn")
var canshoot = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal health_changed
# Called when the node enters the scene tree for the first time.
func _ready():
	alive = true
	#state_machine = $AnimationTree.get("parameters/playback")
	emit_signal("health_changed", health)
	parent = get_parent()

func _physics_process(delta):
	choose_action()
	#var current = state_machine.get_current_node()
	if velocity.x > 0:
		$Sprite.scale.x = 1
	elif velocity.x < 0:
		$Sprite.scale.x = -1

	if state == states.ATTACK:
		$Sprite/Muzzle.global_rotation = player.position
	
	
	if velocity.length() > 0 :
		$AnimationPlayer.play("run")

		
	velocity = move_and_slide(velocity)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func shoot():
	canshoot = false
	$guntimer.start()
	var b = fbomb.instance()
	b.start_at($Sprite/Muzzle.global_position, $Sprite/Muzzle.global_rotation)
	$Bullets.add_child(b)



func choose_action():
	velocity = Vector2.ZERO
	#var current = state_machine.get_current_node()
	#if current in attacks:
	#	return
	var target
	match state:
		states.CHASE:
			target = player
			velocity = (target.position - position).normalized() * run_speed
		states.ATTACK:
			target = player

			if target.position.x > position.x:
				$Sprite.scale.x = 1
			elif target.position.x < position.x:
				$Sprite.scale.x = -1
			#target = player
			shoot()
			
		states.CHILL:
			velocity = Vector2.ZERO

func take_damage(amount):
	#$HealthBar.show()
	health -= amount
	emit_signal("health_changed", (health * 100 / start_health))
	#health * 100 / start_health
	$Bar.rect_size.x = 64 * health / start_health
	if health <= 0:
		alive = false
		queue_free()

func _on_damageradius_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)


func _on_detect_body_entered(body):
	state = states.CHASE
	player = body


func _on_attackradius_body_entered(body):
	state = states.ATTACK
	#player = null


func _on_detect_body_exited(body):
	player = null
	state =  states.CHILL

func _on_damageradius_body_exited(body):
	pass


func _on_attackradius_body_exited(body):
	state = states.CHASE


func _on_eszlel_body_entered(body):
	state = states.CHASE
	player = body



func _on_eszlel_body_exited(body):
	player = null
	state =  states.CHILL


func _on_attackrange_body_entered(body):
	state = states.ATTACK
	#player = null



func _on_attackrange_body_exited(body):
	state = states.CHASE



func _on_guntimer_timeout():
	canshoot = true
