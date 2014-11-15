import UnityEngine

import LevelController

class AttendeeController (MonoBehaviour): 
	
	public direction as Vector2
	
	public goal as string
	
	anim as Animator

	def Start ():
		anim = GetComponent[of Animator]()
		RandomizeDirection()
		
	def RandomizeDirection():
		direction = Vector2(3, 0)
		rotate = 360 - (Random.value * 180)
		direction = Quaternion.AngleAxis(rotate, Vector3.forward) * direction
	
	def Update():
		rigidbody2D.velocity = direction
		angle = Vector2.Angle(Vector2.right, direction)
		if direction.y < 0:
				angle = 360 - angle
		anim.SetInteger("BotAngle", angle)
		
	def OnCollisionStay2D(collision as Collision2D) as void:
		if collision.gameObject.layer == LayerMask.NameToLayer("Wall") or collision.gameObject.layer == LayerMask.NameToLayer("Attendees"):
			angle = (Random.value * 45) + 45
			direction = Quaternion.AngleAxis(angle, Vector3.forward) * direction
			
	def OnCollisionEnter2D(collision as Collision2D) as void:
		if collision.gameObject.layer == LayerMask.NameToLayer("Goals"):
			goalScript = collision.gameObject.GetComponent[of GoalScript]()
			if goal == goalScript.goalName:
				LevelController.counterValue += 1
				Destroy(gameObject)
			else:
				angle = (Random.value * 45) + 45
				direction = Quaternion.AngleAxis(angle, Vector3.forward) * direction
