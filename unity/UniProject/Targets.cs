using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Targets : MonoBehaviour
{

    public float speed;

    private float bottomBound = -30;
    private GameManager gameManager;

    //Setting increased speed for each prefab
    public void IncreaseSpeed(float newSpeed)
    {
        speed = newSpeed;
    }

    // Start is called before the first frame update
    void Start()
    {
        gameManager = GameObject.Find("Game Manager").GetComponent<GameManager>();
    }

    // Update is called once per frame
    void Update()
    {
        //speed += gameManager.targetSpeedIncrease;
        // If game is active move targets towards player
        if (gameManager.isGameActive == true) {
            transform.Translate(Vector3.back * Time.deltaTime * speed);
        }
        
        // If out of bound: Destroy target
        if (transform.position.z < bottomBound)
        {
            Destroy(gameObject);
        }

    }




}
