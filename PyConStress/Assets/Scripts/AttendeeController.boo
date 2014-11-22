import UnityEngine

class AttendeeController (MonoBehaviour): 
	
	public direction as Vector2
	public goal as string
	
	private gameController as GameController
	private anim as Animator

	def Start ():
		anim = GetComponent[of Animator]()
		anim.speed = 3
		gameControllerObject as GameObject = GameObject.FindWithTag('GameController')
		gameController = gameControllerObject.GetComponent[of GameController]()
		RandomizeDirection()
		
	def RandomizeDirection():
		direction = Vector2(3, 0)
		rotate = 360 - (Random.value * 180)
		direction = Quaternion.AngleAxis(rotate, Vector3.forward) * direction
	
	def Update():
		if not GameController.isPlaying():
			return
		rigidbody2D.velocity = direction
		angle = Vector2.Angle(Vector2.right, direction)
		if direction.y < 0:
			angle = 360 - angle
		anim.SetInteger("BotAngle", angle)
						
	def OnCollisionStay2D(collision as Collision2D) as void:
		if collision.gameObject.layer == LayerMask.NameToLayer("Wall") or collision.gameObject.layer == LayerMask.NameToLayer("Attendees"):
			angle = (Random.value * 45) + 45
			if direction.magnitude > 3:
				direction = direction.normalized * 3
			direction = Quaternion.AngleAxis(angle, Vector3.forward) * direction
			
	def OnTriggerEnter2D(other as Collider2D) as void:
		if other.gameObject.layer == LayerMask.NameToLayer("Goals"):
			goalScript = other.gameObject.GetComponent[of GoalScript]()
			if goal == goalScript.goalName:
				gameController.AddScore()
				Destroy(gameObject)
				
			else:
				angle = (Random.value * 45) + 45
				direction = Quaternion.AngleAxis(angle, Vector3.forward) * direction
