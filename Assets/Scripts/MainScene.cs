using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainScene : MonoBehaviour {
	private void OnGUI()
    {
        if (GUILayout.Button("Load Depth Outline Scene"))
		{
			SceneManager.LoadScene("DepthOutlineScene");
		}
	}
}
