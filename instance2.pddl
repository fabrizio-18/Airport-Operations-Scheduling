(define (problem instance2)
  (:domain airport-operations)
  (:objects 
    P1 P2 P3 - plane
    R1 R2 - runway
    G1 G2 G3 G4 - gate
  )
  (:init
    ;; Planes waiting to land
    (waiting-to-land P1)
    (waiting-to-land P2)
    (waiting-to-land P3)

    (passengers-loaded P1)
    (passengers-loaded P2)
    (passengers-loaded P3)

    ;; Runways available
    (runway-available R1)
    (runway-available R2)

    ;; Gates available
    (gate-available G1)
    (gate-available G2)
    (gate-available G3)
    (gate-available G4)

    (assigned-gate P1 G1)
    (assigned-gate P2 G2)

    ;; Taxi times
    (= (taxi-time P1 G1) 1)
    (= (taxi-time P1 G2) 0.5)
    (= (taxi-time P1 G3) 0.3)

    (= (taxi-time P2 G1) 0.2)
    (= (taxi-time P2 G2) 0.3)
    (= (taxi-time P2 G3) 0.8)
    
    (= (taxi-time P3 G1) 0.4)
    (= (taxi-time P3 G2) 0.6)
    (= (taxi-time P3 G3) 1)

    (= (total-cost) 0)
    
    ;; Fuel levels
    (= (fuel-level P1) 10)
    (= (fuel-level P2) 20)
    (= (fuel-level P3) 30)

    ;; Fuel consumption rates
    (= (fuel-consumption-rate P1) 0.5)
    (= (fuel-consumption-rate P2) 0.2)
    (= (fuel-consumption-rate P3) 0.3)
  )
  (:goal
    (and
      (plane-takenoff P1)
      (plane-takenoff P2)
      (plane-takenoff P3)
    
    )
  )

  (:metric minimize (total-cost))
  )