extends CharacterBody3D



@onready var camera = $cameraController/Camera3D
@onready var bodyTest = $level/Environment/wall
const JUMP_VELOCITY = 4.5
const SPEED =5.0
const HANDPOSITION = Vector3(0,1,0)


var current_mouse_mode = Input.MOUSE_MODE_VISIBLE
var grapple = null

func _ready():
	Input.set_mouse_mode(current_mouse_mode)
	
func _physics_process(delta: float) -> void:
	handleMouse()
	
	
	if Input.is_action_just_pressed("grapple"):
		grapple = spawnGrapple()
	if Input.is_action_just_pressed("shoot"):
		spawnBullet()
		
	handleMovement(delta)

	move_and_slide()
	
func handleGrappling():
	if is_on_floor():
		return
	
		
	

func handleMovement(delta):
	if not is_on_floor():
		if position.y < -20:
			position = Vector3(0,0,0)
		velocity += get_gravity() * delta
		
	var movement = Input.get_vector("a",'d','w','s').rotated(-camera.global_rotation.y).normalized()
	if grapple:
		handleGrappling()
		
	if Input.is_action_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_key_pressed(KEY_SHIFT):
		movement *= 2
		
	if Input.is_key_pressed(KEY_CTRL):
		movement *= 0.2
		
	
		
	if movement:
		velocity.x = movement.x * SPEED
		velocity.z = movement.y * SPEED
	else:
		velocity.x = move_toward(velocity.x,0,SPEED*delta)
		velocity.z = move_toward(velocity.z,0,SPEED*delta)
func spawnGrapple():
	var grapple = preload("res://line.tscn").instantiate()
	owner.add_child(grapple)
	
	var pointPosition = calcInterferancePoint(calcDirectionVec3())
	grapple.position = (position + HANDPOSITION +pointPosition)/2
	grapple.gripPointPosition = pointPosition
	var A = Vector2(pointPosition.x,pointPosition.z)
	var B = Vector2(position.x,position.z)
	
	var distance = sqrt(pow(B.x-A.x,2) + pow(B.y-A.y,2))
	grapple.maxLength = distance
	grapple.size.z = distance
	
	grapple.rotation_degrees.y = camera.global_rotation_degrees.y
	grapple.rotation_degrees.x = camera.global_rotation_degrees.x
	return grapple

func spawnBullet():
	var b = preload("res://Bullet.tscn").instantiate()
	owner.add_child(b)
	b.position = position + Vector3(0,camera.global_position.y,0)
	b.direction = calcDirectionVec3()
	return b
	
func handleMouse():
	if Input.is_action_just_pressed("camera_state") and current_mouse_mode == Input.MOUSE_MODE_CAPTURED:
		current_mouse_mode = Input.MOUSE_MODE_VISIBLE
		Input.set_mouse_mode(current_mouse_mode)
		return
		
	if Input.is_action_just_pressed("camera_state") and current_mouse_mode == Input.MOUSE_MODE_VISIBLE:
		current_mouse_mode = Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(current_mouse_mode)
		return
	
func calcDirectionVec3() -> Vector3:
	var velo = Vector2(1,0).rotated(camera.global_rotation.y)
	var up = Vector2(1,0).rotated(-camera.global_rotation.x)
	return Vector3(velo.y,up.y,velo.x).normalized()
	
func calcInterferancePoint(direction: Vector3) -> Vector3: 
	var space_state = get_world_3d().direct_space_state
	var size = DisplayServer.window_get_size()
	var mousepos = Vector2(size.x /2 ,size.y/2)
	
	var start = camera.project_ray_origin(mousepos)
	
	var end = start + camera.project_ray_normal(mousepos)* 1000
	var query = PhysicsRayQueryParameters3D.create(start,end)

	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	if result:
		return result.position
	return Vector3()

	
	
