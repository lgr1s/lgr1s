using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;
using UnityEngine.UI;


public class GameManager : MonoBehaviour
{
    public List<GameObject> targets;

    public Targets targetScript;
    private PlayerController playerControllerScript;

    //Positions for targets to spawn
    private static float spawnPosx = 10;
    private static float spawnPosz = 72.5f;

    public bool isGameActive;
    private float spawnRate = 2;
    private int score = 0;
    private float timeElapse = 0;
    private float initialSpawnRate = 2;
    private float minSpawnRate = 0.3f;
    private float targetSpeedIncrease = 0.01f;
    public float targetInitialSpeed = 10f;


    public TextMeshProUGUI scoreText;
    public TextMeshProUGUI gameOverText;
    public Button restartButton;
    public Button startGameButton;
    // Start is called before the first frame update
    void Start()
    {
        playerControllerScript = GameObject.Find("Player").GetComponent<PlayerController>();
    }

    //Used to increase speed of preafabs every second
    IEnumerator IncreaseSpeedOverTime()
    {
        while (isGameActive)
        {
            yield return new WaitForSeconds(1); 
            targetInitialSpeed += targetSpeedIncrease;
        }
    }

    //Spawning targets every seceond and then speeds up
    IEnumerator SpawnTarget()
    {
        while (isGameActive)
        {
            yield return new WaitForSeconds(spawnRate);
            //Reduces the spawn rate
            timeElapse += spawnRate;
            float newSpawnRate = initialSpawnRate - (timeElapse * 0.01f);
            //Spawn rate can not go lower than 0.3 seconds
            spawnRate = Mathf.Max(newSpawnRate, minSpawnRate);
            //Spawns either ship or Orb
            int index = Random.Range(0, targets.Count);
            //Spawn coordinates are random
            Vector3 spawnPos = new Vector3(Random.Range(-spawnPosx, spawnPosx), 0.6f, spawnPosz);
            //Creating the instance of prefab
            GameObject newTarget = Instantiate(targets[index], spawnPos, targets[index].transform.rotation);
            targetScript = newTarget.GetComponent<Targets>();
            //Increasing the speed of prefab
            targetScript.IncreaseSpeed(targetInitialSpeed);
        }

    }

    //Updates score after every collected orb. See reference in PlayerController
    public void UpdateScore(int scoreToAdd)
    {
        score += scoreToAdd;
        scoreText.text = "Score: " + score;
    }

    //If game is over stops objects from spawning and makes button and text visible.
    //Game is over when player collides with ship
    public void GameOver()
    {
        gameOverText.gameObject.SetActive(true);
        restartButton.gameObject.SetActive(true);
        isGameActive = false;
    }
    //Reloads the player scene when the restart button is pressed
    public void RestartGame()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }
    //Starts spawning objects, allows movement for the player when Start Game button is pressed
    public void StartGame()
    {
        isGameActive = true;
        score = 0;

        StartCoroutine(IncreaseSpeedOverTime());
        StartCoroutine(SpawnTarget());
        UpdateScore(0);

        playerControllerScript.speed = 10f;

        startGameButton.gameObject.SetActive(false);
    }

}
