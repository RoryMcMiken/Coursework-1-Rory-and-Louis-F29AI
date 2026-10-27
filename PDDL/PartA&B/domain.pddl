(define (domain lunar)
    (:requirements :strips :typing)

    (:types
        Rover Lander Waypoint Collectable - object
        Data Sample - Collectable
        Scan Photo - Data 
    )

    (:predicates
        (Rover-Location ?rover - Rover ?location - Waypoint) ;; Saves the rovers location
        (Lander-Location ?lander - Lander ?location - Waypoint) ;; Saves the lander location
        (Collectable-Location ?collectable - Collectable ?location - Waypoint) ;; Saves the location of each thing that need to be collected

        (Rover-Ownership ?lander - Lander ?rover - Rover) ;; Lets the rover know which lander it is connected to
        (Rover-Stored ?rover - Rover) ;; Lets the rover know if it is still stored in a lander
        (Lander-not-Landed ?lander - Lander) ;; Checks if the Lander has landed yet so it can't land in multiple locations

        (Lander-Sample-Space-Free  ?lander - Lander) ;; Checks if the landers can accept a sample
        (Rover-Memory-Free ?rover - Rover) ;; Checks if a rover can collect another photo or scan
        (Rover-Sample-Space-Free  ?rover - Rover) ;; Checks if a rover can collect another sample

        (Connected ?from - Waypoint ?to - Waypoint) ;; Links 2 way points together so a rover can travel between them

        (Data-Transmited ?data - Data ?lander - Lander) ;; Checks if data has been transmited to a lander. This is a goal condition
        (Sample-Deposited ?sample - Sample ?lander - Lander) ;; Checks if a sample has been deposited in a lander. This is a goal condition
        (Rover-Data-Stored ?rover - Rover ?data - Data) ;; Checks if Data is already stored in a rover. The opposite of Rover-Memory-Free
        (Rover-Sample-Stored ?rover - Rover ?sample - Sample) ;; Checks if a sample is stored in a rover. The opposite of Rover-Sample-Space-Free
    )

    (:action Move
        :parameters (?rover - Rover ?from - Waypoint ?to - Waypoint)
        :precondition (and (Rover-Location ?rover ?from)
                           (Connected ?from ?to))

        :effect (and (Rover-Location ?rover ?to)
                     (not (Rover-Location ?rover ?from)))
    )

    (:action Deploy
        :parameters (?lander - Lander ?rover - Rover ?location - Waypoint)
        :precondition (and (Rover-Stored ?rover)
                           (Rover-Ownership ?lander ?rover)
                           (Lander-Location ?lander ?location))
        :effect (and (Rover-Location ?rover ?location)
                     (not (Rover-Stored ?rover)))
    )

    (:action Land-Lander
        :parameters (?lander - Lander ?location - Waypoint)
        :precondition (Lander-not-Landed ?lander)
        :effect (and (not (Lander-not-Landed ?lander))
                     (Lander-Location ?lander ?location))
    )
    

    (:action Capture-Data
        :parameters (?rover - Rover ?data - Data ?location - Waypoint)
        :precondition (and (Collectable-Location ?data ?location)
                           (Rover-Location ?rover ?location)
                           (Rover-Memory-Free ?rover))
        :effect (and (not (Rover-Memory-Free ?rover))
                     (not (Collectable-Location ?data ?location))
                     (Rover-Data-Stored ?rover ?data))
    )
    
    (:action Collect-Sample
        :parameters (?rover - Rover ?sample - Sample ?location - Waypoint)
        :precondition (and (Collectable-Location ?sample ?location)
                           (Rover-Sample-Space-Free ?rover)
                           (Rover-Location ?rover ?location))
        :effect (and (not (Collectable-Location ?sample ?location))
                     (not (Rover-Sample-Space-Free ?rover))
                     (Rover-Sample-Stored ?rover ?sample))
    )

    (:action Transmit-Data
        :parameters (?rover - Rover ?lander - Lander ?data - Data)
        :precondition (and (Rover-Data-Stored ?rover ?data)
                           (Rover-Ownership ?lander ?rover))
        :effect (and (not (Rover-Data-Stored ?rover ?data))
                     (Data-Transmited ?data ?lander)
                     (Rover-Memory-Free ?rover))
    )

    (:action Deposit-Sample
        :parameters (?rover - Rover ?lander - Lander ?sample - Sample ?location - Waypoint)
        :precondition (and (Rover-Location ?rover ?location)
                           (Lander-Location ?lander ?location)
                           (Rover-Ownership ?lander ?rover)
                           (Rover-Sample-Stored ?rover ?sample)
                           (Lander-Sample-Space-Free ?lander))
        :effect (and (not (Lander-Sample-Space-Free ?lander))
                     (not (Rover-Sample-Stored ?rover ?sample))
                     (Sample-Deposited ?sample ?lander)
                     (Rover-Sample-Space-Free  ?rover))
    )
)