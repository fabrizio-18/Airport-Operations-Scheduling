(define (problem instance3)
  (:domain airport-operations)
  (:objects 
    P1 P2 P3 P4 P5 - plane
    R1 R2 R3 - runway
    G1 G2 G3 G4 G5 - gate
  )
  (:init
    ;; High-priority planes
    (waiting-to-land P1)
    (waiting-to-land P2)

    (priority P1)
    (priority P2)

    ;; Other planes
    (waiting-to-land P3)
    (waiting-to-land P4)
    (waiting-to-land P5)

    (passengers-loaded P1)
    (passengers-loaded P2)
    (passengers-loaded P3)
    (passengers-loaded P4)
    (passengers-loaded P5)

    ;; Runways available
    (runway-available R1)
    (runway-available R2)
    (runway-available R3)

    ;; Gates available
    (gate-available G1)
    (gate-available G2)
    (gate-available G3)
    (gate-available G4)
    (gate-available G5)

    ;; Taxi times
    (= (taxi-time P1 G1) 1)
    (= (taxi-time P1 G2) 0.5)
    (= (taxi-time P1 G3) 0.3)
    (= (taxi-time P1 G4) 0.4)
    (= (taxi-time P1 G5) 0.2)

    (= (taxi-time P2 G1) 0.2)
    (= (taxi-time P2 G2) 0.3)
    (= (taxi-time P2 G3) 0.8)
    (= (taxi-time P2 G4) 0.4)
    (= (taxi-time P2 G5) 0.3)

    (= (taxi-time P3 G1) 0.4)
    (= (taxi-time P3 G2) 0.6)
    (= (taxi-time P3 G3) 1)
    (= (taxi-time P3 G4) 0.3)
    (= (taxi-time P3 G5) 0.7)

    (= (taxi-time P4 G1) 0.1)
    (= (taxi-time P4 G2) 0.2)
    (= (taxi-time P4 G3) 0.4)
    (= (taxi-time P4 G4) 0.3)
    (= (taxi-time P4 G5) 0.7)

    (= (taxi-time P5 G1) 0.3)
    (= (taxi-time P5 G2) 0.4)
    (= (taxi-time P5 G3) 0.7)
    (= (taxi-time P5 G4) 1)
    (= (taxi-time P5 G5) 1.2)

    (= (total-cost) 0)

    ;; Initial fuel levels
    (= (fuel-level P1) 10)
    (= (fuel-level P2) 20)
    (= (fuel-level P3) 30)
    (= (fuel-level P4) 80)
    (= (fuel-level P5) 20)
    

    ;; Fuel consumption rates
    (= (fuel-consumption-rate P1) 0.5)
    (= (fuel-consumption-rate P2) 0.2)
    (= (fuel-consumption-rate P3) 0.3)
    (= (fuel-consumption-rate P4) 0.4)
    (= (fuel-consumption-rate P5) 0.6)
  )
  (:goal
    (and
      (plane-takenoff P1)
      (plane-takenoff P2)
      (plane-takenoff P3)
      (plane-takenoff P4)
      (plane-takenoff P5)
    )
  )

  (:metric minimize (total-cost))
)