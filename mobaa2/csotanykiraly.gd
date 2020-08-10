extends KinematicBody2D

enum states {CHASE, ATTACK, CHILL, DEATH}
var state
export (int) var start_health = 1000
var health = start_health
export (int) var damage = 10
var state_machine
var alive
var velocity = Vector2.ZERO
#var enemy = KinematicBody2D
var player = null
var run_speed = 500
var attacks = ["attack" , "attack2"]
var parent
var zed = 0
var rot_dir
const Enemy = preload("res://csotany.tscn")
#const Enemytan = preload("res://csotanykiraly.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal health_changed
# Called when the node enters the scene tree for the first time.
func _ready():
	alive = true
	state_machine = $AnimationTree.get("parameters/playback")
	emit_signal("health_changed", health)
	parent = get_parent()

func _physics_process(delta):
	choose_action()
	var target = player
	var turret_speed = 30
	#var mpos = get_global_mouse_position()
	#if player != null : 
		#$csotanykiraly.global_rotation = mpos.angle_to_point(position)
		
	#_on_Timer_timeout()
	#if player != null  :
	#	look_at(player.position)
		#$Sprite.rotation_degrees = -90
	#var current = state_machine.get_current_node()

	
	if velocity.length() > 0 :
		state_machine.travel("run")
	if state_machine.get_current_node() == "run" and velocity.length() == 0:
		state_machine.travel("idle")
		
	velocity = move_and_slide(velocity)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func enemy_spawner():
	for i in range(1, 3):
		var enemy =Enemy.instance()
		#var room = rooms[1 + randi() % (rooms.size() - 1)]
		#rand.randomize()
		#var x =rand.randf_range(-250, 600)  #room.position.x  + 1 + randi() % int(room.size.x - 2)#rand.randf_range(-500, 500) #in $Rooms.get_children()
		#rand.randomize()
		#var y =rand.randf_range(-190, 320)  #room.position.y + 1 + randi() % int(room.size.y - 2) #rand.randf_range(-500, 500) #in $Rooms.get_children()
		var blocked = false
		enemy.position = $spawnar.position
		add_child(enemy)




func choose_action():
	velocity = Vector2.ZERO
	var current = state_machine.get_current_node()
	if current in attacks:
		return
	var target
	match state:
		states.CHASE:
			target = player
			velocity = (target.position - position).normalized() * run_speed
		states.ATTACK:
			target = player
			state_machine.travel("attack")
			
		states.CHILL:
			velocity = Vector2.ZERO

func take_damage(amount):
	#$HealthBar.show()
	health -= amount
	emit_signal("health_changed", (health * 100 / start_health))
	#health * 100 / start_health
	$Bar.rect_size.x = 50 * health / start_health
	if health <= 0:
		alive = false
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_attack_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)


func _on_attackrange_body_entered(body):
	state = states.ATTACK
	

func _on_attackrange_body_exited(body):
	state = states.CHASE


func _on_attackrange2_body_entered(body):
	state = states.CHASE
	player = body
	#if player == body:
	$Timer.start()


func _on_attackrange2_body_exited(body):
	player = null
	state =  states.CHILL


func _on_Timer_timeout():
	if player != null : #and state != states.ATTACK :
		look_at(player.position)
	#pass # Replace with function body.


func _on_spawnitime_timeout():
	#enemy_spawner()
	pass # Replace with function body.
