# Component : following_the_character
# It is necessary that the root node implements a get_character method
# Exported variables :
#	speed : movement speed od the ParentActor
#   distance : distance to the PlayerPawn to stop the movement
#   minHeight : height that cannot be passed down

class_name FollowingBodyMovementComponent extends Node

# Property to activate or deactivate the movement
@export var _isEnabled : bool = true

func set_IsEnabled(value : bool) -> void :
	_isEnabled = value

func get_IsEnebled() -> bool :
	return _isEnabled

# Exported variables of the MovementComponent
# Speed of the ParentActor
# Distance from Character to stop
# Height over Character not to go below
@export var speed : float = 3.0
@export var distance : float = 3.0
@export var minHeight : float = 1.0

# internal variables
# Body to follow or you select (by default) a Node or give the path to access it (only used if no node is selected)
@export var _bodyToFollow : CollisionObject3D = null
@export var _bodytoFollowPath : String = ""

@onready var _parentActor : Node3D = get_parent()

# the Movement code
func _physics_process(delta: float) -> void:
	# Only if it is enabled
	if _isEnabled :
		# If there is no CharacterToFollow the ParentActor simply doesn't move
		if (_bodyToFollow != null):
			var bodyToFollowPosition : Vector3 = _bodyToFollow.position
			var movementDirection : Vector3 = bodyToFollowPosition - _parentActor.position
			var distanceBetweenActorAndPawn = abs(movementDirection.length())

			# Not to go below min_height before entering in distance
			if (_parentActor.position.y < (bodyToFollowPosition.y + minHeight)):
				_parentActor.position.y = bodyToFollowPosition.y + minHeight


			# Not to go inside the distance
			if (distanceBetweenActorAndPawn > distance):
				movementDirection = movementDirection.normalized()
				_parentActor.position += movementDirection * speed * delta
				
				# Not to go below min_height
				if (_parentActor.position.y < (bodyToFollowPosition.y + minHeight)):
					_parentActor.position.y = bodyToFollowPosition.y + minHeight
		else:
			_bodyToFollow = get_node(_bodytoFollowPath)
