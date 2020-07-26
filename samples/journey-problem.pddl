;;;
;;; A problem for demonstrating failure in stories
;;; Created by Matthew Christensen and Jennifer Nelson
;;;
(define (problem evil-cloud)
    (:domain heroes-journey)
    (:objects
        alice - character
        bob - character
        evil-cloud - existential-threat
        dagonia - village
        mount-doom - mountain
        the-power - superpower

    )
    (:init


        (in evil-cloud dagonia)

        (at alice dagonia)
        (at bob mount-doom)

        (believes alice (at alice dagonia))
        (believes bob (at bob mount-doom))
        (believes alice (at bob mount-doom))

        (wields alice the-power)


    )

    (:goal
        (and
            (safe dagonia)
        )
    )
)