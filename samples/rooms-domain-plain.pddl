;;;
;;; A domain for telling the story of Aladdin from 1001 Nights
;;; Created by Mark O. Riedl for his dissertation
;;; Ported to PDDL 3 and modified to use the 'delegated' modality by Stephen G. Ware
;;;
(define (domain rooms)
    (:requirements :adl)
    (:types
        letter key star - thing
        character room thing
    )
    (:predicates
        (locked ?room - room)
        (at ?character - character ?room - room)
        (unlocked-by ?room - room ?key - key)
        (in ?thing - thing ?room - room)
        (hidden ?thing)
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
            )
    )


;;    ;; An informant tells the character something they believe
;;    (:action speak-to
;;        :parameters  (?informant - character ?info - expression ?informed - character ?room - room)
;;        :precondition
;;            (and
;;                (at ?informant ?room)
;;                (at ?informed ?room)
;;                (believes ?informant ?info)  ;; For the informant to do this action, need they believe that they believe?
;;            )
;;        :effect
;;            (believes ?informed ?info) ;; Future versions may do this differently, allowing lies, trust/mistrust
;;
;;        :fail () ;; Possibly the informed disbelieves the info if the informant disbelieves it
;;        :agents (?informant ?informed)
;;    )
;;
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
;;

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
            )
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
            )
    )
)
