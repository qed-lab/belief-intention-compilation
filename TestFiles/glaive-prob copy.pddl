
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
	;;(has alice key)
	(in star r5)

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
	;(believes_in alice key r4)

	(intends alice (has alice star))

	;;(intends informant1 (at alice r4))
	;;(intends informant2 (at alice r4))

	(believes_in informant1 star r5)
	(believes_in informant2 key r4)
	(believes_unlocked-by informant2 r5 key)
	(believes_at informant1 informant1 r2)
	(believes_at informant2 informant2 r6)

	;;(believes_has alice alice key)

	;;(believes_locked alice r5)

	;;(believes_unlocked-by alice r5 key)
    )
    (:goal
		(has alice star)
    )
)

