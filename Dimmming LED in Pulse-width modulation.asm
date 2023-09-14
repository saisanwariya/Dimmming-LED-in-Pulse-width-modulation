***************************************************************************************
*
*	Title:			  LED Light Duty Cycle Gradual Increase/Decrease
*
*	Objective:		CMPEN 472 Homework 4
*
*	Revision:		  v1.0
*
*	Date:			    Feb. 10, 2023
*
* 	Orginal Programmer: Kyusun Choi 
*
* 	Programmer:   Sai Narayan
*
*	Company:		  The Pennsylvania State University
*					      Department of Computer Science and Engineering
*
*	Program:		  LED 3 ON
*					      LED 1 Gradually increases, and then decreases, duty cycle
*
*	Algorithm:		Simple Parallel I/O use and time delay-loop
*
*	Register use:	A: Used for loading variables and numeric data 
*					      X: Used for delay counter
*
*	Memory use:		RAM Locations from $3000 for data,
*					      RAM Locations from $3100 for prgm
*
*	Input:			  Parameters hard-coded in the program - PORTB
*					      LED1 @ PORTB bit 4
*						    LED2 @ PORTB bit 5
*						    LED3 @ PORTB bit 6
*					    	LED$ @ PORTB bit 7
*
*	Observation: 	This is a program that blinks LEDs and blinking period can
*					      be changed with the delay loop counter variable.
*
***************************************************************************************
*	Parameter Declaration Section
*
*	Export Symbols
				    XDEF		  pstart		;export 'pstart' symbol
				    ABSENTRY	pstart		;for assembly entry point
				
*	Symbols and Macros
PORTA			  EQU			$0000		    ;i/o port A addr
PORTB			  EQU			$0001		    ;i/o port B addr
DDRA			  EQU			$0002       ; Data direction Register for Port A
DDRB			  EQU			$0003				; Data direction Register for Port B			
***************************************************************************************
* Data Section: addr used [$3000 to $30FF] RAM
*
            ORG       $3000     ;reserved RAM starting addr
                                ; for Data for CMPEN 472 class
Counter1    DC.W      $002E     ;X register count number for time delay  
                                ;(46 loops makes delay10US take approx 10usec on HCS12 board)
                                
CTR         DC.W      $0000     ;counter variable for dim10ms loop
LEVEL       DC.W      $0000     ;Loop control variable and time on/off decider 
ONN         DC.W      $0000     ;Turn-on-loop control variable   
OFF         DC.W      $0000     ;Turn-off-loop control variable     
                            
                                ;Remaining data memory space for stack,
                                ; up to prgm mem start.                            
*
***************************************************************************************
*	Program Section: addrs used [$3100 to $3FFF] RAM
*
				    ORG			$3100		    ;program start address, in RAM
pstart	    LDS			#$3100		  ;initialise the stack pointer

				    LDAA		#%11110000	;LED 1,2,3,4 @ PORTB bit 4,5,6,7
				    STAA		DDRB		    ;set PORTB bit 4,5,6,7 as output
										
				    LDAA		#%10110000	
				    STAA		PORTB		    ;turn off LED 1,2,4; turn ON LED3 
				
mainLoop		
            LDAA    #$0000
				    STAA		LEVEL		    ;set LEVEL = 0
				
dimUp
				    LDAA		LEVEL		    ;check bit 0 of PORTB, switch1
				    CMPA		#$0065	    ;(0x65 == 101) checking if LEVEL == 101? 
				    BEQ     mid         ; if so, exit dimUp loop and proceed
				    
				    JSR			dim10MS			    
				    INC     LEVEL       ;LEVEL = LEVEL + 1
				    BRA			dimUp  	    ;restarting dimUp loop

mid         LDAA    #$0064
            STAA    LEVEL       ;set LEVEL back to 100

dimDown			
				    TST     LEVEL       ;Checking if LEVEL == 0
				    BEQ     mainLoop    ; if YES, branch back to mainLoop
				    
				    JSR			dim10MS
				    DEC     LEVEL       ;LEVEL = LEVEL - 1
				    BRA			dimDown	    ;restarting dimDown loop
				
***************************************************************************************
*	Subroutine Section:	addr used [$3100 to $3FFF] RAM
*
;				
;**************************************************************************************				
;	dim10MS subroutine
;
;	This subroutine loops 10 times and calls dim
;
;	Input:  CTR, a counter for this loop		
;	Output: Dim is called 10 times		
;	Registers in use:	A, for a numeric value
;	Memory locations in use: 16bit input number @ 'CTR'
;

dim10MS
				    LDAA    #$000A      ; #000A = 10  
				    STAA    CTR         ;setting CTR = 10
				    
dim10Loop   TST     CTR         ;Checking if CTR == 0
				    BNE     dim10cont   ; if YES, skip dim10Loop
            RTS     
            
dim10cont   JSR     dim
            DEC     CTR         ;CTR = CTR - 1
            BRA     dim10Loop   ;restarting loop		
            
;**************************************************************************************
;	dim subroutine
;
; This subroutine controls the dim up and down functionality at each stage
;
;	Input:  LEVEL, the current duty cycle, ONN & OFF, the time variables that control
;           how long each loop runs for	
;	Output:	Turns on and off LED2
;	Registers in use: A	register, as a counter and to store numeric values for 
;                     various purposes, such as setting which LEDs to turn on
;	Memory locations in use: 16bit input numbers @ 'ONN' and 'OFF' 
;

dim
				    LDAA    LEVEL
				    STAA    ONN         ;setting ONN = LEVEL
				    LDAA    #$0064
				    SUBA    LEVEL
				    STAA    OFF         ;setting OFF = 100 - LEVEL
				    
				    LDAA		#%00010000	;Turn on LED1 at PORTB at bit 4
				    ORAA	  PORTB
				    STAA		PORTB

onnLoop     TST     ONN         ;does ONN == 0
				    BEQ     midDim      ; if so, skip onnLoop
            JSR     delay10US
            DEC     ONN         ;ONN = ONN - 1
            BRA     onnLoop     ;restarting loop
				    
midDim	    LDAA		#%11101111	;Turn off LED1 at PORTB at bit 4
				    ANDA		PORTB
				    STAA		PORTB

offLoop     TST     OFF         ;does OFF == 0?
				    BEQ     return      ; if YES, exit dim
            JSR     delay10US
            DEC     OFF         ;OFF = OFF - 1
				    BRA     offLoop     ;restarting loop
				
return      RTS						      ;return
		    

;**************************************************************************************
; delay10US subroutine 
;
; This subroutine causes few usec. delay
;
; Input:  a 16bit count number in 'Counter1'
; Output: time delay, cpu cycle wasted
; Registers in use: X register, as counter
; Memory locations in use: a 16bit input number @ 'Counter1'
;
; Comments: one can add more NOPs to lengthen the delay time.
;

delay10US
          PSHX                  ;save X
          LDX       Counter1    ;short delay
          
dlyUSLoop NOP                   ;total time delay = X * NOP
          DEX
          BNE       dlyUSLoop
          
          PULX                  ;restore X
          RTS                   ;return

*
*	Add any subroutines here
*

				  END						        ;last line of a file