;;; A domain to demonstrate how belief can make storis longer and more interesting
;;; Created by Matthew Christensen and Jennifer Nelson (2020)
;;;

(define (domain heroes-journey)
    (:requirements :adl :universal-preconditions :expression-variables :belief)
    (:types
        superpower existential-threat - idea
        village mountain - place
        mirror - thing
        character place idea thing
    )
    (:predicates
        (threatening ?threat - existential-threat ?village - village)
        (wields ?char - character ?power - superpower)
        (dead ?char - character)
        (has ?char - character ?thing - thing)
        (at ?character - character ?place - place)
        (in ?threat - existential-threat ?place - place)
        (safe ?place - place)
        (destroyed ?place - place)
    )

    ;; An existential threat appears and threatens a character and their home
    (:action threaten
        :parameters  (?threat - existential-threat ?place - village ?char - character)
        :precondition
            (in ?threat ?place)
            (at ?char ?place)
        :effect
            (and
                (threatening ?threat ?place)
                (intends ?char (safe ?place))
                (believes ?char (threatening ?threat ?place))
            )
    )

    ;; A character unlocks a room with a key
    (:action save
        :parameters  (?hero - character ?power - superpower ?threat - existential-threat ?place - village)
        :precondition
            (and
                (wields ?hero ?power)
                (threatening ?threat ?place)
            )
        :effect
            (and
                (not (threatening ?threat ?place))
                (not (in ?threat ?place))
                (safe ?place)

                (believes ?hero (not (threatening ?threat ?place)))
                (believes ?hero (not (in ?threat ?place)))
                (believes ?hero (safe ?place))
            )
        :fail
            (destroyed ?place)
        :agents (?hero)
    )

    (:action visit
        :parameters (?hero - character ?src - place ?mentor - character ?dest - place)
        :precondition
            (and
                (at ?hero ?src)
                (at ?mentor ?dest)
            )
        :effect
            (and
                (not (at ?hero ?src))
                (at ?hero ?dest)
                (intends ?mentor (not (at ?hero ?dest)))

                (believes ?hero (at ?hero ?dest))
                (believes ?mentor (at ?hero ?dest))

                (believes ?hero (not (at ?hero ?src)))
                (not (believes ?hero (at ?hero ?src)))

            )
        :fail
            (and
                (not (at ?hero ?src))
                (at ?hero ?dest)

                (believes ?hero (at ?hero ?dest))

                (believes ?hero (not (at ?hero ?src)))
                (not (believes ?hero (at ?hero ?src)))
            )
        :agents (?hero)
    )

    (:action teach
        :parameters (?teacher - character ?student - character ?power - superpower ?place - place)
        :precondition
            (at ?teacher ?place)
            (at ?student ?place)
        :effect
            (believes ?student (wields ?student ?power))
        :fail
            (believes ?student (not (wields ?student ?power)))
        :agents (?teacher ?student)
    )

    (:action remove-to
        :parameters (?teacher - character ?student - character ?src - place ?dest - place)
        :precondition
            (and
                (at ?teacher ?src)
                (at ?student ?src)
            )
        :effect
            (and
                (not (at ?student ?src))
                (at ?student ?dest)

                (believes ?student (not (at ?student ?src)))
                (believes ?student (at ?student ?dest))
                (believes ?teacher (not (at ?student ?src)))
                (believes ?teacher (at ?student ?dest))
            )
        :fail
        :agents (?teacher)
    )
)
