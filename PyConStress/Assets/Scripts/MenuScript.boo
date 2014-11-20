import UnityEngine

class MenuScript (MonoBehaviour): 

	public isScore as bool = false

	def OnMouseEnter():
		renderer.material.color=Color.green;

	def OnMouseExit():
		renderer.material.color=Color.white;

	def OnMouseUp():
		if isScore:
			Application.OpenURL('http://stress.pyconference.org/scores')
		else:
			Application.LoadLevel('Level001')
			
	def Update():
		if Input.GetButtonDown("Start"):
			Application.LoadLevel('Level001')