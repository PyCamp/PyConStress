import UnityEngine

class FisaController (MonoBehaviour): 

	public direction as Vector2
	public hand as GameObject
	
	public anda1 as AudioClip
	public anda2 as AudioClip
	public veni1 as AudioClip
	public veni2 as AudioClip
	
	private anim as Animator
	private catched as GameObject = null
	private fisaLayer as int
	private attendeeLayer as int
	private vectorLength as int = 6
	
	private sound as AudioSource
	
	private soundBoard as List = []
	
	def Start():
		direction = Vector2(0, -6)
		anim = GetComponent[of Animator]()
		fisaLayer = LayerMask.NameToLayer("Fisa")
		attendeeLayer = LayerMask.NameToLayer("Attendees")
		sound = GetComponent[of AudioSource]()
		soundBoard = [anda1, anda2, veni1, veni2]
		
		angle = Vector2.Angle(Vector2.right, direction)
		if direction.y < 0:
			angle = 360 - angle
		hand.transform.position = transform.position + direction / (vectorLength + 5)
		hand.transform.position.z = -1
		hand.transform.eulerAngles.z = angle
		
	def Update ():
		if not GameController.isPlaying():
			return
		move = Input.GetAxis("Vertical")
		rotate = Input.GetAxis("Horizontal")
		if rotate:
			direction = Quaternion.AngleAxis(rotate * -5.0, Vector3.forward) * direction
			angle = Vector2.Angle(Vector2.right, direction)
			if direction.y < 0:
				angle = 360 - angle
			anim.SetInteger("FisaAngle", angle)
			hand.transform.position = transform.position + direction / (vectorLength + 5)
			hand.transform.position.z = -1
			hand.transform.eulerAngles.z = angle
				
		if move > 0:
			rigidbody2D.velocity = direction
			anim.speed = 1
		elif move < 0:
			rigidbody2D.velocity = -direction
			anim.speed = 1
		else:
			rigidbody2D.velocity = Vector2(0, 0)
			anim.speed = 0
			
		if catched and Input.GetButtonDown("Release"):
			index as int = Random.value
			sound.PlayOneShot(soundBoard[index], 1)
			controller = catched.GetComponent[of AttendeeController]()
			controller.direction = direction / 2
			catched = null
			Invoke("BotReleased", 0.5f)
		elif catched:
			catched.transform.position = transform.position + direction / vectorLength
		else:
			BotReleased()	
			
	private def BotReleased():
		Physics2D.IgnoreLayerCollision(fisaLayer, attendeeLayer, false)
		rendererSprite = GetComponent[of SpriteRenderer]()
		rendererSprite.color.a = 1f
		rendererSprite = hand.GetComponent[of SpriteRenderer]()
		rendererSprite.color.a = 1f
			
	def OnCollisionStay2D(collision as Collision2D) as void:
		if collision.gameObject.layer == LayerMask.NameToLayer("Attendees") and GameController.isPlaying():
			index as int = Random.value + 2
			sound.PlayOneShot(soundBoard[index], 1)
			Physics2D.IgnoreLayerCollision(fisaLayer, attendeeLayer, true)
			rendererSprite = GetComponent[of SpriteRenderer]()
			rendererSprite.color.a = 0.5f
			rendererSprite = hand.GetComponent[of SpriteRenderer]()
			rendererSprite.color.a = 0.5f
			controller = collision.gameObject.GetComponent[of AttendeeController]()
			controller.direction = Vector2(0, 0)
			catched = collision.gameObject