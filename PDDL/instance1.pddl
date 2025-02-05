(define (problem instance1)
  (:domain airport-operations)
  (:objects 
    P1 P2 - plane
    R1 - runway
    G1 G2 G3 - gate
  )
  (:init
    (waiting-to-land P1)
    (waiting-to-land P2)

    (passengers-loaded P1)
    (passengers-loaded P2)

    (runway-available R1)

    (gate-available G1)
    (gate-available G2)
    (gate-available G3)

    (= (taxi-time P1 G1) 1)
    (= (taxi-time P1 G2) 0.5)
    (= (taxi-time P2 G1) 0.2)
    (= (taxi-time P2 G2) 0.3)
   
    (= (total-cost) 0)

    (= (fuel-level P1) 10)
    (= (fuel-level P2) 20)

    (= (fuel-consumption-rate P1) 0.5)
    (= (fuel-consumption-rate P2) 0.2)
  )
  (:goal
    (and
      (plane-takenoff P1)
      (plane-takenoff P2)
    )
  )

  (:metric minimize (total-cost))
)