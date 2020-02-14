;;;
;;; A domain for telling the story of Aladdin from 1001 Nights
;;; Created by Mark O. Riedl for his dissertation
;;; Ported to PDDL 3 and modified to use the 'delegated' modality by Stephen G. Ware
;;;
(define (domain rooms-c2)
    (:requirements :adl :universal-preconditions :intentionality :expression-variables)
    (:types
        letter key star - thing
        character room thing
    )
    (:predicates
        (locked ?room - room)
        (at ?character - character ?room - room)
        (unlocked-by ?room - room ?key - key)
        (in ?thing - thing ?room - room)
        (hidden ?thing - thing)
        (has ?character - character ?thing - thing)
        (friendly-to ?friend - character ?friendee - character)

        (believes-locked ?c - character ?room - room)
        (believes-at ?c - character ?character - character ?room - room)
        (believes-unlocked-by ?c - character ?room - room ?key - key)
        (believes-in ?c - character ?thing - thing ?room - room)
        (believes-hidden ?c - character ?thing - thing)
        (believes-has ?c - character ?character - character ?thing - thing)
        (believes-friendly-to ?c - character ?friend - character ?friendee - character)



    )

    ;; A character moves from one room to another (via a hallway adjacent to all rooms)
    (:action enter-success
        :parameters   (?character - character ?roomfrom - room ?roomto - room)
        :precondition
            (and
                (not (believes-locked ?character ?roomto))
                (believes-at ?character ?character ?roomfrom)

                (not (locked ?roomto))
                (at ?character ?roomfrom)
            )
        :effect
            (and
                (not (at ?character ?roomfrom))
                (at ?character ?roomto)

                (forall (?char2 - character)
                    (when (at ?char2 ?roomto)
                        (and
                            (believes-at ?character ?char2 ?roomto)
                            (believes-at ?char2 ?character ?roomto)
                        )
                    )
                )
                (forall (?thing - thing)
                    (when (and (in ?thing ?roomto) (not (hidden ?thing)))
                        (believes-in ?character ?thing ?roomto)
                    )
                )

                (not (believes-at ?character ?character ?roomfrom))
                (believes-at ?character ?character ?roomto)
            )
        :agents (?character)
    )

    (:action enter-fail
        :parameters   (?character - character ?roomfrom - room ?roomto - room)
        :precondition
            (and
                (not (believes-locked ?character ?roomto))
                (believes-at ?character ?character ?roomfrom)
                (not (and
                    (not (locked ?roomto))
                    (at ?character ?roomfrom))
                )
            )
        :effect
            (when (and (locked ?roomto) (at ?character ?roomfrom) )
                (believes-locked ?character ?roomto)
            )

        :agents (?character)
    )



    ;; An informant tells the character something they believe
    (:action speak-to-success_in
        :parameters  (?informant - character ?in_thing - thing ?in_room - room ?informed - character ?room - room)
        :precondition
            (and
                (at ?informant ?room)
                (at ?informed ?room)
                (believes-in ?informant ?in_thing ?in_room)

                (believes-at ?informant ?informant ?room)
                (believes-at ?informant ?informed ?room)
                (believes-at ?informed ?informant ?room)
                (believes-at ?informed ?informed ?room)
            )
        :effect
            ( when (and
                (at ?informant ?room)
                (at ?informed ?room)
            )
                (believes-in ?informed ?in_thing ?in_room)
            )
        :agents (?informant ?informed)
    )

    (:action speak-to-success_unlocked-by
        :parameters  (?informant - character ?unlocked-by_room - room ?unlocked-by_key - key ?informed - character ?room - room)
        :precondition
            (and
                (at ?informant ?room)
                (at ?informed ?room)
                (believes-unlocked-by ?informant ?unlocked-by_room ?unlocked-by_key)

                (believes-at ?informant ?informant ?room)
                (believes-at ?informant ?informed ?room)
                (believes-at ?informed ?informant ?room)
                (believes-at ?informed ?informed ?room)
            )
        :effect
            ( when (and
                (at ?informant ?room)
                (at ?informed ?room)
            )
                (believes-unlocked-by ?informed ?unlocked-by_room ?unlocked-by_key)
            )
        :agents (?informant ?informed)
    )


;;
;;    ;; A character reads a letter
;;    (:action read-letter
;;        :parameters  (?reader - character ?letter - letter ?room - room)
;;        :precondition
;;            (and
;;                (at ?reader ?room)
;;                (in ?letter ?room)
;;            )
;;        :effect
;;            (forall (?info - expression)
;;                (when (believes ?letter ?info)
;;                    (believes ?reader ?letter)
;;                )
;;            )
;;
;;        :fail ()
;;        :agents (?reader)
;;    )


    ;; A character convinces another to intend something. If the convincee is not friendly to the convincer, the convinced intends not the  thing
    (:action convince-success
        :parameters  (?convincer - character ?convinced - character ?intent - expression ?room - room)
        :precondition
            (and

                (believes-at  ?convincer ?convincer ?room)
                (believes-at  ?convincer ?convinced ?room)
                ;(believes-friendly-to ?convincer ?convinced ?convincer)

                (at ?convincer ?room)
                (at ?convinced ?room)
                ;(friendly-to ?convinced ?convincer)
            )

        :effect
            ;(and
                (intends ?convinced ?intent)
                ;(delegated ?convincer ?intent ?convinced)
            ;)


        :agents (?convincer)
    )
;    (:action convince-fail
;        :parameters  (?convincer - character ?convinced - character ?intent - expression ?room - room)
;        :precondition
;            (and
;                (believes-at  ?convincer ?convincer ?room)
;                (believes-at  ?convincer ?convinced ?room)
;                (believes-friendly-to ?convincer ?convinced ?convincer)
;                (not (and
;                    (at ?convincer ?room)
;                    (at ?convinced ?room)
;                    (friendly-to ?convinced ?convincer)
;                ))
;            )
;
;        effect:
;            (when (and (at ?convincer ?room) (in ?convinced ?room) (not (friendly-to ?convinced ?convincer)))
;                (not (intends ?convinced ?intent))
;            )
;        :agents (?convincer)
;    )


    ;; A character searches the room for a specific thing
    (:action search-for-success
        :parameters  (?character - character ?thing - thing ?room - room)
        :precondition
            (and
                (believes-at ?character ?character ?room)
                (believes-in ?character ?thing ?room)

                (at ?character ?room)
                (in ?thing ?room)
            )
        :effect
            (and
                (has ?character ?thing)
                (not (in ?thing ?room))


                (believes-has ?character ?character ?thing)
                (not (believes-in ?character ?thing ?room))
            )
        :agents (?character)
    )
    (:action search-for-fail
        :parameters  (?character - character ?thing - thing ?room - room)
        :precondition
            (and
                (believes-at ?character ?character ?room)
                (believes-in ?character ?thing ?room)
                (not (and
                    (at ?character ?room)
                    (in ?thing ?room)
                    )
                )
            )
        :effect
            (when (and (not (in ?thing ?room)) (at ?character ?room))
                (not (believes-in ?character ?thing ?room))
            )
        :agents (?character)
    )

    ;; A character unlocks a room with a key
    (:action unlock-success
        :parameters  (?character - character ?key - key ?room - room)
        :precondition
            (and
                (believes-locked ?character ?room)
                (believes-unlocked-by ?character ?room ?key)
                (believes-has ?character ?character ?key)
                (locked ?room)
                (unlocked-by ?room ?key)
                (has ?character ?key)
            )
        :effect
            (and
                (not (locked ?room))
                (not (believes-locked ?character ?room))
            )
        :agents (?character)
    )
    (:action unlock-fail
        :parameters  (?character - character ?key - key ?room - room)
        :precondition
            (and
                (believes-locked ?character ?room)
                (believes-unlocked-by ?character ?room ?key)
                (believes-has ?character ?character ?key)
                (not (and
                    (locked ?room)
                    (unlocked-by ?room ?key)
                    (has ?character ?key))
                )
            )
        :effect
            (when (and (locked ?room) (has ?character ?key) (not (unlocked-by ?room ?key)))
                (not (believes-unlocked-by ?character ?room ?key))
            )
        :agents (?character)
    )
)
