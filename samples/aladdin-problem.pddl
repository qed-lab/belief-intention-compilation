;;;
;;; A problem for telling the story of Aladdin from 1001 Nights
;;; Created by Mark O. Riedl for his dissertation
;;; Ported to PDDL 3 by Stephen G. Ware
;;;
(define (problem aladdin-cave)
  (:domain aladdin)
  (:objects hero - knight
            king - king
            jasmine - female
            dragon - dragon
            genie - genie
            castle mountain brothel - place
            lamp - magic-lamp)
  (:init (alive hero) (beautiful hero) (single hero) (at hero brothel) (loyal-to hero king) (intends hero (not (alive jasmine)))
         (alive king) (single king) (at king castle) (intends king (not (married-to king jasmine)))
         (alive jasmine) (beautiful jasmine) (single jasmine) (at jasmine brothel) (intends jasmine (alive jasmine))
         (alive dragon) (scary dragon) (at dragon mountain) (has dragon lamp) (intends dragon (not (alive king)))
         (alive genie) (beautiful genie) (single genie) (confined genie) (in genie lamp))
  (:goal      (and (married-to hero genie)
              (married-to king jasmine))))
