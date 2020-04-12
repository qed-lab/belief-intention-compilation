
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
						(not  
							(believes_not_at ?character ?char2 ?roomto)
						)
						(not  
							(believes_not_at ?char2 ?character ?roomto)
						)
					)
				)
			)
		)    


    :agents (?character)
)

	
(:action enter_fail
    :parameters   ( ?character - character ?roomfrom - room ?roomto - room)
    :precondition 
		(and  
			(or  
				(locked ?roomto)
				(not  
					(at ?character ?roomfrom)
				)
			)
			(believes_not_locked ?character ?roomto)
			(believes_at ?character ?character ?roomfrom)
		)
    :effect
		(when  
			(and  
				(locked ?roomto)
				(at ?character ?roomfrom)
			)
			(and  
				(believes_locked ?character ?roomto)
				(not  
					(believes_not_locked ?character ?roomto)
				)
			)
		)    


    :agents (?character)
)

	
(:action read-letter-locked_success
    :parameters   ( ?letter - character ?room-for-info - room ?informed - character ?room - room)
    :precondition 
		(and  
			(at ?letter ?room)
			(at ?informed ?room)
			(believes_locked ?letter ?room-for-info)
			(believes_at ?informed ?letter ?room)
			(believes_at ?informed ?informed ?room)
		)
    :effect
		(believes_locked ?informed ?room-for-info)    


    :agents (?informed)
)

	
(:action read-letter-at_success
    :parameters   ( ?letter - character ?character-for-info - character ?room-for-info - room ?informed - character ?room - room)
    :precondition 
		(and  
			(at ?letter ?room)
			(at ?informed ?room)
			(believes_at ?letter ?character-for-info ?room-for-info)
			(believes_at ?informed ?letter ?room)
			(believes_at ?informed ?informed ?room)
		)
    :effect
		(believes_at ?informed ?character-for-info ?room-for-info)    


    :agents (?informed)
)

	
(:action read-letter-unlocked-by_success
    :parameters   ( ?letter - character ?room-for-info - room ?key-for-info - key ?informed - character ?room - room)
    :precondition 
		(and  
			(at ?letter ?room)
			(at ?informed ?room)
			(believes_unlocked-by ?letter ?room-for-info ?key-for-info)
			(believes_at ?informed ?letter ?room)
			(believes_at ?informed ?informed ?room)
		)
    :effect
		(believes_unlocked-by ?informed ?room-for-info ?key-for-info)    


    :agents (?informed)
)

	
(:action read-letter-in_success
    :parameters   ( ?letter - character ?thing-for-info - thing ?room-for-info - room ?informed - character ?room - room)
    :precondition 
		(and  
			(at ?letter ?room)
			(at ?informed ?room)
			(believes_in ?letter ?thing-for-info ?room-for-info)
			(believes_at ?informed ?letter ?room)
			(believes_at ?informed ?informed ?room)
		)
    :effect
		(believes_in ?informed ?thing-for-info ?room-for-info)    


    :agents (?informed)
)

	
(:action read-letter-has_success
    :parameters   ( ?letter - character ?character-for-info - character ?thing-for-info - thing ?informed - character ?room - room)
    :precondition 
		(and  
			(at ?letter ?room)
			(at ?informed ?room)
			(believes_has ?letter ?character-for-info ?thing-for-info)
			(believes_at ?informed ?letter ?room)
			(believes_at ?informed ?informed ?room)
		)
    :effect
		(believes_has ?informed ?character-for-info ?thing-for-info)    


    :agents (?informed)
)

	
(:action search-for_success
    :parameters   ( ?character - character ?thing - thing ?room - room)
    :precondition 
		(and  
			(at ?character ?room)
			(in ?thing ?room)
			(believes_at ?character ?character ?room)
			(believes_in ?character ?thing ?room)
		)
    :effect
		(and  
			(has ?character ?thing)
			(not  
				(in ?thing ?room)
			)
			(believes_has ?character ?character ?thing)
			(believes_not_in ?character ?thing ?room)
			(not  
				(believes_not_has ?character ?character ?thing)
			)
			(not  
				(believes_in ?character ?thing ?room)
			)
		)    


    :agents (?character)
)

	
(:action search-for_fail
    :parameters   ( ?character - character ?thing - thing ?room - room)
    :precondition 
		(and  
			(or  
				(not  
					(at ?character ?room)
				)
				(not  
					(in ?thing ?room)
				)
			)
			(believes_at ?character ?character ?room)
			(believes_in ?character ?thing ?room)
		)
    :effect
		(when  
			(and  
				(not  
					(in ?thing ?room)
				)
				(at ?character ?room)
			)
			(and  
				(not  
					(believes_in ?character ?thing ?room)
				)
				(believes_not_in ?character ?thing ?room)
			)
		)    


    :agents (?character)
)

	
(:action unlock_success
    :parameters   ( ?character - character ?key - key ?room - room)
    :precondition 
		(and  
			(locked ?room)
			(unlocked-by ?room ?key)
			(has ?character ?key)
			(believes_locked ?character ?room)
			(believes_unlocked-by ?character ?room ?key)
			(believes_has ?character ?character ?key)
		)
    :effect
		(and  
			(not  
				(locked ?room)
			)
			(believes_not_locked ?character ?room)
			(not  
				(believes_locked ?character ?room)
			)
		)    


    :agents (?character)
)

	
(:action unlock_fail
    :parameters   ( ?character - character ?key - key ?room - room)
    :precondition 
		(and  
			(or  
				(not  
					(locked ?room)
				)
				(not  
					(unlocked-by ?room ?key)
				)
				(not  
					(has ?character ?key)
				)
			)
			(believes_locked ?character ?room)
			(believes_unlocked-by ?character ?room ?key)
			(believes_has ?character ?character ?key)
		)
    :effect
		(when  
			(and  
				(locked ?room)
				(has ?character ?key)
				(not  
					(unlocked-by ?room ?key)
				)
			)
			(and  
				(believes_not_unlocked-by ?character ?room ?key)
				(not  
					(believes_unlocked-by ?character ?room ?key)
				)
			)
		)    


    :agents (?character)
)

)

