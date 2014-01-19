;---satimsa@gmail.com
; YZU CN 2A


	ORG 0
	LJMP MAIN
	ORG 000BH
	LJMP ISR_T0
	
	ORG 0013H
	LJMP ISR_INT1
	ORG 001BH   ;isr t1
	MOV TH1,#0FEH
	MOV TL1,#02H
	DJNZ 28H,T1R
	MOV 28H,#0F0H
	CLR TR1
	SETB 75H
T1R:RETI
	ORG 0030H
MAIN:	MOV 1CH,#0FEH
		MOV 1BH,#00H
		MOV 1FH,#0
		MOV 1EH,#0
		MOV 20H,#00H	;   number1
		MOV 21H,#00H	;	number2
		MOV 22H,#70H	;	number3   	01110000
		MOV 23H,#0B0H	;	number4		10110000	
		MOV 24H,#0D0H	;	number5		11010000
		MOV 25H,#0E0H	;	number6		11100000
		MOV 26H,#250	;	buffer1
		MOV 27H,#16		;	buffer2
		MOV 28H,#0F0H	;	buffer1
		;	alaem time
		MOV 2AH,#70H	;	number3 m
		MOV 2BH,#0B0H	;	number4	m
		MOV 2CH,#0D0H	;	number5	h
		MOV 2DH,#0E0H	;	number6	h
		CLR 70H 	; in Setting time
		CLR 71H		; in Setting alarm time
		CLR 72H		; ALARM IS DOING       時間到
		CLR 73H		; TRIGER ADDMIN
		CLR 74H		; TRIGER HOUR
		SETB 75H		;delay for button
		CLR 76H		;relrase alarm
		CLR 77H		;play music
		SETB P3.0		; add min
		SETB P3.1		; add hour
		SETB P3.2		; set time
		SETB P3.4		; set alarm time
		SETB P3.5		; set runnung alarm
		CLR  P3.7; the dot
		MOV TMOD,#12H		; using timer 0&1  mode 2
		MOV TH0,#06H
		MOV TL0,#06H
		MOV TH1,#0FEH
		MOV TL1,#02H
		SETB TR0
		CLR  TF0
		MOV IE , #10001110B
		SETB TCON.2
		;Normal TYPE
		
MESSA:	ACALL LISTEN
		JNB P3.5,DEBUT
		ACALL ALARM ; check for alarm (72H
		JNB 72H ,DEBUT
		JB 76H,DEBUT
PLAYYEE:LJMP MUSIC
DEBUT:	JB 77H,PLAYYEE
		JNB 75H,$ 
		SJMP MESSA 
		
	;----------------------------------------main end
ISR_INT1:	MOV 1FH,A
			MOV A,1CH
			RR A
			MOV 1CH,A
			MOV A,1FH
			RETI
	
	
	
	
ISR_T0:	MOV P1,1CH
		MOV P0,1BH
		MOV R1,A
		MOV P2,@R0 
		INC R0
		JB 71H , SALARM   ; if in setting alarm time ,jump
		MOV A,R0
		CJNE A,#26H,CONTI
		MOV R0,#22H
		SJMP CONTI
SALARM: MOV A,R0
		CJNE A,#2EH,AMOOH0
		MOV R0,#2AH
AMOOH0:	JNB 73H,AMOOH
		CLR 73H
		INC 2AH
		ACALL ACHECK
AMOOH:	JNB 74H,CONTI
		CLR 74H
		INC 2CH
		ACALL ACHECK
		SJMP CONTI
	
RRRES:	MOV A,R1
		RETI
	
CONTI:	DJNZ 26H,RRRES
		MOV 26H,#250
		
		
		
LEDSSSS:MOV A,1DH
		CJNE A,#23,LEDP0 ; for P0 七彩
		MOV 1DH,#0
LEDP0:	INC 1DH
		MOV 1FH,DPL
		MOV 1EH,DPH
		MOV DPTR,#LEDSG
		MOV A,1DH
		MOVC A,@A+DPTR
		MOV 1BH,A
		MOV DPL,1FH
		MOV DPH,1EH

		
		MOV A,27H
LEDP:	CJNE A,#9,CHECK2
		JNB 70H , DOTL0      ;設定現在時間中
		SETB P3.7
		SJMP DOTL
DOTL0:	JNB 71H , DOTL		;設定鬧鐘時間中
		CLR P3.7
DOTL:	CPL P3.7			;非設定中要用閃閃發亮
CHECK2:	DJNZ 27H,CHECK3
		MOV 27H,#16
		; 一秒到達
		INC 20H		;秒個位+1
		INC P0
CHECK3:	JNB 70H,CHECKS
		JNB 74H,RRTTR
		CLR 74H
		INC 24H
RRTTR:	JNB 73H,CHECKS
		CLR 73H
		INC 22H
CHECKS:	MOV A,20H
		CJNE A,#10,SEC
		MOV 20H,#00H
		INC 21H    ;秒十位數+1
SEC:	MOV A,21H
		CJNE A,#6,MIN
		INC 22H			;分		個位數+1
		MOV 21H,#00H
MIN:	MOV A,22H
		CJNE A,#7AH,MIN1
		MOV 22H,#70H
		INC 23H			;分十位數+1
		CLR 76H    ; for alaem using
MIN1:	MOV A,23H
		CJNE A,#0B6H,HR
		INC 24H			;時     個位數+1
		MOV 23H,#0B0H
HR:		MOV A,25H
		CJNE A,#0E2H,HHH
		MOV A,24H
		CJNE A,#0D4H,HHH
		MOV 24H,#0D0H
		MOV 25H,#0E0H
HHH:	MOV A,24H
		CJNE A,#0DAH,RRRE
		MOV 24H,#0D0H
		INC 25H			;時		十位數+1	
RRRE:	MOV A,R1
		RETI
	
	;
	;		ISR ENDING
	;
	
	
	; functions
    	;event listening    1. normal  buttion  2. alarming button  3.alarm time check
LISTEN:	JB	P3.0,ADDMIN	
		JB	P3.1,ADDHOUR
		JB	P3.2,MODDS
		JB	P3.4,AMODDS
		SJMP XX
ADDMIN:	JNB 70H,ADDMIN0
		SETB 73H
ADDMIN0:JNB 71H,XX0
		SETB 73H
		SJMP XX0
ADDHOUR:JNB 70H,ADDHOUR0
		SETB 74H
ADDHOUR0:JNB 71H,ADDHOUR1
		SETB 74H
ADDHOUR1:JB 70H,XX0
		JB 71H,XX0
		SETB 72H
		CLR 76H
		SETB 77H
		SJMP XX0			
MODDS:	JB 71H,XX
		JB  P3.2,MODDS
		CPL 70H
		SJMP XX0
AMODDS: JB 70H,XX
		JB  P3.4,AMODDS
		CPL 71H
		JB 71H,AMMM
		MOV R0,#22H ;代表剛設定完成
		SJMP XX0
AMMM:	MOV R0,#2AH ;代表進入設定鬧鐘
XX0:	CLR 75H
		SETB TR1
XX:		RET

ALISTEN:	JNB P3.0,XX
			JNB P3.1,XX
			JNB P3.2,XX
			JNB P3.4,XX
			SETB 76H
			CLR 72H
			CLR 73H
			CLR 74H
			CLR 77H
			SJMP XX0
			
	;alarm time check
ACHECK:	MOV A,2AH
		CJNE A,#7AH,AMIN1
		MOV 2AH,#70H
		INC 2BH			;分十位數+1
AMIN1:	MOV A,2BH
		CJNE A,#0B6H,AHR
		INC 2CH			;時     個位數+1
		MOV 2BH,#0B0H
AHR:	MOV A,2DH
		CJNE A,#0E2H,AHHH
		MOV A,2CH
		CJNE A,#0D4H,AHHH
		MOV 2CH,#0D0H
		MOV 2DH,#0E0H
AHHH:	MOV A,2CH
		CJNE A,#0DAH,ARRRE
		MOV 2CH,#0D0H
		INC 2DH			;時		十位數+1	
ARRRE: 	RET
		; button enent end
		
		;----alarmcheck
ALARM:	MOV A,25H
		CJNE A,2DH,LL
		MOV A,24H
		CJNE A,2CH,LL
		MOV A,23H
		CJNE A,2BH,LL
		MOV A,22H
		CJNE A,2AH,LL
		SETB 72H
		RET
LL:		CLR 72H
		RET		


MUSIC:         	MOV  DPTR,#TONE
                DEC    DPL
NEXT:    		MOV A,1CH
				RR A
				MOV 1CH,A
				JB 72H,NEXT2
				LJMP MESSA
NEXT2:			INC        DPTR
                MOV      A,#0  
                MOVC   A,@A+DPTR  ;A is the tone
                JZ            MUSIC              ;end of song
               ;listen alarm button
			   ACALL ALISTEN
			   ;generate a time delay between tone
NEXT3:		   MOV      R6, #200
               ACALL   DELAY
                ;check the tone
                CJNE      A, #1,N2          ;Do 262Hz
                MOV      R6, #116     
                MOV      R5,#52  
                ;check the mulitple number of 1/4 sec
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L1:          MOV        R4,A
IL1:         ACALL   OUTPUT
                DJNZ      R4, IL1
                DJNZ      R5, L1
                LJMP     NEXT

N2:          CJNE      A,#2,N3         
                MOV      R6, #103   
                MOV      R5,#74    
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L2:          MOV        R4,A
IL2:         ACALL   OUTPUT
                DJNZ      R4, IL2
                DJNZ      R5, L2
                LJMP     NEXT

N3:          CJNE       A,#3,N4   
                MOV      R6, #92       
                MOV      R5,#82
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L3:          MOV        R4,A
IL3:         ACALL   OUTPUT
                DJNZ      R4, IL3
                DJNZ      R5, L3
                LJMP     NEXT
N4:          CJNE       A,#4,N5   
                MOV      R6, #87       
                MOV      R5,#88
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L4:          MOV        R4,A
IL4:         ACALL   OUTPUT
                DJNZ      R4, IL4
                DJNZ      R5, L4
                LJMP     NEXT
N5:          CJNE       A,#5,N6  
                MOV      R6, #77       
                MOV      R5,#98
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L5:          MOV        R4,A
IL5:         ACALL   OUTPUT
                DJNZ      R4, IL5
                DJNZ      R5, L5
                LJMP     NEXT
N6:          CJNE       A,#6,N7   
                MOV      R6, #68      
                MOV      R5,#110
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L6:          MOV        R4,A
IL6:         ACALL   OUTPUT
                DJNZ      R4, IL6
                DJNZ      R5, L6
                LJMP     NEXT
N7:          CJNE       A,#7,N8
                MOV      R6, #61       
                MOV      R5,#124
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L7:          MOV        R4,A
IL7:         ACALL   OUTPUT
                DJNZ      R4, IL7
                DJNZ      R5, L7
                LJMP     NEXT
N8:          CJNE       A,#8,N9
                MOV      R6, #58       
                MOV      R5,#130
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L8:          MOV        R4,A
IL8:         ACALL   OUTPUT
                DJNZ      R4, IL8	
                DJNZ      R5, L8
                LJMP     NEXT
N9:          CJNE       A,#9,N10
                MOV      R6, #51       
                MOV      R5,#146
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L9:          MOV        R4,A
IL9:         ACALL   OUTPUT
                DJNZ      R4, IL9	
                DJNZ      R5, L9
                LJMP     NEXT
N10:          CJNE       A,#10,N11
                MOV      R6, #46       
                MOV      R5,#164
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L10:          MOV        R4,A
IL10:         ACALL   OUTPUT
                DJNZ      R4, IL10	
                DJNZ      R5, L10
                LJMP     NEXT
N11:          CJNE       A,#11,N12
                MOV      R6, #43       
                MOV      R5,#172
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L11:          MOV        R4,A
IL11:         ACALL   OUTPUT
                DJNZ      R4, IL11	
                DJNZ      R5, L11
                LJMP     NEXT
N12:          CJNE       A,#12,N13
                MOV      R6, #38       
                MOV      R5,#196
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L12:          MOV        R4,A
IL12:         ACALL   OUTPUT
                DJNZ      R4, IL12	
                DJNZ      R5, L12
                LJMP     NEXT
N13:          CJNE       A,#13,N14
                MOV      R6, #34       
                MOV      R5,#220
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L13:          MOV        R4,A
IL13:         ACALL   OUTPUT
                DJNZ      R4, IL13	
                DJNZ      R5, L13
                LJMP     NEXT



N14:          CJNE       A,#14,DEFAULT
                MOV      R6, #46       
                MOV      R5,#164
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
L14:          MOV        R4,A
IL14:         ACALL   OUTPUT2
                DJNZ      R4, IL14	
                DJNZ      R5, L14
                LJMP     NEXT









DEFAULT:
                MOV      R6, #200    
                MOV      R5,#40  
                INC         DPTR    
                MOV      A,#0
                MOVC    A,@A+DPTR   ;A is the number of minim
LD:          MOV        R4,A
ILD:         ACALL   OUTPUT
                DJNZ      R4, ILD
                DJNZ      R5, LD
                LJMP     NEXT
;Play the music
OUTPUT:   SETB    P3.6     
                   ACALL DELAY   
                   CLR       P3.6       
                   ACALL DELAY  
                   RET   
OUTPUT2:       
                     
                   CLR       P3.6       
                   ACALL DELAY 
	       ACALL DELAY  
                   RET 
; generate a time delay        
DELAY:   PUSH 6             
AA2:        MOV  R7, #6     
AA1:        DJNZ  R7, AA1  
                DJNZ  R6, AA2  
                POP    6             
                RET   


TONE:   DB 5,3,5,1,6,2,8,2,9,2,8,1,9,1,10,4,12,3,10,1,10,1,9,1,8,2,9,5,14,3,10,3,12,1,12,2,10,1,12,1,8,3,9,1,9,4,5,3,10
DB 1,10,2,9,1,8,1,8,5,14,3,9,3,9,1,10,2,9,1,8,1,6,2,5,1,6,1,8,4,6,3,8,1,9,1,8,1,10,2,12,5,14,3,12,3,12,1,13,2,12,1,10,1,10,2,9,1,8,1,6,4,5,3,10,1,10,2,9,1,8,1,8,5,14,3,0
LEDSG:	DB 11001100B, 10100101B, 10111101B, 01111110B, 11010100B, 11000011B, 11011011B, 00000000B, 00011000B, 00111100B, 01111110B, 11111111B, 01000010B, 01011010B, 01111110B
DB  01100110B, 00100100B, 11100111B, 10100111B, 11100101B, 10100101B, 0DBH, 10000001B, 01010111B


	END
