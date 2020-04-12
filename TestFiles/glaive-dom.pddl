
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; The domain "rooms", compiled for use in planners                ;;;
;;;  that support intention.                                        ;;;
;;;                                                                 ;;;
;;; Compilation by Matthew Christensen and Jennifer Nelson (2020)   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain rooms-bompiled)
    (:requirements :adl :universal-preconditions :expression-variables :intentionality)
    (:types

letter key star - thing
character room thing

    )
    (:predicates
        (locked ?room - room)
		(at ?character - character ?room - room)
		(unlocked-by ?room - room ?key - key)
		(in ?thing - thing ?room - room)
		(has ?character - character ?thing - thing)
		(believes_not_locked ?who - character ?room - room)
		(believes_locked ?who - character ?room - room)
		(believes_not_at ?who - character ?character - character ?room - room)
		(believes_at ?who - character ?character - character ?room - room)
		(believes_not_unlocked-by ?who - character ?room - room ?key - key)
		(believes_unlocked-by ?who - character ?room - room ?key - key)
		(believes_not_in ?who - character ?thing - thing ?room - room)
		(believes_in ?who - character ?thing - thing ?room - room)
		(believes_not_has ?who - character ?character - character ?thing - thing)
		(believes_has ?who - character ?character - character ?thing - thing)
    )

(:action enter_success
    :parameters   ( ?character - character ?roomfrom - room ?roomto - room)
    :precondition
		(and
			(not
				(locked ?roomto)
			)
			(at ?character ?roomfrom)
			(believes_not_locked ?character ?roomto)
			(believes_at ?character ?character ?roomfrom)
		)
    :effect
		(and
			(not
				(at ?character ?roomfrom)
			)
			(at ?character ?roomto)
			(believes_not_at ?character ?character ?roomfrom)
			(believes_at ?character ?character ?roomto)
			(not
				(believes_at ?character ?character ?roomfrom)
			)
			(not
				(believes_not_at ?character ?character ?roomto)
			)
			(forall
				(?char2 - character)
				(when
					(at ?char2 ?roomto)
					(and
						(believes_at ?character ?char2 ?roomto)
						(believes_at ?char2 ?character ?roomto)



    :agents (?character)
)

)
