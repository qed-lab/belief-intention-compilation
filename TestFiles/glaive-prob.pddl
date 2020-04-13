
(define (problem evil-cloud-bompiled)
    (:domain heroes-journey-bompiled)
    (:objects
        :objects
alice - character
bob - character
evil-cloud - existential-threat
dagonia - village
mount-doom - mountain
the-power - superpower

    )
    (:init
        (in evil-cloud dagonia)
	(at alice dagonia)
	(at bob mount-doom)
	(believes_at alice alice dagonia)
	(believes_at bob bob mount-doom)
	(believes_at alice bob mount-doom)
	(wields alice the-power)
    )
    (:goal
		(safe dagonia)
    )
)

