(define (domain lunar-extended)
    (:requirements :strips :typing)

    (:types
        Rover Lander Waypoint Collectable Astronaut Room - object
        Data Sample - Collectable
        Scan Photo - Data 
        Control-Room Docking-Bay - Room
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
    
        (Astronaut-Lander ?astronaut - Astronaut ?lander - Lander)  ;; Allows a lander and astronaut to be linked which is used to make sure astronauts dont travel between landers
        (Astronaut-Room ?astronaut - Astronaut ?room - Room)    ;; Saves the room that an astronaut is currently in 
        (Lander-Room-Connection ?lander - Lander ?room - Room)  ;; Links a room to a lander which lets us say which room is in which lander
    )

    (:action Move   ;; Allows Rovers to move between waypoints
        :parameters (?rover - Rover ?from - Waypoint ?to - Waypoint)
        :precondition (and (Rover-Location ?rover ?from)    ;; Checks if the rover is actually at the waypoint it is traveling from
                           (Connected ?from ?to))   ;; Checks if the waypoint we are at is connected to the one we want to go to
        :effect (and (Rover-Location ?rover ?to)
                     (not (Rover-Location ?rover ?from)))
    )

    (:action Deploy ;; Deploys the Rover from the lander so it can begin moving
        :parameters (?lander - Lander ?rover - Rover ?location - Waypoint ?astronaut - Astronaut ?room - Docking-Bay)
        :precondition (and (Rover-Stored ?rover)    ;; Checks that the rover we want to check is stored within a lander
                           (Rover-Ownership ?lander ?rover) ;; Checks that the lander we want to deploy the rover from is the one the rover is in
                           (Lander-Location ?lander ?location) ;; Checks that the waypoint where we are deploying the lander to is the waypoint the lander is actually at
                           (Astronaut-Lander ?astronaut ?lander) ;; Ensures that the astronaut doing the task in the docking bay belongs to the correct lander
                           (Astronaut-Room ?astronaut ?room)    ;; Checks that the astronaut is in the correct room to do the deploy task
                           (Lander-Room-Connection ?lander ?room))  ;; Checks that the room the astronaut is in belongs to the correct lander
        :effect (and (Rover-Location ?rover ?location)
                     (not (Rover-Stored ?rover)))
    )

    (:action Land-Lander    ;; Allows any lander that dosent start landed to pick which waypoint it wants to land at
        :parameters (?lander - Lander ?location - Waypoint)
        :precondition (Lander-not-Landed ?lander)   ;; We only check if the lander isnt yet landed as it can choose to land anywhere
        :effect (and (not (Lander-not-Landed ?lander))
                     (Lander-Location ?lander ?location))
    )
    

    (:action Capture-Data   ;; Lets the rover capture data either a scan or photo and store it in its memory
        :parameters (?rover - Rover ?data - Data ?location - Waypoint)
        :precondition (and (Collectable-Location ?data ?location)   ;; Checks the data we are collecting is at the current waypoint we are at
                           (Rover-Location ?rover ?location)    ;; Checks that the rover is also at the current waypoint so with the above precondition we ensure both the rover and data are at the same waypoint
                           (Rover-Memory-Free ?rover))  ;; Checks if the rovers memory is free to see if it can collect another peice of data
        :effect (and (not (Rover-Memory-Free ?rover))
                     (not (Collectable-Location ?data ?location))
                     (Rover-Data-Stored ?rover ?data))
    )
    
    (:action Collect-Sample ;; Lets the rover collect a sample from its current waypoint and hold it in its storage
        :parameters (?rover - Rover ?sample - Sample ?location - Waypoint)
        :precondition (and (Collectable-Location ?sample ?location) ;; Checks that the sample we are collecting is at the same waypoint the rover is at
                           (Rover-Sample-Space-Free ?rover) ;; Checks that the rovers has the space to collect a sample 
                           (Rover-Location ?rover ?location))   ;; Checks that the rover is also at the currnt waypoint
        :effect (and (not (Collectable-Location ?sample ?location))
                     (not (Rover-Sample-Space-Free ?rover))
                     (Rover-Sample-Stored ?rover ?sample))
    )

    (:action Transmit-Data  ;; Lets the rover send collected data back to its lander wirelessly
        :parameters (?rover - Rover ?lander - Lander ?data - Data ?astronaut - Astronaut ?room - Control-Room)
        :precondition (and (Rover-Data-Stored ?rover ?data) ;; Checks that the rover is actually carrying data that could be transmited 
                           (Rover-Ownership ?lander ?rover) ;; Checks if the lander we are trying to send the data to is the same one the rover is linked with
                           (Astronaut-Lander ?astronaut ?lander)    ;; Checks that the astronaut in the control room is the one that belongs to the lander
                           (Astronaut-Room ?astronaut ?room)    ;; Checks that the astronaut is in the control room
                           (Lander-Room-Connection ?lander ?room))  ;; Checks that the control room that is being used actually belongs to the correct lander
        :effect (and (not (Rover-Data-Stored ?rover ?data))
                     (Data-Transmited ?data ?lander)
                     (Rover-Memory-Free ?rover))
    )

    (:action Deposit-Sample ;; Lets the rover deposit its held sample into its lander
        :parameters (?rover - Rover ?lander - Lander ?sample - Sample ?location - Waypoint ?astronaut - Astronaut ?room - Docking-Bay)
        :precondition (and (Rover-Location ?rover ?location)    ;; Checks that the rovers location matches the landers also using the percondition below
                           (Lander-Location ?lander ?location)  ;; Checks that the location of the lander is the same as the location of the rover  
                           (Rover-Ownership ?lander ?rover)     ;; Makes sure the lander the rover is trying to deposit into is the one it is linked with
                           (Rover-Sample-Stored ?rover ?sample) ;; Checks if the rover is actually carrying the sample it is trying to store
                           (Lander-Sample-Space-Free ?lander)   ;; Checks if the landers sample space is empty so it can recieve a sample
                           (Astronaut-Lander ?astronaut ?lander)    ;; Checks that the astronaut in the control room is the one that belongs to the lander
                           (Astronaut-Room ?astronaut ?room)    ;; Checks that the astronaut is the in docking bay
                           (Lander-Room-Connection ?lander ?room))  ;; Checks that the docking bay that is being used actually belongs to the correct lander
        :effect (and (not (Lander-Sample-Space-Free ?lander))
                     (not (Rover-Sample-Stored ?rover ?sample))
                     (Sample-Deposited ?sample ?lander)
                     (Rover-Sample-Space-Free  ?rover))
    )

    (:action Astronaut-Move ;; Allows astronauts to move between the rooms in their landers
        :parameters (?lander - Lander ?astronaut - Astronaut ?from - Room ?to - Room)
        :precondition (and (Astronaut-Room ?astronaut ?from)    ;; Checks that the astronaut starts in the room they are travling from
                           (Lander-Room-Connection ?lander ?to) ;; Along with the precondition below we ensure that both rooms are in the same lander
                           (Lander-Room-Connection ?lander ?from)
                           (Astronaut-Lander ?astronaut ?lander))   ;; Checks that the astronaut traveling belongs to the lander they are traveling within
        :effect (and (not (Astronaut-Room ?astronaut ?from))
                     (Astronaut-Room ?astronaut ?to))
    )
)