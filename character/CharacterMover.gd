extends Spatial

var body_to_move : KinematicBody = null

export var move_acceleration = 5
export var max_speed = 25
var drag = 0.0
export var jump_force = 25
export var gravity = 60

var pressed_jump = false
var move_vector : Vector3
var velocity : Vector3
var snap_vector : Vector3
export var ignore_rotation = false

signal movement_info

var frozen = false

func _ready():
	drag = float(move_acceleration) / max_speed
	
func init(_body_to_move: KinematicBody):
	body_to_move = _body_to_move

func jump():
	pressed_jump = true

func set_move_vector(_move_vector: Vector3):
	move_vector = _move_vector.normalized()

func _physics_process(delta):
	if frozen:
		return
	var cur_move_vector = move_vector
	if !ignore_rotation:
		cur_move_vector = cur_move_vector.rotated(Vector3.UP, body_to_move.rotation.y)
	velocity += move_acceleration * cur_move_vector - velocity * Vector3(drag, 0, drag) + gravity * Vector3.DOWN * delta
	velocity = body_to_move.move_and_slide_with_snap(velocity, snap_vector, Vector3.UP)
	
	var grounded = body_to_move.is_on_floor()
	if grounded:
		velocity.y = -0.01
		if grounded && pressed_jump:
			velocity.y = jump_force
			snap_vector = Vector3.ZERO
		else:
			snap_vector = Vector3.DOWN
		pressed_jump = false
		emit_signal("movement_info", velocity, grounded)

func freeze():
	frozen = true

func unfreeze():
	frozen = false




