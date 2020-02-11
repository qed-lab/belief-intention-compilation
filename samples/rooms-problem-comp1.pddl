;;;
;;; A problem for felling the story of Aladdin from 1001 Nights
;;; Created by Mark O. Riedl for his dissertation
;;; Ported to PDDL 3 by Stephen G. Ware
;;;
(define (problem six-rooms)
    (:domain rooms-c1)
    (:objects
        alice - character
        informant1 - character
        informant2 - character
        ;letter1 - letter
        ;letter2 - letter
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
        ;(in letter1 r2)
        ;(in letter2 r6)
        (at alice r3)
        (in key r4)
        (in star r5)
        (hidden key)
        (hidden star)

        (locked r5)
        (unlocked-by r5 key)

        ;; Alice (wrongly) believes the star is in r1, no rooms are locked, and there are no keys.
        (believes-in alice star r1)
        (believes-at alice alice r3)
        (believes-at alice informant1 r2)
        (believes-at alice informant2 r6)

        ;; The informants (or letters?) hold crucial knowledge of where the star and key are
        (believes-in informant1 star r5)
        (believes-at informant1 informant1 r2)
        (believes-in informant2 key r4)
        (believes-at informant2 informant2 r6)
        (believes-unlocked-by informant2 r5 key)
        ;(believes-in letter1 star r5)
        ;(believes-in letter2 key r4)
        ;(believes-unlocked-by letter2 r5 key)


    )

    (:goal
        (and
            (has alice star)
        )
    )
)