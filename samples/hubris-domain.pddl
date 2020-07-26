;;; A domain to demonstrate how failure can impact simple stories
;;; Created by Matthew Christensen and Jennifer Nelson (2020)
;;;

(define (domain hubris)
    (:requirements :adl :universal-preconditions :expression-variables :belief)
    (:types
        macguffin key star - thing
        character thing room
    )
    (:predicates
        (can-wield ?char - character ?mac - macguffin)
        (dead ?char - character)
        (has ?char - character ?thing - thing)
        (in ?thing - thing ?room - room)
        (at ?character - character ?room - room)
        (victorious-over ?victor - character ?loser - character)
    )

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
                (not (believes ?character (not (has ?character ?thing))))
                (not (believes ?character (in ?thing ?room)))
            )
        :fail
            (not (believes ?character (in ?thing ?room)))
        :agents (?character)
    )

    ;; A character unlocks a room with a key
    (:action destroy
        :parameters  (?destroyer - character ?tool - macguffin ?victim - character)
        :precondition
            (and
                (has ?destroyer ?tool)
                (can-wield ?destroyer ?tool)
                (not (dead ?destroyer))
            )
        :effect
            (and
                (dead ?victim)
                (believes ?destroyer (dead ?victim))
                (believes ?victim (dead ?victim))
            )
        :fail
            (and
                (believes ?victim (has ?destroyer ?tool))
                (can-wield ?destroyer ?tool)
            )
        :agents (?destroyer)
    )

    (:action steal
        :parameters (?thief - character ?object - thing ?victim - character)
        :precondition
            (has ?victim ?object)
        :effect
            (and
                (not (has ?victim ?object))
                (has ?thief ?object)
                (believes ?thief (has ?thief ?object))
                (believes ?victim (has ?thief ?object))
                (not (believes ?thief (has ?victim ?object)))
                (not (believes ?victim (has ?victim ?object)))
            )
        :fail
            (and
                (not (believes ?thief (has ?victim ?object)))
                (believes ?thief (not (has ?victim ?object)))
            )
        :agents (?thief)
    )

    (:action win
        :parameters (?victor - character ?loser - character)
        :precondition
            (dead ?loser)
            (not (dead ?victor))
        :effect
            (victorious-over ?victor ?loser)
        :fail
            (believes ?victor (not (dead ?loser)))
        :agents (?victor)
    )
)
