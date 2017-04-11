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
; note that this is just a general key to use, variables are stored
; R0 = Input/Output
; R1 = High (100, Can't ever change)
; R2 = Low (0, Can't ever change)
; R3 = Guess
; R4 = Decide
; R5 = High + Low
; R6 = 2
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
		LD	R1,HUNDRED	; set R1 to 100 for first run through
		ST	R1,HIGH		; store 100 into variable high
		LD	R2,ZERO		; set R2 to 0 for first run through
		ST	R2,LOW		; store 0 into variable low
		LD	R4,NEGONE	; load -1 into R4
		ST	R4,DECIDE	; store -1 into variable decide
;
; Implementation of the binary search algorithm
;
START		LD	R6,TWO		; load 2 into R6 - for division puposes
		LD	R1,HIGH		; load high into R1
		LD	R2,LOW		; load low into R2
		ADD	R5,R1,R2	; add the high and low and save to R5
;
DIVISION	ADD	R5,R5,R6	; subtract 2 from the sum of high and low
		ADD	R3,R3,#1	; increment R7 (new guess) each implementation
		ST	R3,GUESS	; store the new number for guess into variable GUESS
		ADD	R5,R5,#0	; test for Branch
		BRp	DIVISION	; if positive repeat subtraction
;
; User Question: Ask the user if the new guess is correct and take input
;
USERQUESTION	LEA 	R0,QUESTIONPRE	; Load 'Pre' Question into R0
	        PUTS            	; Output 'Pre' Question
		LD	R0,GUESS	; load variable GUESS into R0
		;Ouput the current Guess TODO: Figure out how to output numbers larger than 9
		OUT			; output GUESS
		LEA	R0,QUESTIONPOST	; Load the 'Post' Question
		PUTS			; Output the 'Post' Question
		GETC			; Get response from console
		OUT			; Show the user the number they entered
		LD	R1,ASCII
		ADD	R0,R0,R1	; change from ascii to binary
		ST	R0,USERINPUT	; save input in variable userinput
;
; check to make sure user entered valid input
;
		;??? what are these next few lines of code for?
		;ST R3, USERINPUT	; Save R3 out to memory. TODO: Load the contents of R3 into R0 for output. Not sure if this works
		;LD R0, USERINPUT	; Load R0 with the contents of R3 for output
		;BRz CORRECT		; Branch to Correct if it is 0
		;ADD R0, R0, R6		; Test the user input by subtracting 2 from the number
		;BRz TOOHIGH		; If 0, means user input is 2, go to TOOHIGH
		;BRn TOOLOW		; If negative, means user input is 1, go to TOOLOW
		;BRp INCORRECT		; If positive, means user input was not 0, 1, or 2. Branch to incorrect input sub-routine if number is less than 0 TODO: Creat incorrect input subroutine
;
		LD	R4,DECIDE	; load -1 to R4
		ADD	R4,R4,R0	; test R4 by addition to -1 to see if they answered (0,1,2) or (low,correct,high)
		BRn	TOOLOW		; test for too low
		BRp	TOOHIGH		; test for too high
		BRz	CORRECT		; test for correct answer
;
; if too low, change low to guess or R2 = R3
;
TOOLOW	      	LD	R3,GUESS	; load GUESS into R3
		LD	R2,LOW		; load LOW into R2
		ADD 	R2,R3,#0	; change low value to the previous guess
		ST	R2,LOW		; store number in R2 in variable LOW
	     	AND 	R3,R3,#0		; clear R3 for iteration
	      	AND 	R5,R5,#0		; clear R5 for iteration
	     	BRnzp 	START		; go to start
;
; if too high, change high to guess or R1 = R3
;
TOOHIGH	      	LD	R3,GUESS	; load GUESS into R3
		LD	R1,HIGH		; load HIGH into R1
		ADD 	R1,R3,#0	; change high value to the previous guess
		ST	R1,HIGH		; store number in R1 in variable HIGH
	      	AND 	R3,R3,#0	; clear R3 for iteration
	      	AND 	R5,R5,#0	; clear R5 for iteration
	      	BRnzp 	START		; go to start
;
; Branch here if input is incorrect
;
BADINPUT	LEA 	R0,WRONGINPUT	; Load R0 with wrong input string
		PUTS			; Output the Incorrect String
		BRnzp	START		; loop back to START routine	
;
; if correct, output a correct message and end
;
CORRECT		LEA 	R0, FINISH	; load finish string for output
		PUTS			; output finish string
	        LD	R0,GUESS       	; load guessed number to R0 (in R3)
	                        	; change from binary to ascii
	        OUT                	; output guessed number 
		LEA 	R0,PERIOD	; load period
		PUTS			; output period
		HALT
;
;;;;;;;;;;;;;;;;
;   Constants  ;
;;;;;;;;;;;;;;;;
;
ANSWER .BLKW 	1
USERINPUT .BLKW 1
HIGH	.BLKW	1
LOW	.BLKW	1
GUESS	.BLKW	1
DECIDE	.BLKW	1
TWO	.FILL	#-2 
ZERO	.FILL	#0
HUNDRED	.FILL	#100
NEGONE	.FILL	#-1
ASCII	.FILL	#-48
TESTLOWER	.FILL	#0
TESTUPPER	.FILL	#-2
QUESTIONPRE .STRINGZ "\nIs "
QUESTIONPOST .STRINGZ " your number? (0 = low, 1 = correct, 2 = high): "
WRONGINPUT .STRINGZ "ERROR: That is not a valid input.\nPlease try again.\n"
FINISH	.STRINGZ "\nYay, we guessed your number!\nYour number was "
PERIOD	.STRINGZ "."
;
  .END
;
