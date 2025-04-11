extends CSGBox3D


@onready var player = get_node("/root/level/Entities/Player")

var maxLength = 0
var gripPointPosition = Vector3()

func _physics_process(delta: float) -> void:

	var length = calcDistance(gripPointPosition,player.position)

	
	if Input.is_action_just_released("grapple"):
		queue_free()	
	size.z = length
	
	var angle = rad_to_deg(Vector2(player.position.x,player.position.y).normalized().angle())
	
	#var C = Vector3(gripPointPosition.x,0,player.position.z)
	#var x = calcDistance(gripPointPosition,C)
	#var y = calcDistance(gripPointPosition,player.position)

	#var angle = rad_to_deg(acos(x/y))
	print(angle)
	
	rotation_degrees.y = -(angle - 90)
	position = (player.position+ player.HANDPOSITION + gripPointPosition)/2
	
func calcDistance(A: Vector3, B: Vector3):
	var distance = sqrt(pow(B.x-A.x,2) + pow(B.z-A.z,2))
	return distance
