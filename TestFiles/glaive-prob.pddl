
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
	(hidden key)
	(locked r5)
	(unlocked-by r5 key)
	(believes_in alice star r1)
	(believes_at alice alice r3)
	(believes_not_locked alice r1)
	(believes_not_locked alice r2)
	(believes_not_locked alice r3)
	(believes_not_locked alice r4)
	(believes_not_locked alice r5)
	(believes_not_locked alice r6)
	(intends alice (has alice key))
	(intends informant1 (has alice key))
	(intends informant2 (has alice key))
	(believes_in informant1 star r5)
	(believes_in informant2 key r4)
	(believes_unlocked-by informant2 r5 key)
	(believes_at informant1 informant1 r2)
	(believes_at informant2 informant2 r6)
    )
    (:goal
		(has alice key)
    )
)

