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
;
; this is a number guessing game that uses a binary search
; the following are what the registers are to be used for
; R0 = Input/Output
; R1 = High
; R2 = Low
; R3 = Guess
; R4 = Decide
; R5 = High + Low, R6 = 2, counter placed in R3
;
.ORIG x3000
;
; Clear all registers
;
CLEAR	AND	R0,R0,#0
	AND	R1,R1,#0
	AND	R2,R2,#0
	AND	R3,R3,#0
	AND	R4,R4,#0
	AND	R5,R5,#0
	AND	R6,R6,#0
	AND	R7,R7,#0
;
; first run through R1 = 100 and R2 = 0
;
	LD	R6,TWO		  ;set R6 to 2 (it should never change)
	LD	R1,HUNDRED	;set R1 to 100 for first run through
				          ;R2 is already set to 0
;
; Implementation of the binary search algorithm
;
IMPLEMENTATION	ADD	R5,R1,R2	;add the high and low and save to R5
;
DIVISION	ADD	R5,R5,R6	;subtract 2 from the sum of high and low
		      ADD	R3,R3,#1	;increment R7 (new guess) each implementation
		      ADD	R5,R5,#0	;test for Branch
		      BRp	DIVISION	;if positive repeat subtraction
;
; ask the user if the new guess is correct and take input
;
USERQUESTION  l	            ; load question string is it the number in R3?
		                        ; output question string
		                        ; input is in R0
		                        ; change from ascii to binary **keep value in R0
		          LD	R4,DECIDE	; load -1 to R4
		          ADD	R4,R4,R0	; test R4 by addition to -1 to see if they answered (0,1,2) or (low,correct,high)
		          BRn	TOOLOW		;test for too low
		          BRp	TOOHIGH		;test for too high
		          BRz	CORRECT		;test for correct answer
;
; if too low, change low to guess or R2 = R3
;
TOOLOW	      ADD	R2,R3,#0	;change low value to the previous guess
	            AND	R3,R3,#0	;clear R3 for iteration
	            AND	R5,R5,#0	;clear R5 for iteration
	            BRnzp	IMPLEMENTATION  ;go to implementation
;
; if too high, change high to guess or R1 = R3
;
TOOHIGH	      ADD	R1,R3,#0	;change high value to the previous guess
	            AND	R3,R3,#0	;clear R3 for iteration
	            AND	R5,R5,#0	;clear R5 for iteration
	            BRnzp	IMPLEMENTATION  ;go to implementation
;
; if correct, output a correct message and end
;
CORRECT	      LEA	R0,FINISH	;load finish string for output
	            PUTS			    ;output finish string
	                          ;load guessed number to R0 (in R3)
	                          ;change from binary to ascii
	                          ;output guessed number 
	            LEA	R0,PERIOD	;load period
	            PUTS			;output period
	  HALT
;
;;;;;;;;;;;;;;;;
;   Constants  ;
;;;;;;;;;;;;;;;;
;
ANSWER .BLKW 1
TWO	.FILL	#-2 	
HUNDRED	.FILL	#100
DECIDE	.FILL	#-1
QUESTIONPRE .STRINGZ "Is "
QUESTIONPOST .STRINGZ " your number?"
VALIDATION .STRINGZ "Were we right? (0 = low, 1 = correct, 2 = high): "
FINISH	.STRINGZ "Yay, we guessed your number!\nYour number was "
PERIOD	.STRINGZ "."
;
  .END
;
