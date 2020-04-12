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
        ;;;letter1 - letter
        ;;;letter2 - letter
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
        (at alice r3)
        (in key r4)
        (in star r5)
        (hidden key)

        (locked r5)
        (unlocked-by r5 key)

        ;; Alice (wrongly) believes the star is in r1, no rooms are locked, and there are no keys.
        (believes alice (in star r1) )
        (believes alice (at alice r3))
        (believes alice (not (locked r1)))
        (believes alice (not (locked r2)))
        (believes alice (not (locked r3)))
        (believes alice (not (locked r4)))
        (believes alice (not (locked r5)))
        (believes alice (not (locked r6)))

        (intends alice (has alice key) )
        ;;(intends alice (has alice star) )
        ;;(intends alice (at alice r5))
        (intends informant1 (has alice key) )
        (intends informant2 (has alice key) )

        ;; The informants hold crucial knowledge of where the star and key are
        (believes informant1 (in star r5))
        (believes informant2 (in key r4))
        (believes informant2 (unlocked-by r5 key))
        (believes informant1 (at informant1 r2))
        (believes informant2  (at informant2 r6))






    )

    (:goal
        (and
            ;;(has alice star)
            ;;(at alice r6)
            ;;(at alice r4)
            (has alice key)
        )
    )
)