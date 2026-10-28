(define (problem lunar-mission-1)
    (:domain lunar)

    (:objects
        Rover1 - Rover ;; Define the only rover and lander
        Lander1 - Lander

        Image1 - Photo ;; Define everything to be collected
        Scan1 - Scan
        Sample1 - Sample

        Waypoint1 Waypoint2 Waypoint3 Waypoint4 Waypoint5 - Waypoint ;; Define all the waypoints
    )

    (:init
        (Connected Waypoint1 Waypoint2) ;; All connections to build Map 1
        (Connected Waypoint1 Waypoint4)
        (Connected Waypoint2 Waypoint3)
        (Connected Waypoint3 Waypoint5)
        (Connected Waypoint4 Waypoint3)
        (Connected Waypoint5 Waypoint1)

        (Lander-not-Landed Lander1) ;; The Lander starts not landed
        (Rover-Stored Rover1)   ;; The rovers statrs stored in lander 1
        (Rover-Ownership Lander1 Rover1)    ;; Assigns rover1 to lander1

        (Collectable-Location Image1 Waypoint5) ;; Sets all the locations for all collectables in mission 1
        (Collectable-Location Scan1 Waypoint3)
        (Collectable-Location Sample1 Waypoint1)

        (Rover-Memory-Free Rover1) ;; Sets all memory and storage to start empty
        (Rover-Sample-Space-Free Rover1)
        (Lander-Sample-Space-Free Lander1)
    )

    (:goal
        (and (Data-Transmited Image1 Lander1)   ;; Deignates what data and the sample that needs to be collected and transmited/deposited in the lander
             (Data-Transmited Scan1 Lander1)
             (Sample-Deposited Sample1 Lander1)      
        )
    )
)