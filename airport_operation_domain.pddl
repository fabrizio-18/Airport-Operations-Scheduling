(define (domain airport-operations)
  (:requirements :strips :typing :numeric-fluents :conditional-effects :action-costs) 

  (:types 
    plane runway gate - object
  )

  (:predicates
    ;; State predicates
    (plane-at ?p - plane ?l - object)   ; Plane is at a location (runway or gate)
    (gate-available ?g - gate)         	; A gate is available for assignment
    (runway-available ?r - runway)     	; A runway is free for landing or takeoff
    (waiting-to-land ?p - plane)       	; Plane is waiting to land
    (plane-takenoff ?p - plane)        	; Plane taken off
    (passengers-loaded ?p - plane)     	; Passengers boarded from the gate
    (has-unloaded-passengers ?p - plane)
    (has-loaded-passengers ?p - plane)
    (assigned-gate ?p -plane ?g -gate) 	; Plane has assigned gate
    (priority ?p - plane)	       	; High-priority VIP plane
  )

  (:functions
    (taxi-time ?p - plane ?g - gate)   ; Time needed to taxi from gate to runway
    (fuel-level ?p - plane)            ; Amount of fuel remaining in the plane
    (fuel-consumption-rate ?p - plane) ; Fuel consumption per action
    (total-cost)
  )

  ;; Land Plane
  (:action land-plane
    :parameters (?p - plane ?r - runway)
    :precondition (and
      (waiting-to-land ?p)
      (runway-available ?r)
      (passengers-loaded ?p)
      (or
          (priority ?p)
          (forall (?p2 - plane)
            (not          
              (and 
                (priority ?p2) 
                (waiting-to-land ?p2)
              )       
            )
          )
        )
    )
    :effect (and
      (not (waiting-to-land ?p))
      (not (runway-available ?r))
      (plane-at ?p ?r)
      (decrease (fuel-level ?p) (* 2 (fuel-consumption-rate ?p)))
      (increase (total-cost) (* 2 (fuel-consumption-rate ?p)))
    )
  )

  (:action taxi-to-assigned-gate
  :parameters (?p - plane ?r - runway ?g - gate)
  :precondition (and
    (plane-at ?p ?r)
    (gate-available ?g)
    (passengers-loaded ?p)
    (assigned-gate ?p ?g)
    (or
          (priority ?p)
          (forall (?p2 - plane)
            (not          
              (and 
                (priority ?p2) 
                (or (plane-at ?p2 ?g)(exists (?r2 - runway)(plane-at ?p2 ?r2)))
              )       
            )
          )
        )
    (>= (fuel-level ?p) (* (taxi-time ?p ?g) (fuel-consumption-rate ?p)))
  )
  :effect (and
    (not (plane-at ?p ?r))
    (not (gate-available ?g))
    (plane-at ?p ?g)
    (runway-available ?r)
    (decrease (fuel-level ?p) (* (taxi-time ?p ?g) (fuel-consumption-rate ?p)))
    (increase (total-cost) (* (taxi-time ?p ?g) (fuel-consumption-rate ?p))) 
  )
)

  ;; Taxi to Gate
  (:action taxi-to-gate
    :parameters (?p - plane ?r - runway ?g - gate)
    :precondition (and
        (plane-at ?p ?r)
        (gate-available ?g)
        (forall (?g2 - gate) (not (assigned-gate ?p ?g2)))
        (passengers-loaded ?p)
        (or
          (priority ?p)
          (forall (?p2 - plane)
            (not          
              (and 
                (priority ?p2) 
                (or (plane-at ?p2 ?g)(exists (?r2 - runway)(plane-at ?p2 ?r2)))
              )       
            )
          )
        )
        (>= (fuel-level ?p) (* (taxi-time ?p ?g) (fuel-consumption-rate ?p)))  
    )
    :effect (and
      (not (plane-at ?p ?r))
      (plane-at ?p ?g)
      (not (gate-available ?g))
      (runway-available ?r)
      (decrease (fuel-level ?p) (* (taxi-time ?p ?g) (fuel-consumption-rate ?p)))
      (increase (total-cost) (* (taxi-time ?p ?g) (fuel-consumption-rate ?p))) 
    )
  )

  (:action unload-passengers
  :parameters (?p - plane ?g - gate)
  :precondition (and
      (plane-at ?p ?g)
      (passengers-loaded ?p)
      
    )
    :effect (and
      (not (passengers-loaded ?p)) 
      (has-unloaded-passengers ?p)
      (not (has-loaded-passengers ?p))
      (increase (total-cost) 0)
    )
  )

  ( :action load-passengers
  :parameters (?p - plane ?g - gate)
  :precondition (and
      (plane-at ?p ?g)
      (has-unloaded-passengers ?p)
    )
    :effect (and
      (has-loaded-passengers ?p)
      (increase (total-cost) 0)
    )
)
;; Refuel Plane 
  (:action refuel-plane
    :parameters (?p - plane ?g - gate)
    :precondition (and 
    (plane-at ?p ?g)
    (<= (fuel-level ?p) (+ (* (taxi-time ?p ?g) (fuel-consumption-rate ?p)) 10))
    )
    :effect (and 
      (increase (fuel-level ?p) 50)
      (increase (total-cost) 0)
    )
  )

  ;; Taxi to Runway 
  (:action taxi-to-runway
    :parameters (?p - plane ?g - gate ?r - runway)
    :precondition (and
      (plane-at ?p ?g)
      (runway-available ?r)
      (has-loaded-passengers ?p)
      (or
        (priority ?p)
        (forall (?p2 - plane)
          (not          
            (and 
              (priority ?p2) 
              (or (plane-at ?p2 ?r)(exists (?g2 - gate)(plane-at ?p2 ?g2)))
            )       
          )
        )
      )
      (>= (fuel-level ?p) (+ (* (taxi-time ?p ?g) (fuel-consumption-rate ?p)) 10)) ; Ensure enough fuel
    )
    :effect (and
      (not (plane-at ?p ?g))
      (not (runway-available ?r))
      (plane-at ?p ?r)
      (decrease (fuel-level ?p) (* (taxi-time ?p ?g) (fuel-consumption-rate ?p)))
      (increase (total-cost) (* (taxi-time ?p ?g) (fuel-consumption-rate ?p)))  
    )
  )

  ;; Takeoff 
  (:action takeoff
    :parameters (?p - plane ?r - runway)
    :precondition (and
      (plane-at ?p ?r)
      (has-loaded-passengers ?p)
      (or
        (priority ?p)
        (forall (?p2 - plane)
          (not          
            (and 
              (priority ?p2) 
              (exists (?r2 - runway) (plane-at ?p2  ?r2))
              (has-loaded-passengers ?p2)
            )       
          )
        )
      )
      (>= (fuel-level ?p) 10)  ; Ensure enough fuel to take off
    )
    :effect (and
      (not (plane-at ?p ?r))
      (runway-available ?r)
      (plane-takenoff ?p)
      (passengers-loaded ?p)
      (not (has-loaded-passengers ?p))
      (decrease (fuel-level ?p) 10)  ; Reduce fuel by 10
      (increase (total-cost) 10)
    )
  )
)
