


(define (domain rooms)
    (:requirements :adl :universal-preconditions :expression-variables :intentionality :belief)
    (:types
        letter key star - thing
        character room thing
    )
    (:predicates
        (locked ?room - room)
        (at ?character - character ?room - room)
        (unlocked-by ?room - room ?key - key)
        (in ?thing - thing ?room - room)
        ;;(hidden ?thing - thing)
        (has ?character - character ?thing - thing)
    )

    ;; A character moves from one room to another (via a hallway adjacent to all rooms)
    (:action enter
        :parameters   (?character - character ?roomfrom - room ?roomto - room)
        :precondition
            (and
                (not (locked ?roomto))
                (at ?character ?roomfrom)
            )
        :effect
            (and
                (not (at ?character ?roomfrom))
                (at ?character ?roomto)
                (believes ?character (not (at ?character ?roomfrom)))
                (believes ?character (at ?character ?roomto))
                (not (believes ?character (at ?character ?roomfrom)))
                (not (believes ?character (not (at ?character ?roomto))))

                (forall (?char2 - character)
                    (when (at ?char2 ?roomto)
                        (and
                            (believes ?character (at ?char2 ?roomto))
                            (believes ?char2 (at ?character ?roomto))
                            (not (believes ?character (not (at ?char2 ?roomto))))
                            (not (believes ?char2 (not (at ?character ?roomto))))
                        )
                    )
                )
                ;;(forall (?thing - thing)
                ;;    (when (and (in ?thing ?roomto) (not (hidden ?thing)))
                ;;        (and
                ;;            (believes ?character (in ?thing ?roomto))
                ;;            (not (believes ?character (not (in ?thing ?roomto))))
                ;;        )
                ;;    )
                ;;)
            )
        :fail
            (when (and (locked ?roomto) (at ?character ?roomfrom) )
                (and
                    (believes ?character (locked ?roomto))
                    (not (believes ?character (not (locked ?roomto))))
                )
            )
        :agents
            (?character)
    )


    ; An informant tells the character something they believe
    ;(:action speak-to
    ;    :parameters  (?informant - character ?info - expression ?informed - character ?room - room)
    ;    :precondition
    ;        (and
    ;            (at ?informant ?room)
    ;            (at ?informed ?room)
    ;            (believes ?informant ?info)  ;; For the informant to do this action, need they believe that they believe?
    ;        )
    ;    :effect
    ;        (believes ?informed ?info)
    ;        (not (believes ?informed (not ?info))) ;; Future versions may do this differently, allowing lies, trust/mistrust
;
    ;    :fail () ;; Possibly the informed disbelieves the info if the informant disbelieves it
    ;    :agents (?informant ?informed)
    ;)

    ; An informant tells the character something they believe
    ;(:action trade-facts
    ;    :parameters  (?informant1 - character ?info1 - expression ?informant2 - character ?info2 - expression ?room - room)
    ;    :precondition
    ;        (and
    ;            (at ?informant1 ?room)
    ;            (at ?informant2 ?room)
    ;            (believes ?informant1 ?info1)
    ;            (believes ?informant2 ?info2)
    ;        )
    ;    :effect
    ;        (believes ?informant1 ?info2)
    ;        (believes ?informant2 ?info1)
    ;        (not (believes ?informant1 (not ?info2)))
    ;        (not (believes ?informant2 (not ?info1)))
;
    ;    :fail () ;; Possibly the informed disbelieves the info if the informant disbelieves it
    ;    :agents (?informant1 ?informant2)
    ;)

    ; An letter tells the character something the letter believes.
    (:action read-letter
        :parameters  (?letter - character ?info - expression ?informed - character ?room - room)
        :precondition
            (and
                (at ?letter ?room)
                (at ?informed ?room)
                (believes ?letter ?info)  ;; For the informant to do this action, need they believe that they believe?
            )
        :effect
            (believes ?informed ?info)
            (not (believes ?informed (not ?info))) ;; Future versions may do this differently, allowing lies, trust/mistrust

        :fail () ;; Possibly the informed disbelieves the info if the informant disbelieves it
        :agents (?informed)
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


;;    ;; A character convinces another to intend something. If the convincee is not friendly to the convincer, the convinced intends not the  thing
;;    (:action convince
;;        :parameters  (?convincer - character ?convinced - character ?intent - expression ?room - room)
;;        :precondition
;;            (and
;;                (at ?convincer ?room)
;;                (at ?convinced ?room)
;;                (friendly-to ?convinced ?convincer)
;;            )
;;
;;        :effect
;;            (intends ?convinced ?intent)
;;
;;        :fail
;;            (when (and (at ?convincer ?room) (in ?convinced ?room) (not (friendly-to ?convinced ?convincer)))
;;                (intends ?convinced) (not ?intent)
;;            )
;;        :agents (?reader)
;;    )


    ;; A character searches the room for a specific thing
    (:action search-for
        :parameters  (?character - character ?thing - thing ?room - room)
        :precondition
            (and
                (at ?character ?room)
                (in ?thing ?room)
            )
        :effect
            (and
                (has ?character ?thing)
                (not (in ?thing ?room))

                (believes ?character (has ?character ?thing))
                (believes ?character (not (in ?thing ?room)))
                (not (believes ?character (not (has ?character ?thing))))
                (not (believes ?character (in ?thing ?room)))
            )
        :fail
            (when (and (not (in ?thing ?room)) (at ?character ?room))
                (and
                    (not (believes ?character (in ?thing ?room)))
                    (believes ?character (not (in ?thing ?room)))
                )
            )
        :agents (?character)
    )

    ;; A character unlocks a room with a key
    (:action unlock
        :parameters  (?character - character ?key - key ?room - room)
        :precondition
            (and
                (locked ?room)
                (unlocked-by ?room ?key)
                (has ?character ?key)
            )
        :effect
            (and
                (not (locked ?room))
                (believes ?character (not (locked ?room)))
                (not (believes ?character (locked ?room)))
            )
        :fail
            (when (and (locked ?room) (has ?character ?key) (not (unlocked-by ?room ?key)))
                (and
                    (believes ?character (not (unlocked-by ?room ?key)))
                    (not (believes ?character (unlocked-by ?room ?key)))
                )
            )
        :agents (?character)
    )
)
