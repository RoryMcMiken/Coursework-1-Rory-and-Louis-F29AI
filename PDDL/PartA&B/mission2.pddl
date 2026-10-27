(define (problem lunar-mission-2)
    (:domain lunar)

    (:objects
        Rover1 Rover2 - Rover
        Lander1 Lander2 - Lander

        Image1 Image2 - Photo
        Scan1 Scan2 - Scan
        Sample1 Sample2 - Sample

        Waypoint1 Waypoint2 Waypoint3 Waypoint4 Waypoint5 Waypoint6 - Waypoint
    )

    (:init
        (Connected Waypoint1 Waypoint2)
        (Connected Waypoint2 Waypoint1)
        (Connected Waypoint2 Waypoint3)
        (Connected Waypoint2 Waypoint4)
        (Connected Waypoint3 Waypoint5)
        (Connected Waypoint4 Waypoint2)
        (Connected Waypoint5 Waypoint3)
        (Connected Waypoint5 Waypoint6)
        (Connected Waypoint6 Waypoint4)
        
        (Lander-Location Lander1 Waypoint2)
        (Rover-Location Rover1 Waypoint2)
        (Lander-not-Landed Lander2)
        (Rover-Stored Rover2)
        (Rover-Ownership Lander1 Rover1)
        (Rover-Ownership Lander2 Rover2)

        (Collectable-Location Image1 Waypoint3)
        (Collectable-Location Image2 Waypoint2)
        (Collectable-Location Scan1 Waypoint4)
        (Collectable-Location Scan2 Waypoint6)
        (Collectable-Location Sample1 Waypoint5)
        (Collectable-Location Sample2 Waypoint1)

        (Lander-Sample-Space-Free Lander1)
        (Lander-Sample-Space-Free Lander2)
        (Rover-Memory-Free Rover1)
        (Rover-Sample-Space-Free Rover1)
        (Rover-Memory-Free Rover2)
        (Rover-Sample-Space-Free Rover2)
    )

    (:goal
        (and (Data-Transmited Image1 Lander1)
             (Data-Transmited Image2 Lander2)
             (Data-Transmited Scan1 Lander2)
             (Data-Transmited Scan2 Lander1)
             (Sample-Deposited Sample1 Lander1)
             (Sample-Deposited Sample2 Lander2)
        )
    )
)