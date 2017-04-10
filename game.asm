;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;           Number Guessing Game           ;;;
;;;           --------------------           ;;;
;;;                                          ;;;
;;;           Members:                       ;;;
;;;             - Jonathan Trousdale         ;;;
;;;             - Tyler Wray                 ;;;
;;;             - Bekah Williams             ;;;
;;;             - Justin Ward                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; This is a number guessing game that uses a binary search.
; The user thinks of a number in their head, and then
; our program tries to guess their number in the least amount
; of steps.
;
; ****** Register Map ******
; R0 = Input/Output
; R1 = High (100, Can't ever change)
; R2 = Low (0, Can't ever change)
; R3 = Guess
; R4 = Decide
; R5 = High + Low
; R6 = 2 (Can't ever change)
; counter placed in R3
;
	.ORIG x3000
;
; Clear all registers
;
CLEAR		AND	R0,R0,#0
		AND	R1,R1,#0
		AND	R2,R2,#0
		AND	R3,R3,#0
		AND	R4,R4,#0
		AND	R5,R5,#0
		AND	R6,R6,#0
		AND	R7,R7,#0
;
; Entry point for the program, Sets R1 = 100 and R2 = 0
;
		LD	R6,TWO		; set R6 to 2 (it should never change)
		LD	R1,HUNDRED	; set R1 to 100 for first run through
				        ; R2 is already set to 0
;
; Implementation of the binary search algorithm
;
START		ADD	R5,R1,R2	; add the high and low and save to R5
;
DIVISION	ADD	R5,R5,R6	; subtract 2 from the sum of high and low
		ADD	R3,R3,#1	; increment R7 (new guess) each implementation
		ADD	R5,R5,#0	; test for Branch
		BRp	DIVISION	; if positive repeat subtraction
;
; User Question: Ask the user if the new guess is correct and take input
;
USERQUESTION	LEA R0, QUESTIONPRE	; Load 'Pre' Question into R0
	        TRAP x22            	; Output 'Pre' Question
		ST R3, USERINPUT	; Save R3 out to memory. TODO: Load the contents of R3 into R0 for output. Not sure if this works
		LD R0, USERINPUT	; Load R0 with the contents of R3 for output
		TRAP x22		; Ouput the current Guess TODO: Figure out how to output numbers larger than 9
		LEA R0, QUESTIONPOST	; Load the 'Post' Question
		TRAP x22		; Output the 'Post' Question
		TRAP x20		; Get response from the console
		TRAP x21		; Show the user the number they entered
		BRz CORRECT		; Branch to Correct if it is 0
		ADD R0, R0, R6		; Test the user input by subtracting 2 from the number
		BRz TOOHIGH		; If 0, means user input is 2, go to TOOHIGH
		BRn TOOLOW		; If negative, means user input is 1, go to TOOLOW
		BRp INCORRECT		; If positive, means user input was not 0, 1, or 2. Branch to incorrect input sub-routine if number is less than 0 TODO: Creat incorrect input subroutine
;
		LD	R4,DECIDE	; load -1 to R4
		ADD	R4,R4,R0	; test R4 by addition to -1 to see if they answered (0,1,2) or (low,correct,high)
		BRn	TOOLOW		; test for too low
		BRp	TOOHIGH		; test for too high
		BRz	CORRECT		; test for correct answer
;
; if too low, change low to guess or R2 = R3
;
TOOLOW	      	ADD R2,R3,#0		; change low value to the previous guess
	     	AND R3,R3,#0		; clear R3 for iteration
	      	AND R5,R5,#0		; clear R5 for iteration
	     	BRnzp START		; go to start
;
; if too high, change high to guess or R1 = R3
;
TOOHIGH	      	ADD R1,R3,#0		; change high value to the previous guess
	      	AND R3,R3,#0		; clear R3 for iteration
	      	AND R5,R5,#0		; clear R5 for iteration
	      	BRnzp START		; go to start
;
; Branch here if input is incorrect
;
INCORRECT	LEA R0, WRONGINPUT	; Load R0 with wrong input string
		TRAP x22		; Output the Incorrect String
		TRAP x25		; Halt the Program TODO: Instead of halting the program, can we just loop back to the START Routine?	
;
; if correct, output a correct message and end
;
CORRECT		LEA R0, FINISH		; load finish string for output
		PUTS			; output finish string
	                        	; load guessed number to R0 (in R3)
	                        	; change from binary to ascii
	                        	; output guessed number 
		LEA R0,PERIOD		; load period
		PUTS			; output period
		HALT
;
;;;;;;;;;;;;;;;;
;   Constants  ;
;;;;;;;;;;;;;;;;
;
ANSWER .BLKW 1
USERINPUT .BLKW 1
TWO	.FILL	#-2 	
HUNDRED	.FILL	#100
DECIDE	.FILL	#-1
QUESTIONPRE .STRINGZ "Is "
QUESTIONPOST .STRINGZ " your number? (0 = low, 1 = correct, 2 = high): "
WRONGINPUT .STRINGZ "ERROR: That is not a valid input, Try again."
FINISH	.STRINGZ "Yay, we guessed your number!\nYour number was "
PERIOD	.STRINGZ "."
;
  .END
;
