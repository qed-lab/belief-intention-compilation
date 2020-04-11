
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; The domain "rooms", compiled for use in planners                ;;;
;;;  that support intention.                                        ;;;
;;;                                                                 ;;;
;;; Compilation by Matthew Christensen and Jennifer Nelson (2020)   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain rooms-bompiled)
    (:requirements :adl :universal-preconditions :expression-variables :intentionality)
    (:types
    
key star - thing
character room thing

    )
    (:predicates
        (locked ?room)
		(at ?character ?room)
		(unlocked-by ?room ?key)
		(in ?thing ?room)
		(hidden ?thing)
		(has ?character ?thing)
		(believes_not_locked ?who ?room)
		(believes_locked ?who ?room)
		(believes_not_at ?who ?character ?room)
		(believes_at ?who ?character ?room)
		(believes_not_unlocked-by ?who ?room ?key)
		(believes_unlocked-by ?who ?room ?key)
		(believes_not_in ?who ?thing ?room)
		(believes_in ?who ?thing ?room)
		(believes_not_hidden ?who ?thing)
		(believes_hidden ?who ?thing)
		(believes_not_has ?who ?character ?thing)
		(believes_has ?who ?character ?thing)
    )
    
(:action enter_success
    :parameters   (?character - character ?roomfrom - room ?roomto - room)
    :precondition 
		(and  
			(believes_not_locked ?character ?roomto)
			(believes_at ?character ?character ?roomfrom)
			(not  
				(locked ?roomto)
			)
			(at ?character ?roomfrom)
		)
    :effect
		(and  
			(not  
				(at ?character ?roomfrom)
			)
			(at ?character ?roomto)
			(forall  
				(?char2 - character)
				(when  
					(at ?char2 ?roomto)
					(and  
						(believes_at ?character ?char2 ?roomto)
						(believes_at ?char2 ?character ?roomto)
					)
				)
			)
			(forall  
				(?thing - thing)
				(when  
					(and  
						(in ?thing ?roomto)
						(not  
							(hidden ?thing)
						)
					)
					(believes_in ?character ?thing ?roomto)
				)
			)
		)    


    :agents (?character)
)

	
(:action enter_fail
    :parameters   (?character - character ?roomfrom - room ?roomto - room)
    :precondition 
		(and  
			(believes_not_locked ?character ?roomto)
			(believes_at ?character ?character ?roomfrom)
			(or  
				(locked ?roomto)
				(not  
					(at ?character ?roomfrom)
				)
			)
		)
    :effect
		(when  
			(and  
				(locked ?roomto)
				(at ?character ?roomfrom)
			)
			(believes_locked ?character ?roomto)
		)    


    :agents (?character)
)

	
(:action speak-to-locked_success
    :parameters   (?informant - character ?room-for-info - room ?informed - character ?room - room)
    :precondition 
		(and  
			(believes_at ?informant ?informant ?room)
			(believes_at ?informant ?informed ?room)
			(believes_locked ?informant ?room-for-info)
			(believes_at ?informed ?informant ?room)
			(believes_at ?informed ?informed ?room)
			(believes_locked ?informant ?room-for-info)
			(at ?informant ?room)
			(at ?informed ?room)
			(believes_locked ?informant ?room-for-info)
		)
    :effect
		(believes_locked ?informed ?room-for-info)    


    :agents (?informant ?informed)
)

	
(:action speak-to-at_success
    :parameters   (?informant - character ?character-for-info - character ?room-for-info - room ?informed - character ?room - room)
    :precondition 
		(and  
			(believes_at ?informant ?informant ?room)
			(believes_at ?informant ?informed ?room)
			(believes_at ?informant ?character-for-info ?room-for-info)
			(believes_at ?informed ?informant ?room)
			(believes_at ?informed ?informed ?room)
			(believes_at ?informant ?character-for-info ?room-for-info)
			(at ?informant ?room)
			(at ?informed ?room)
			(believes_at ?informant ?character-for-info ?room-for-info)
		)
    :effect
		(believes_at ?informed ?character-for-info ?room-for-info)    


    :agents (?informant ?informed)
)

	
(:action speak-to-unlocked-by_success
    :parameters   (?informant - character ?room-for-info - room ?key-for-info - key ?informed - character ?room - room)
    :precondition 
		(and  
			(believes_at ?informant ?informant ?room)
			(believes_at ?informant ?informed ?room)
			(believes_unlocked-by ?informant ?room-for-info ?key-for-info)
			(believes_at ?informed ?informant ?room)
			(believes_at ?informed ?informed ?room)
			(believes_unlocked-by ?informant ?room-for-info ?key-for-info)
			(at ?informant ?room)
			(at ?informed ?room)
			(believes_unlocked-by ?informant ?room-for-info ?key-for-info)
		)
    :effect
		(believes_unlocked-by ?informed ?room-for-info ?key-for-info)    


    :agents (?informant ?informed)
)

	
(:action speak-to-in_success
    :parameters   (?informant - character ?thing-for-info - thing ?room-for-info - room ?informed - character ?room - room)
    :precondition 
		(and  
			(believes_at ?informant ?informant ?room)
			(believes_at ?informant ?informed ?room)
			(believes_in ?informant ?thing-for-info ?room-for-info)
			(believes_at ?informed ?informant ?room)
			(believes_at ?informed ?informed ?room)
			(believes_in ?informant ?thing-for-info ?room-for-info)
			(at ?informant ?room)
			(at ?informed ?room)
			(believes_in ?informant ?thing-for-info ?room-for-info)
		)
    :effect
		(believes_in ?informed ?thing-for-info ?room-for-info)    


    :agents (?informant ?informed)
)

	
(:action speak-to-hidden_success
    :parameters   (?informant - character ?thing-for-info - thing ?informed - character ?room - room)
    :precondition 
		(and  
			(believes_at ?informant ?informant ?room)
			(believes_at ?informant ?informed ?room)
			(believes_hidden ?informant ?thing-for-info)
			(believes_at ?informed ?informant ?room)
			(believes_at ?informed ?informed ?room)
			(believes_hidden ?informant ?thing-for-info)
			(at ?informant ?room)
			(at ?informed ?room)
			(believes_hidden ?informant ?thing-for-info)
		)
    :effect
		(believes_hidden ?informed ?thing-for-info)    


    :agents (?informant ?informed)
)

	
(:action speak-to-has_success
    :parameters   (?informant - character ?character-for-info - character ?thing-for-info - thing ?informed - character ?room - room)
    :precondition 
		(and  
			(believes_at ?informant ?informant ?room)
			(believes_at ?informant ?informed ?room)
			(believes_has ?informant ?character-for-info ?thing-for-info)
			(believes_at ?informed ?informant ?room)
			(believes_at ?informed ?informed ?room)
			(believes_has ?informant ?character-for-info ?thing-for-info)
			(at ?informant ?room)
			(at ?informed ?room)
			(believes_has ?informant ?character-for-info ?thing-for-info)
		)
    :effect
		(believes_has ?informed ?character-for-info ?thing-for-info)    


    :agents (?informant ?informed)
)

	
(:action search-for_success
    :parameters   (?character - character ?thing - thing ?room - room)
    :precondition 
		(and  
			(believes_at ?character ?character ?room)
			(believes_in ?character ?thing ?room)
			(at ?character ?room)
			(in ?thing ?room)
		)
    :effect
		(and  
			(has ?character ?thing)
			(not  
				(in ?thing ?room)
			)
		)    


    :agents (?character)
)

	
(:action search-for_fail
    :parameters   (?character - character ?thing - thing ?room - room)
    :precondition 
		(and  
			(believes_at ?character ?character ?room)
			(believes_in ?character ?thing ?room)
			(or  
				(not  
					(at ?character ?room)
				)
				(not  
					(in ?thing ?room)
				)
			)
		)
    :effect
		(when  
			(and  
				(not  
					(in ?thing ?room)
				)
				(at ?character ?room)
			)
			(not  
				(believes_in ?character ?thing ?room)
			)
		)    


    :agents (?character)
)

	
(:action unlock_success
    :parameters   (?character - character ?key - key ?room - room)
    :precondition 
		(and  
			(believes_locked ?character ?room)
			(believes_unlocked-by ?character ?room ?key)
			(believes_has ?character ?character ?key)
			(locked ?room)
			(unlocked-by ?room ?key)
			(has ?character ?key)
		)
    :effect
		(not  
			(locked ?room)
		)    


    :agents (?character)
)

	
(:action unlock_fail
    :parameters   (?character - character ?key - key ?room - room)
    :precondition 
		(and  
			(believes_locked ?character ?room)
			(believes_unlocked-by ?character ?room ?key)
			(believes_has ?character ?character ?key)
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
			(believes_not_unlocked-by ?character ?room ?key)
		)    


    :agents (?character)
)

)

