(define (problem lunar-mission-3)
    (:domain lunar-extended)

    (:objects
        Rover1 Rover2 - Rover   ;; Define both rovers and landers
        Lander1 Lander2 - Lander

        Image1 Image2 - Photo   ;; Defines all the things that need to be collected
        Scan1 Scan2 - Scan
        Sample1 Sample2 - Sample

        Waypoint1 Waypoint2 Waypoint3 Waypoint4 Waypoint5 Waypoint6 - Waypoint  ;; All the waypoints needed to build the map for mission 2

        Bob Alice - Astronaut   ;; Desfines both astronauts

        Docking-Bay1 Docking-Bay2 - Docking-Bay ;; Creates both rooms for each lander
        Control-Room1 Control-Room2 - Control-Room
    )

    (:init
        (Connected Waypoint1 Waypoint2) ;; All the connections used to build the map in figure 3 for mission 2
        (Connected Waypoint2 Waypoint1)
        (Connected Waypoint2 Waypoint3)
        (Connected Waypoint2 Waypoint4)
        (Connected Waypoint3 Waypoint5)
        (Connected Waypoint4 Waypoint2)
        (Connected Waypoint5 Waypoint3)
        (Connected Waypoint5 Waypoint6)
        (Connected Waypoint6 Waypoint4)
        
        (Lander-Location Lander1 Waypoint2) ;; Sets the starting location for rover and lander 1 as they start landed and deployed
        (Rover-Location Rover1 Waypoint2)
        (Lander-not-Landed Lander2) ;; Lander and rover 2 don't start landed or deployed so we define that here
        (Rover-Stored Rover2)
        (Rover-Ownership Lander1 Rover1)    ;; Sets the proper connection between rover and lander 1 and rover and lander 2
        (Rover-Ownership Lander2 Rover2)

        (Collectable-Location Image1 Waypoint3) ;; Sets the location for every collectable in the mission
        (Collectable-Location Image2 Waypoint2)
        (Collectable-Location Scan1 Waypoint4)
        (Collectable-Location Scan2 Waypoint6)
        (Collectable-Location Sample1 Waypoint5)
        (Collectable-Location Sample2 Waypoint1)

        (Lander-Sample-Space-Free Lander1)  ;; Sets all memory and storage to start empty
        (Lander-Sample-Space-Free Lander2)
        (Rover-Memory-Free Rover1)
        (Rover-Sample-Space-Free Rover1)
        (Rover-Memory-Free Rover2)
        (Rover-Sample-Space-Free Rover2)

        (Lander-Room-Connection Lander1 Control-Room1)  ;; Connects a control room and a docking bay to each lander
        (Lander-Room-Connection Lander1 Docking-Bay1)
        (Lander-Room-Connection Lander2 Control-Room2)
        (Lander-Room-Connection Lander2 Docking-Bay2)

        (Astronaut-Lander Alice Lander1)    ;; Links an astronaut to is designated lander so they don't travel to other lander
        (Astronaut-Lander Bob Lander2)

        (Astronaut-Room Alice Docking-Bay1) ;; Puts an astronaut in their starting rooms within their lander
        (Astronaut-Room Bob Control-Room2)
    )

    (:goal
        (and (Data-Transmited Image1 Lander1)   ;; Deignates what data and the sample that needs to be collected and transmited/deposited in the lander
             (Data-Transmited Image2 Lander2)
             (Data-Transmited Scan1 Lander2)
             (Data-Transmited Scan2 Lander1)
             (Sample-Deposited Sample1 Lander1)
             (Sample-Deposited Sample2 Lander2)
        )
    )
)