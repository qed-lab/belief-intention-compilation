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
        key - key
        starA - star
        star1 - star
        star2 - star
        r1 - room
        r2 - room
        r3 - room
        r4 - room
        r5 - room
        r6 - room
    )
    (:init
        (at alice r3)
        (at informant1 r2)
        (at informant2 r6)
        (in key r4)
        (in starA r5)
        (in star1 r5)
        (in star2 r5)

        (locked r5)
        (unlocked-by r5 key)

        ;; ALICE
        ;(believes alice (in key r4))
        ;(believes alice (unlocked-by r5 key))
        (believes alice (in starA r5))
        (believes alice (in star1 r5))
        (believes alice (in star2 r5))
        (believes alice (at alice r3))
        (believes alice (not (locked r1)))
        (believes alice (not (locked r2)))
        (believes alice (not (locked r3)))
        (believes alice (not (locked r4)))
        (believes alice (not (locked r5)))
        (believes alice (not (locked r6)))

        ;; INFORMANT 1
        (believes informant1 (in key r4))
        ;(believes informant1 (unlocked-by r5 key))
        ;(believes informant1 (in starA r5))
        ;(believes informant1 (in star1 r5))
        ;(believes informant1 (in star2 r5))
        (believes informant1 (at informant1 r2))
        (believes informant1 (not (locked r1)))
        (believes informant1 (not (locked r2)))
        (believes informant1 (not (locked r3)))
        (believes informant1 (not (locked r4)))
        (believes informant1 (not (locked r5)))
        (believes informant1 (not (locked r6)))


        ;; INFORMANT 2
        ;(believes informant2 (in key r4))
        (believes informant2 (unlocked-by r5 key))
        ;(believes informant2 (in starA r5))
        ;(believes informant2 (in star1 r5))
        ;(believes informant2 (in star2 r5))
        (believes informant2 (at informant2 r6))
        (believes informant2 (not (locked r1)))
        (believes informant2 (not (locked r2)))
        (believes informant2 (not (locked r3)))
        (believes informant2 (not (locked r4)))
        (believes informant2 (not (locked r5)))
        (believes informant2 (not (locked r6)))



        (intends alice (has alice starA) )
        (intends informant1 (has informant1 star1) )
        (intends informant2 (has informant2 star2) )




    )

    (:goal
        (and
            ;;(has alice starA)
            ;;(at alice r6)
            ;;(at alice r4)
            (has alice starA)
            (has informant1 star1)
            (has informant2 star2)
        )
    )
)