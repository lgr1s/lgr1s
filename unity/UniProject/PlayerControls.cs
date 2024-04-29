using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;




public class PlayerController : MonoBehaviour
{
    public int orbCounter = 0;

    private Rigidbody playerRb;

    private float xRange = 10;
    private float zRangeBack = -22;
    private float zRangeForward = -18;
    public float speed = 0;

    public bool gameOver = true;

    CharacterController characterController;
    private GameManager gameManager;

    // Start is called before the first frame update
    void Start()
    {
        playerRb = GetComponent<Rigidbody>();
        characterController = GetComponent<CharacterController>();
        gameManager = GameObject.Find("Game Manager").GetComponent<GameManager>();
        
    }

    // Update is called once per frame
    void Update()
    {

        //Based on the input give controls to the player    
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");
        Vector3 direction = new Vector3(horizontal, 0, vertical);
        characterController.SimpleMove(direction * speed);

         Boundaries();
        //Stop any movement after game over
        if (gameOver == true)
        {
            speed = 0;
            // Freeze Rigidbody constraints to stop falling
            playerRb.constraints = RigidbodyConstraints.FreezeAll;
        }
    }

    //When colliding with other ship - game is over
    //and if colliding with orb increase the score
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Obstacle"))
        {
            Destroy(other.gameObject);
            Debug.Log("GameOver");
            gameManager.GameOver();
            gameOver = true;
        } else if (other.gameObject.CompareTag("Orb"))
        {
            Destroy(other.gameObject);
            Debug.Log("Orb Collected");
            gameManager.UpdateScore(1);
        }
    }

    //Setting boundaries for the player
    private void Boundaries()
    {
         if (transform.position.x < -xRange)
         {
             transform.position = new Vector3(-xRange,
                 transform.position.y,
                 transform.position.z);
         }

         if (transform.position.x > xRange)
         {
             transform.position = new Vector3(xRange,
                 transform.position.y,
                 transform.position.z);
         }

         if (transform.position.z < zRangeBack)
         {
             transform.position = new Vector3(transform.position.x,
                 transform.position.y,
                 zRangeBack);
         }

         if (transform.position.z > zRangeForward)
         {
             transform.position = new Vector3(transform.position.x,
                 transform.position.y,
                 zRangeForward);
         }
    }

}
