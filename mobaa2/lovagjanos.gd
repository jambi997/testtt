extends KinematicBody2D


export var id = 0


var fbomb  = preload("res://wave.tscn")
signal health_changed
export (int) var speed = 400
var attack 
var target
export (int) var start_health =100
var health = start_health
var velocity = Vector2()
export (int) var damage = 100
var state_machine
var canshoot = true
var alive = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	health = start_health
	emit_signal("health_changed", health)

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	var mpos = get_global_mouse_position()
	if velocity.x > 0:
		$Sprite.scale.x = 1
	elif velocity.x < 0:
		$Sprite.scale.x = -1
	$Sprite/Muzzle.global_rotation = mpos.angle_to_point(position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func shoot():
	canshoot = false
	$guntimer.start()
	var b = fbomb.instance()
	b.start_at($Sprite/Muzzle.global_position, $Sprite/Muzzle.global_rotation)
	$Bullets.add_child(b)

func dead():
	if health <= 0:
		alive = false
	if alive == false:
		queue_free()

func get_input():
	var current = state_machine.get_current_node()
	velocity = Vector2.ZERO
	if Input.is_action_pressed('right') :
		#$AnimationPlayer.play("run")
		velocity.x += 1
		#get_node( "Sprite" ).set_flip_h( false )
		#$Sprite.visible = true
		#attack==true
		#$AnimationPlayer.play("run")
	if Input.is_action_pressed('left'):
		#$AnimationPlayer.play("run")
		velocity.x -= 1
		#get_node( "Sprite" ).set_flip_h( true )
		#$Sprite.visible = true
		#$AnimationPlayer.play("run")
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	#if Input.is_action_pressed('attack'):
	#	$AnimationPlayer.play('attack')
	velocity = velocity.normalized() * speed
	if velocity.length() != 0:
		$AnimationPlayer.play("run")
		
		return
		
		
		
		
func _input(event):
	if event.is_action_pressed('scroll_up'):
		$Camera2D.zoom = $Camera2D.zoom - Vector2(0.1, 0.1)
	if event.is_action_pressed('scroll_down'):
		$Camera2D.zoom = $Camera2D.zoom + Vector2(0.1, 0.1)
	if event.is_action_pressed('attack') and canshoot:
		
		#fbomb.queue_free()
		$AnimationPlayer.play('attack')
		target = get_global_mouse_position()
		shoot()
		
		
		
		
		
		
		
		
		
		
func take_damage(amount):
	health -= amount
	emit_signal("health_changed", (health * 100 / start_health))
	if health <= 0:
		emit_signal("died")
		print("Dead!")
	$Bar.rect_size.x = 64 * health / start_health
	
	
	

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage) # Replace with function body.


func _on_guntimer_timeout():
	canshoot = true
