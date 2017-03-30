;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;           Number Guessing Game           ;;;
;;;           --------------------           ;;;
;;;                                          ;;;
;;;           Members:                       ;;;
;;;             - Jonathan Trousdale          ;;;
;;;             - Tyler Wray                 ;;;
;;;             - Bekah Williams             ;;;
;;;             - Justin Ward                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
.ORIG x3000
;
HALT
;;;;;;;;;;;;;;;;
;   Constants  ;
;;;;;;;;;;;;;;;;
ANSWER .BLKW 1
QUESTIONPRE .STRINGZ "Is "
QUESTIONPOST .STRINGZ " your number?"
VALIDATION .STRINGZ "Were we right? (0 = low, 1 = correct, 2 = high): "
.END
