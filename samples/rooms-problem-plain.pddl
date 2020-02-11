;;;
;;; A problem for felling the story of Aladdin from 1001 Nights
;;; Created by Mark O. Riedl for his dissertation
;;; Ported to PDDL 3 by Stephen G. Ware
;;;
(define (problem six-rooms)
    (:domain rooms)
    (:objects
        alice - character
        informant1 - character
        informant2 - character
        letter1 - letter
        letter2 - letter
        key - key
        star - star
        r1 - room
        r2 - room
        r3 - room
        r4 - room
        r5 - room
        r6 - room
    )
    (:init
        (at informant1 r2)
        (at informant2 r6)
        (in letter1 r2)
        (in letter2 r6)
        (at alice r3)
        (in key r4)
        (in star r5)

        (locked r5)
        (unlocked-by r5 key)

    )

    (:goal
        (and
            (has alice star)
        )
    )
)