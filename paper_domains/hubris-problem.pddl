;;;
;;; A problem for demonstrating failure in stories
;;; Created by Matthew Christensen and Jennifer Nelson
;;;
(define (problem allspark)
    (:domain hubris)
    (:objects
        hero - character
        villain - character
        allspark - macguffin
        setting - room
    )
    (:init
        (in allspark setting)
        (at hero setting)
        (at villain setting)
        (believes hero (at hero setting))
        (believes villain (at villain setting))
        (believes hero (can-wield hero allspark))
        (believes villain (can-wield villain allspark))
        (believes hero (not (dead hero)))
        (believes villain (not (dead villain)))

        (can-wield hero allspark)

        (believes villain (in allspark setting))

        (intends hero (victorious-over hero villain))
        (intends villain (victorious-over villain hero))


    )

    (:goal
        (and
            (victorious-over villain hero)
        )
    )
)