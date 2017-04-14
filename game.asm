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
; tell user about the game
BEGIN	JSR	EXPLAIN
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
		JSR	OUTPUT	
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
VALIDINPUT	LD	R0,USERINPUT
		LD	R1,TESTLOWER
		ADD	R0,R0,R1	; check if less than 0
		BRn	BADINPUT
		LD	R0,USERINPUT
		LD	R1,TESTUPPER
		ADD	R0,R0,R1	; check to see if greater than 2
		BRp	BADINPUT
;
		LD	R0,USERINPUT	; load userinput to test
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
;
; Outputing a int between 0 & 999

; store registries for reloading at end of routine

OUTPUT	ST	R0,REG0		; store r0 into reg0 .blkw
	ST	R1,REG1
	ST	R2,REG2
	ST	R3,REG3
	ST	R4,REG4
	ST	R5,REG5
	ST	R6,REG6
	ST	R7,REG7		; PC counter to return to

; Set up registries for use

	;LD	R0,NUMBER	; Put number into r0
	AND	R3,R3,#0	; hundreds
	AND	R4,R4,#0	; tens
	AND	R5,R5,#0	; ones

; Figure out how many 100's and 10's there are, with 1's left over

HUNDS	LD	R2,NHNDRD	; load #-100 for use (to big)
	ADD	R0,R0,R2	; sub 100 to number for test (if there was 100 there)
	BRn	DONE1		; branch to done because there is no 100
	ADD	R3,R3,#1	; increment r3 (meaning there was 100 there)
	BRnzp	HUNDS		; hard branch until other branch gets us out
DONE1	LD	R2,HNDRD	; load #100 for use
	ADD	R0,R0,R2	; add 100 back on (because it turns out there was no hundred there)

TENS	LD	R2,NTEN		; load #-10 for use (consistancy)
	ADD	R0,R0,R2	; sub #10 for test
	BRn	DONE2		; branch to done because there is no 10
	ADD	R4,R4,#1	; increment tens
	BRnzp	TENS		; hard branch until other branch gets us out
DONE2	LD	R2,TEN		; load #10 for use
	ADD	R0,R0,R2	; add 10 back on

ONES	ADD	R5,R0,#0	; put whats left in r0 into r5, so we can use r0 for output

; Outputing to the console

	LD	R1,ASCII2	; load ascii value for 0 to be used to output
; hundreds
H	AND	R0,R0,#0	; clear r0 for output
	ADD	R0,R3,#0	; place hundreds in r0
	BRz	T		; dont display if it was 0
	ADD	R0,R0,R1	; load ascii offeset
	OUT			; output to console
	ADD	R6,R6,#1	; set flag for use of significant digit
; tens
T	AND	R0,R0,#0	; clear r0 for output
	ADD	R0,R4,#0	; place tens in r0
	BRnp	chck
	ADD	R6,R6,#0	; update the flag
	BRnz	O		; if signficant digit flag is not set (meaning no hundreds) then check for zero in tens place
chck	ADD	R0,R0,R1	; ascii offset
	OUT			; output to console
; ones
O	AND	R0,R0,#0	; clear r0 for output
	ADD	R0,R5,R1	; place ones in r0, also adding ascii here
	OUT			; output to console

	LD	R0,REG0		; load registries back in before leaving
	LD	R1,REG1
	LD	R2,REG2
	LD	R3,REG3
	LD	R4,REG4
	LD	R5,REG5
	LD	R6,REG6
	LD	R7,REG7		; load back to PC counter to return to if ever changed

	RET			; use if used as a function in a program

; New line function

NEWLINE	ST	R7,newLineReg7
	LEA	R0,return	; to output a new line character
	PUTs			; outputing \n (nukes my r7, thats why I need to store it)
	LD	R7,newLineReg7
	RET
;
; if correct, output a correct message and end
;
CORRECT		LEA 	R0, FINISH	; load finish string for output
		PUTS			; output finish string
		JSR	OUTPUT
		LEA	R0,PERIOD
		PUTS
;
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
;
ASCII2	.FILL	#48	; Zero in ascii
NUMBER	.FILL	#999	; test number
return	.STRINGZ	"\n"
;
NHNDRD	.FILL	#-100	; neg one hundred for test
HNDRD	.FILL	#100	; one hundred for test
NTEN	.FILL	#-10
TEN	.FILL	#10
;
REG0	.BLKW	1	; To restore the registers
REG1	.BLKW	1
REG2	.BLKW	1
REG3	.BLKW	1
REG4	.BLKW	1
REG5	.BLKW	1
REG6	.BLKW	1
REG7	.BLKW	1
newLineReg7	.BLKW	1
;
EXPLAIN .STRINGZ "Number Guessing Game\nThink of a number between 1 and 100.\nThe computer nwill try to guess it.\n"
QUESTIONPRE .STRINGZ "\nIs "
QUESTIONPOST .STRINGZ " your number? (0 = low, 1 = correct, 2 = high): "
WRONGINPUT .STRINGZ "ERROR: That is not a valid input.\nPlease try again.\n"
FINISH	.STRINGZ "\nYay, we guessed your number!\nYour number was "
PERIOD	.STRINGZ "."
;
  .END
;
