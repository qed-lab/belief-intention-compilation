
(define (problem six-rooms-bompiled)
    (:domain rooms-bompiled)
    (:objects
        :objects
alice - character
informant1 - character
informant2 - character
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
        (at informant1 r2)
	(at informant2 r6)
	(at alice r3)
	(in key r4)
	(in star r5)
	(locked r5)
	(unlocked-by r5 key)
	(believes_in alice star r1)
	(intends alice (has alice star))
	(intends informant1 (has alice star))
	(intends informant1 (has alice star))
	(believes_in informant1 star r5)
	(believes_in informant2 key r4)
	(believes_unlocked-by informant2 r5 key)
    )
    (:goal
		(has alice star)
    )
)

