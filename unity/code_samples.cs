        if (Input.GetKeyDown(KeyCode.Space))
        {
            //Launch projectile from the player

            Instantiate(projectilePrefab, transform.position, projectilePrefab.transform.rotation);
        }
    }
}
// Coin rotation

{

    private float speed = 30f;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(Vector3.up * Time.deltaTime * speed, Space.World);
    }
}
