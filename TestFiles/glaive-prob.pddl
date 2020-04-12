
(define (problem six-rooms-bompiled)
    (:domain rooms-bompiled)
    (:objects
        :objects
alice - character
letter1 - character
letter2 - character
key - key
star - star
r1 - room
r2 - room
r3 - room
r4 - room
r5 - room
r6 - room

    )
    (:init
        (at letter1 r2)
	(at letter2 r6)
	(at alice r3)
	(in key r4)
	(in star r5)
	(hidden key)
	(loc
    )
    (:goal
		(has alice key)
    )
)
