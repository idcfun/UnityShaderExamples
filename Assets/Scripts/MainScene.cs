using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainScene : MonoBehaviour {
	private void OnGUI()
    {
        if (GUILayout.Button("DepthOutline"))
		{
			SceneManager.LoadScene("DepthOutlineScene");
		}

		if (GUILayout.Button("BumpScene"))
		{
			SceneManager.LoadScene("BumpScene");
		}
	}
}
