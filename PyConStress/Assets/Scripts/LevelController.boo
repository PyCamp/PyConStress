import UnityEngine

class LevelController (MonoBehaviour): 
	
	public static counterValue as int = 0
	
	public fisaFace as GameObject
	public gameOver as GameObject
	public title as GameObject
	public pressEnter as GameObject
	public pressSpacebar as GameObject
	public fisa as GameObject
	public attendee as GameObject
	public counter as GameObject
	public timer as GameObject
	
	public auditorio as GameObject
	public talleres as GameObject
	public comida as GameObject
	public registracion as GameObject

	playing as bool = false
	runAnimation as bool = false
	fadeDuration as double = 0.5f  # In seconds.
	fadeStartTime as double = 0
	timerValue as TextMesh
	textCounter as TextMesh
	timeLeft as int = 60
	
	# Auditorio
	# Talleres
	# Comida
	# Registracion
	goals as List = ["Auditorio", "Talleres", "Comida", "Registracion"]
	goalsColors = {
		"Comida": Color.red,
		"Talleres": Color.green,
		"Registracion": Color.blue,
		"Auditorio": Color.yellow,
	}
	
	def Start():
		Screen.SetResolution(800, 600, true)
		gameOver.SetActive(false)
		controller = auditorio.GetComponent[of GoalScript]()
		controller.goalName = goals[0]
		controller = talleres.GetComponent[of GoalScript]()
		controller.goalName = goals[1]
		controller = comida.GetComponent[of GoalScript]()
		controller.goalName = goals[2]
		controller = registracion.GetComponent[of GoalScript]()
		controller.goalName = goals[3]
		
		textCounter = counter.GetComponent[of TextMesh]()
		timerValue = timer.GetComponent[of TextMesh]()
	
	def Update():
		if Input.GetButtonDown("Start") and gameOver.active:
			Application.LoadLevel('Level001')
		elif Input.GetButtonDown("Start") and not playing:
			LevelController.counterValue = 0
			runAnimation = true
			fadeStartTime = Time.time
		elif runAnimation:
			StartGameAnimation()
		
		if playing:
			textCounter.text = LevelController.counterValue.ToString()
		
	def StartGameAnimation():
		scaleInitX = fisaFace.transform.localScale.x
		scaleInitY = fisaFace.transform.localScale.y
		t = (Time.time - fadeStartTime) / (fadeDuration*3)
		newScaleX = Mathf.SmoothStep(scaleInitX, 0.0, t)
		newScaleY = Mathf.SmoothStep(scaleInitY, 0.0, t)
		fisaFace.transform.localScale = Vector3(newScaleX, newScaleY, fisaFace.transform.localScale.z)
		if fisaFace.transform.localScale.x <= 0.2:
			playing = true
			runAnimation = false
			title.SetActive(false)
			pressEnter.SetActive(false)
			pressSpacebar.SetActive(false)
			fisaFace.SetActive(false)
			controller = fisa.GetComponent[of FisaController]()
			controller.drawDirection = true
			controller.playing = true
			
			Invoke("SpawnAttendees", 1)
			UpdateTimer()
			
	def SpawnAttendees():
		temp_attendee = Instantiate(attendee, Vector3(0, 3.8, 0), Quaternion.identity)
		goal as int = (Random.value * 4)
		controller = temp_attendee.GetComponent[of AttendeeController]()
		controller.goal = goals[goal]
		rendererSprite = temp_attendee.GetComponent[of SpriteRenderer]()
		rendererSprite.color = goalsColors[goals[goal]]
		time = (Random.value * 3) + 1
		if playing:
			Invoke("SpawnAttendees", time)
		
	def UpdateTimer():
		timeLeft -= 1
		timerValue.text = "Time: " + timeLeft.ToString()
		if timeLeft == 0:
			playing = false
			gameOver.SetActive(true)
			rendererSprite = gameOver.GetComponent[of SpriteRenderer]()
			rendererSprite.color.a = 1
		if playing:
			Invoke("UpdateTimer", 1)