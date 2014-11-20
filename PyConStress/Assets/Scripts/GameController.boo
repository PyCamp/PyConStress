import UnityEngine
import System.Collections

class GameController (MonoBehaviour): 
	
	# Level GameObjects
	public fisaFace as GameObject
	public gameOver as GameObject
	public pressSpacebar as GameObject
	public gameOverMessage as GameObject
	public fisa as GameObject
	public attendee as GameObject
	public auditorio as GameObject
	public talleres as GameObject
	public comida as GameObject
	public registracion as GameObject
	# GUI
	public score as GUIText
	public timer as GUIText
	# Audio
	public bot as AudioClip
	private sound as AudioSource

	# Logic Variables
	private runStartAnimation as bool = false
	private fadeDuration as double = 2.0f  # In seconds.
	private fadeStartTime as double = 0
	private maxBots as int = 10
	
	private static playing as bool = false
	private static scoreValue as int = 0
	private static timeLeft as int = 30
	private static botsCounter as int = 0
	
	private playerName as string = ''
	
	# GOALS:
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
		
	static def isPlaying():
		return playing
		
	public def AddScore():
		scoreValue += 1
		botsCounter -= 1
		timeLeft += 2
		
		score.text = "Score: " + scoreValue.ToString()
		
	def OnGUI() as void:
		if not playing and gameOver.activeSelf:
			GUILayout.BeginArea(Rect(350, 2, 230, 20))
			GUILayout.Label('Player Name:')
			GUILayout.EndArea()
			playerName = GUI.TextField(Rect(250, 20, 300, 20), playerName, 50)
			GUILayout.BeginArea(Rect(320, 45, 300, 70))
			if GUILayout.Button('Save Score!', GUILayout.Width (150)):
				SaveScore()
			if GUILayout.Button('Tweet your Score!', GUILayout.Width (150)):
				TweetScore()
			GUILayout.EndArea()
	
	def Start():
		sound = GetComponent[of AudioSource]()
		Screen.SetResolution(800, 600, true)
		gameOver.SetActive(false)
		gameOverMessage.SetActive(false)
		controller = auditorio.GetComponent[of GoalScript]()
		controller.goalName = goals[0]
		controller = talleres.GetComponent[of GoalScript]()
		controller.goalName = goals[1]
		controller = comida.GetComponent[of GoalScript]()
		controller.goalName = goals[2]
		controller = registracion.GetComponent[of GoalScript]()
		controller.goalName = goals[3]
		
		scoreValue = 0
		timeLeft = 30
		botsCounter = 0
		
		runStartAnimation = true
		fadeStartTime = Time.time
	
	def Update():
		if Input.GetButtonDown("Start") and gameOver.activeSelf:
			SaveScore()
			Application.LoadLevel('Menu')
		if runStartAnimation:
			StartGameAnimation()
		
	private def StartGameAnimation():
		scaleInitX = fisaFace.transform.localScale.x
		scaleInitY = fisaFace.transform.localScale.y
		t = (Time.time - fadeStartTime) / (fadeDuration*3)
		newScaleX = Mathf.SmoothStep(scaleInitX, 0.0, t)
		newScaleY = Mathf.SmoothStep(scaleInitY, 0.0, t)
		fisaFace.transform.localScale = Vector3(newScaleX, newScaleY, fisaFace.transform.localScale.z)
		textMesh = pressSpacebar.GetComponent[of TextMesh]()
		opacity = Mathf.SmoothStep(textMesh.color.a, 0.0, t)
		textMesh.color.a = opacity
		if fisaFace.transform.localScale.x <= 0.2:
			playing = true
			runStartAnimation = false
			pressSpacebar.SetActive(false)
			fisaFace.SetActive(false)
			
			StartCoroutine(SpawnBots())
			UpdateTimer()
			
	private def SpawnBots() as IEnumerator:
		yield WaitForSeconds(1)
		while playing:
			sound.PlayOneShot(bot, 1)
			temp_attendee = Instantiate(attendee, Vector3(0, 3.8, 0), Quaternion.identity)
			goal as int = (Random.value * 4)
			controller = temp_attendee.GetComponent[of AttendeeController]()
			controller.goal = goals[goal]
			rendererSprite = temp_attendee.GetComponent[of SpriteRenderer]()
			rendererSprite.color = goalsColors[goals[goal]]
			botsCounter += 1
			if botsCounter == maxBots:
				EndGame()
			time = (Random.value * 2) + 1
			yield WaitForSeconds(time)
			
	private def UpdateTimer():
		timeLeft -= 1
		timer.text = "Time: " + timeLeft.ToString()
		if timeLeft == 0:
			mesh = gameOverMessage.GetComponent[of TextMesh]()
			mesh.text = "Time out!"
			EndGame()
		if playing:
			Invoke("UpdateTimer", 1)
			
	private def EndGame():
		playing = false
		gameOver.SetActive(true)
		mesh = pressSpacebar.GetComponent[of TextMesh]()
		mesh.text = "Press Enter to Play Again"
		mesh.color.a = 1
		pressSpacebar.SetActive(true)
		gameOverMessage.SetActive(true)
		
	private def SetServerScore() as IEnumerator:
		www as WWW = WWW("http://stress.pyconference.org/api/publish_score/?token=TOKEN&score=" + scoreValue + "&player=" + playerName)
		yield www
		Application.LoadLevel('Menu')
		
	private def TweetScore():
		Application.OpenURL('https://twitter.com/intent/tweet?text=Played%20PyCon%20Stress%20(http://stress.pyconference.org)%20and%20scored%20' + scoreValue + '!!%20%23PyConStress')
		
	private def SaveScore():
		# For Web Player
		Application.ExternalCall('setServerScore', playerName, scoreValue)
		Application.LoadLevel('Menu')
		# For Desktop Client
#		StartCoroutine(SetServerScore())