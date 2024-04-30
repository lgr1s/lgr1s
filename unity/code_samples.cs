        if (Input.GetKeyDown(KeyCode.Space))
        {
            //Launch projectile from the player

            Instantiate(projectilePrefab, transform.position, projectilePrefab.transform.rotation);
        }
    }
}
