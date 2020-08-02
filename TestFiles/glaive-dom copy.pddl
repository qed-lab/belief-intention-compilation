
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; The domain "rooms", compiled for use in planners                ;;;
;;;  that support intention.                                        ;;;
;;;                                                                 ;;;
;;; Compilation by Matthew Christensen and Jennifer Nelson (2020)   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain rooms-bompiled)
    (:requirements :disjunctive-preconditions :adl :expression-variables :intentionality)
    (:types
    
key star - thing
character room thing

    )
    (:predicates
        (locked ?room)
		(at ?character ?room)
		(unlocked-by ?room ?key)
		(in ?thing ?room)
		(has ?character ?thing)
		(believes_not_locked ?who ?room)
		(believes_locked ?who ?room)
		(believes_not_at ?who ?character ?room)
		(believes_at ?who ?character ?room)
		(believes_not_unlocked-by ?who ?room ?key)
		(believes_unlocked-by ?who ?room ?key)
		(believes_not_in ?who ?thing ?room)
		(believes_in ?who ?thing ?room)
		(believes_not_has ?who ?character ?thing)
		(believes_has ?who ?character ?thing)
		;(flag)
    )

(:action enter_success
    :parameters   (?character - character ?roomfrom - room ?roomto - room)
    :precondition 
		(and
			(believes_at ?character ?character ?roomfrom)
			(believes_not_locked ?character ?roomto)  ; SUCCEEDS
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
			;(flag)
		)
    :effect
           (and
                (not (believes_not_locked ?character ?roomto) )
                (believes_locked ?character ?roomto)
           )


    :agents (?character)
)
;(:action enter_fail1
;    :parameters   (?character - character ?roomfrom - room ?roomto - room)
;    :precondition
;		(and
;			(believes_not_locked ?character ?roomto)
;			(believes_at ?character ?character ?roomfrom)
;			(or
;				(locked ?roomto)
;				(not
;					(at ?character ?roomfrom)
;				)
;			)
;		)
;    :effect
;           ;(and
;                ;(not (believes_not_locked ?character ?roomto) )
;                (believes_locked ?character ?roomto)
;           ;)
;
;
;    :agents (?character)
;)
;(:action enter_fail2
;    :parameters   (?character - character ?roomfrom - room ?roomto - room)
;    :precondition
;		(and
;			(believes_not_locked ?character ?roomto)
;			(believes_at ?character ?character ?roomfrom)
;			(or
;				(locked ?roomto)
;				(not
;					(at ?character ?roomfrom)
;				)
;			)
;		)
;    :effect
;           ;(and
;                (not (believes_not_locked ?character ?roomto) )
;                ;(believes_locked ?character ?roomto)
;           ;)
;
;
;    :agents (?character)
;)





	
(:action speak-to-in_success
    :parameters   (?informant - character ?thing-for-info - thing ?room-for-info - room ?informed - character ?room - room)
    :precondition 
		(and  
			(believes_at ?informant ?informant ?room)
			(believes_at ?informant ?informed ?room)
			(believes_at ?informed ?informant ?room)
			(believes_at ?informed ?informed ?room)
			(at ?informant ?room)
			(at ?informed ?room)
			(believes_in ?informant ?thing-for-info ?room-for-info)
		)
    :effect
		(believes_in ?informed ?thing-for-info ?room-for-info)    


    :agents ( ?informed)
)


(:action speak-to-unlocked-by_success
    :parameters   (?informant - character ?room-for-info - room ?key-for-info - key ?informed - character ?room - room)
    :precondition
		(and
			(believes_at ?informant ?informant ?room)
			(believes_at ?informant ?informed ?room)
			(believes_at ?informed ?informant ?room)
			(believes_at ?informed ?informed ?room)
			(at ?informant ?room)
			(at ?informed ?room)
			(believes_unlocked-by ?informant ?room-for-info ?key-for-info)
		)
    :effect
		(believes_unlocked-by ?informed ?room-for-info ?key-for-info)


    :agents ( ?informed)
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
			(believes_has ?character ?character ?thing)
			(believes_not_in ?character ?thing ?room)
			(not  
				(believes_not_has ?character ?character ?thing)
			)
			(not  
				(believes_in ?character ?thing ?room)
			)
			;(flag)
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
    :parameters   (?character - character ?key - key ?room - room)
    :precondition 
		(and
		     ;(not (believes_not_locked ?character ?room))
			(believes_locked ?character ?room)
			(believes_unlocked-by ?character ?room ?key)
			(believes_has ?character ?character ?key)
			(locked ?room)
			(unlocked-by ?room ?key)
			(has ?character ?key)
		)
    :effect
		(and  
			(believes_not_locked ?character ?room)
			(not
				(locked ?room)
			)
			(not
				(believes_locked ?character ?room)
			)
		)


    :agents (?character)
)



)

