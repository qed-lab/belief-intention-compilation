
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; The domain "heroes-journey", compiled for use in planners       ;;;
;;;  that support intention.                                        ;;;
;;;                                                                 ;;;
;;; Compilation by Matthew Christensen and Jennifer Nelson (2020)   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain heroes-journey-bompiled)
    (:requirements :adl :universal-preconditions :expression-variables :intentionality :disjunctive-preconditions :negative-preconditions)
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
		(believes_not_threatening ?who - character ?threat - existential-threat ?village - village)
		(believes_threatening ?who - character ?threat - existential-threat ?village - village)
		(believes_not_wields ?who - character ?char - character ?power - superpower)
		(believes_wields ?who - character ?char - character ?power - superpower)
		(believes_not_dead ?who - character ?char - character)
		(believes_dead ?who - character ?char - character)
		(believes_not_has ?who - character ?char - character ?thing - thing)
		(believes_has ?who - character ?char - character ?thing - thing)
		(believes_not_at ?who - character ?character - character ?place - place)
		(believes_at ?who - character ?character - character ?place - place)
		(believes_not_in ?who - character ?threat - existential-threat ?place - place)
		(believes_in ?who - character ?threat - existential-threat ?place - place)
		(believes_not_safe ?who - character ?place - place)
		(believes_safe ?who - character ?place - place)
		(believes_not_destroyed ?who - character ?place - place)
		(believes_destroyed ?who - character ?place - place)
    )
    
(:action threaten
    :parameters   ( ?threat - existential-threat ?place - village ?char - character)
    :precondition 
		(in ?threat ?place)
    :effect
		(and  
			(threatening ?threat ?place)
			(intends ?char 
				(safe ?place)
			)
			(believes_threatening ?char ?threat ?place)
		)    


    
)

	
(:action save_success
    :parameters   ( ?hero - character ?power - superpower ?threat - existential-threat ?place - village)
    :precondition 
		(and  
			(wields ?hero ?power)
			(threatening ?threat ?place)
			(believes_wields ?hero ?hero ?power)
			(believes_threatening ?hero ?threat ?place)
		)
    :effect
		(and  
			(not  
				(threatening ?threat ?place)
			)
			(not  
				(in ?threat ?place)
			)
			(safe ?place)
			(believes_not_threatening ?hero ?threat ?place)
			(believes_not_in ?hero ?threat ?place)
			(believes_safe ?hero ?place)
		)    


    :agents (?hero)
)

	
(:action save_fail
    :parameters   ( ?hero - character ?power - superpower ?threat - existential-threat ?place - village)
    :precondition 
		(and  
			(or  
				(not  
					(wields ?hero ?power)
				)
				(not  
					(threatening ?threat ?place)
				)
			)
			(believes_wields ?hero ?hero ?power)
			(believes_threatening ?hero ?threat ?place)
		)
    :effect
		(destroyed ?place)    


    :agents (?hero)
)

	
(:action visit_success
    :parameters   ( ?hero - character ?src - place ?mentor - character ?dest - place)
    :precondition 
		(and  
			(at ?hero ?src)
			(at ?mentor ?dest)
			(believes_at ?hero ?hero ?src)
			(believes_at ?hero ?mentor ?dest)
		)
    :effect
		(and  
			(not  
				(at ?hero ?src)
			)
			(at ?hero ?dest)
			(intends ?mentor 
				(not  
					(at ?hero ?dest)
				)
			)
			(believes_at ?hero ?hero ?dest)
			(believes_at ?mentor ?hero ?dest)
			(believes_not_at ?hero ?hero ?src)
			(not  
				(believes_at ?hero ?hero ?src)
			)
		)    


    :agents (?hero)
)

	
(:action visit_fail
    :parameters   ( ?hero - character ?src - place ?mentor - character ?dest - place)
    :precondition 
		(and  
			(or  
				(not  
					(at ?hero ?src)
				)
				(not  
					(at ?mentor ?dest)
				)
			)
			(believes_at ?hero ?hero ?src)
			(believes_at ?hero ?mentor ?dest)
		)
    :effect
		(and  
			(not  
				(at ?hero ?src)
			)
			(at ?hero ?dest)
			(believes_at ?hero ?hero ?dest)
			(believes_not_at ?hero ?hero ?src)
			(not  
				(believes_at ?hero ?hero ?src)
			)
		)    


    :agents (?hero)
)

	
(:action teach_success
    :parameters   ( ?teacher - character ?student - character ?power - superpower ?place - place)
    :precondition 
		(and  
			(at ?teacher ?place)
			(believes_at ?teacher ?teacher ?place)
			(believes_at ?student ?teacher ?place)
		)
    :effect
		(believes_wields ?student ?student ?power)    


    :agents (?teacher ?student)
)

	
(:action teach_fail
    :parameters   ( ?teacher - character ?student - character ?power - superpower ?place - place)
    :precondition 
		(and  
			(not  
				(at ?teacher ?place)
			)
			(believes_at ?teacher ?teacher ?place)
			(believes_at ?student ?teacher ?place)
		)
    :effect
		(believes_not_wields ?student ?student ?power)    


    :agents (?teacher ?student)
)

	
(:action remove-to_success
    :parameters   ( ?teacher - character ?student - character ?src - place ?dest - place)
    :precondition 
		(and  
			(at ?teacher ?src)
			(at ?student ?src)
			(believes_at ?teacher ?teacher ?src)
			(believes_at ?teacher ?student ?src)
		)
    :effect
		(and  
			(not  
				(at ?student ?src)
			)
			(at ?student ?dest)
			(believes_not_at ?student ?student ?src)
			(believes_at ?student ?student ?dest)
			(believes_not_at ?teacher ?student ?src)
			(believes_at ?teacher ?student ?dest)
		)    


    :agents (?teacher)
)

)

