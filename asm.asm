.386
.MODEL FLAT
.STACK 4096 

include	io.inc


ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA

	;========================================Input variables =======================================
	userArray		DWORD			10 DUP (?)


	;========================================String prompts=========================================
	strArrayValues1Promt 		BYTE 			"Please provide value number [", 0
	strArrayValues2Promt 		BYTE 			"] for the array: ", 0
	strClampValuePromt 			BYTE 			"Please provide a the clamp value", 10, 0
	strAskUserProcessAgainPromt BYTE 			"Do you want to process another set of values? 0 for yes 1 for no", 0

	strUserArray 			BYTE 			"Your Array is : ", 10, 0
	strClampValue 			BYTE 			"The Clamp Value is : ", 0
	strAverage 				BYTE 			"The Average is : ", 0
	strDivArray 			BYTE 			"The Divided Array is : ", 0
	strClampArray 			BYTE 			"The Clamped Array is : ", 0


	strNL 				BYTE 			" ", 10, 0
	strSpace 			BYTE 			" ", 0
	strOpenBringacket	BYTE 			"[", 0
	strClosingBracket 	BYTE 			"]", 0
	strComma			BYTE 			", ", 0
	

.CODE
	;INPUT FUNCTION WHERE USER INPUTS VALUES FOR ARRAY
	_inputFunc PROC NEAR32
		;BLOCK ENTRY
		PUSH ebp ; Save base pointer 
		MOV ebp, esp ; Set up stack frame
		PUSH edx ; save registers
		PUSH ecx
		PUSH ebx
		PUSH eax
		PUSHFD ; save the flags register

		; BLOCK Function body
		MOV ebx, 0 ; setting up ebx for array
		LEA edx, userArray ; loading userArray

		inputVariable:
			CMP ebx, 10 ; checking if the number of varibales has been reached
			JE exitLoop ; kimping to exit look if array has been filled

			INVOKE	OutputStr, ADDR strArrayValues1Promt ; asking user for array input
			INVOKE OutputInt, ebx
			INVOKE	OutputStr, ADDR strArrayValues2Promt ; asking user for array input
			INVOKE InputInt ; getting the int
			MOV [edx], eax ; storing value on array
			ADD edx, 4 ; adding 4 to edx
			ADD ebx, 1 ; decreasing counter
			JMP inputVariable ; going to start of input loop
		exitLoop:

		POPFD ; restore the flags register
		POP ebx
		POP ecx
		POP edx
		MOV esp, ebp ; destroy the stack frame
		POP ebp ; restore the base pointer
		RET  ; return to the calling function

	_inputFunc ENDP

	; DISPLAY FUNCTION
	_displayFunc PROC NEAR32
		;BLOCK ENTRY
		PUSH ebp ; Save base pointer 
		MOV ebp, esp ; Set up stack frame
		PUSH edx ; save registers
		PUSH ecx
		PUSH ebx
		PUSH eax
		PUSHFD ; save the flags register

		; BLOCK Function body
		MOV ebx, 0 ; setting up ebx for array
		LEA edx, userArray ; loading userArray
		INVOKE	OutputStr, ADDR strOpenBringacket ; calling square bracket opener
		outputVariable:
			CMP ebx, 10 ; checking if the number of varibales has been reached
			JE exitOutputLoop ; kimping to exit look if array has been filled

			INVOKE OutputInt, [edx]
			INVOKE	OutputStr, ADDR strComma ; adding a comma
			ADD edx, 4 ; adding 4 to edx
			ADD ebx, 1 ; decreasing counter
			JMP outputVariable ; going to start of input loop
		exitOutputLoop:
		INVOKE	OutputStr, ADDR strClosingBracket ; calling square bracket closer

		POPFD ; restore the flags register
		POP ebx
		POP ecx
		POP edx
		MOV esp, ebp ; destroy the stack frame
		POP ebp ; restore the base pointer
		RET  ; return to the calling function

	_displayFunc ENDP


	;AVERAGE FUNCTION
	_averageFunc PROC NEAR32
		;BLOCK ENTRY
		PUSH ebp ; Save base pointer 
		MOV ebp, esp ; Set up stack frame
		PUSH edx ; save registers
		PUSH ecx
		PUSH ebx
		PUSH eax
		PUSHFD ; save the flags register

		; BLOCK Function body
		MOV ebx, 0 ; setting up ebx for array
		MOV ecx, 0 ; setting start of ecx to 0
		LEA edx, userArray ; loading userArray
		averageLoop:
			CMP ebx, 10 ; checking if the number of varibales has been reached
			JE exitAverageLoop ; kimping to exit look if array has been filled
			ADD ecx, [edx] ; storing value on array
			ADD edx, 4 ; adding 4 to edx
			ADD ebx, 1 ; decreasing counter
			JMP averageLoop ; going to start of input loop
		exitAverageLoop:

		MOV eax, ecx ; storing ecx onto eax
		MOV ecx, 10
		CDQ
		DIV ecx ; dividing 10


		POPFD ; restore the flags register
		POP ebx
		POP ecx
		POP edx
		MOV esp, ebp ; destroy the stack frame
		POP ebp ; restore the base pointer
		RET  ; return to the calling function

	_averageFunc ENDP


	;FUNCTION TO CALCULATE AVERAGE OF AN ARRAY
	_divideFunc PROC NEAR32
		;BLOCK ENTRY
		PUSH ebp ; Save base pointer 
		MOV ebp, esp ; Set up stack frame
		PUSH edx ; save registers
		PUSH ecx
		PUSH ebx
		PUSH eax
		PUSHFD ; save the flags register

		MOV eax,[ebp + 8] ;get pointer value param1(i)
		MOV ecx, eax


		; BLOCK Function body
		MOV ebx, 0 ; setting up ebx for array
		INVOKE OutputStr, ADDR strDivArray
		INVOKE OutputStr, ADDR strOpenBringacket
		dividLoop:
			CMP ebx, 10 ; checking if the number of varibales has been reached
			JE exitDividLoop ; kimping to exit look if array has been filled

			MOV eax, [userArray+ebx*4] ; storing value on array\
			CDQ 
			IDIV ecx
			MOV [userArray+ebx*4],eax
			INVOKE OutputInt, eax
			INVOKE OutputStr, ADDR strComma

			ADD ebx, 1 ; increasing counter
			JMP dividLoop ; going to start of input loop
		exitDividLoop:

		INVOKE OutputStr, ADDR strClosingBracket


		POPFD ; restore the flags register
		POP ebx
		POP ecx
		POP edx
		MOV esp, ebp ; destroy the stack frame
		POP ebp ; restore the base pointer
		RET  ; return to the calling function

	_divideFunc ENDP


	;FUNCTION TO CLAMP ARRAY VALUES
	_clampFunc PROC NEAR32
			;BLOCK ENTRY
		PUSH ebp ; Save base pointer 
		MOV ebp, esp ; Set up stack frame
		PUSH edx ; save registers
		PUSH ecx
		PUSH ebx
		PUSH eax
		PUSHFD ; save the flags register

		MOV eax,[ebp + 8] ;get pointer value param1(i)
		MOV ecx, eax


		; BLOCK Function body
		MOV ebx, 0 ; setting up ebx for array
		INVOKE OutputStr, ADDR strClampArray
		INVOKE OutputStr, ADDR strOpenBringacket
		clampLoop:
			CMP ebx, 10 ; checking if the number of varibales has been reached
			JE exitclampLoop ; jumping to exit , look if array has been filled

			MOV eax, [userArray+ebx*4] ; storing value on array
			CMP eax, ecx
			JLE clamped
			INVOKE OutputInt, ecx
			INVOKE OutputStr, ADDR strComma

			clamped:
				INVOKE OutputInt, eax
				INVOKE OutputStr, ADDR strComma

			ADD ebx, 1 ; increasing counter
			JMP clampLoop ; going to start of input loop
		exitclampLoop:

		INVOKE OutputStr, ADDR strClosingBracket


		POPFD ; restore the flags register
		POP ebx
		POP ecx
		POP edx
		MOV esp, ebp ; destroy the stack frame
		POP ebp ; restore the base pointer
		RET  ; return to the calling function

	_clampFunc ENDP

_start:

	; GETTING THE INPUT FOR THE ARRAY
	CALL _inputFunc ; calling the input function
	INVOKE OutputStr, ADDR strUserArray


	; DISPLAYING THE OUTPUT OF THE ARRAY
	CALL _displayFunc ; calling the input function
	INVOKE OutputStr, ADDR strNL


	; GETTING THE AVERAGE
	INVOKE OutputStr, ADDR strAverage
	CALL _averageFunc ; calling average function
	MOV ebx, eax
	INVOKE OutputInt, eax ; displaying the average
	INVOKE OutputStr, ADDR strNL


	; GETTING THE DIVIDING ARRAY OUTPUT
	PUSH ebp ; save base pointer
	MOV ebp, esp ; create stack frame
	SUB esp, 4 ; create 1 local variabl
	PUSH ebx

	CALL _divideFunc ; calling the dividing function

	MOV esp, ebp ; destroy stack frame
	POP ebp ; restore base pointer


	; GETTING THE CALMMED ARRAY OUTPUT
	INVOKE OutputStr, ADDR strNL
	INVOKE OutputStr, ADDR strClampValuePromt
	INVOKE InputInt
	MOV ebx, eax
	INVOKE OutputStr, ADDR strClampValue
	INVOKE OutputInt, ebx
	INVOKE OutputStr, ADDR strNL

	PUSH ebp ; save base pointer
	MOV ebp, esp ; create stack frame
	SUB esp, 4 ; create 1 local variabl
	PUSH ebx

	CALL _clampFunc ; calling the clamming function

	MOV esp, ebp ; destroy stack frame
	POP ebp ; restore base pointer
	INVOKE OutputStr, ADDR strNL


	INVOKE OutputStr, ADDR strAskUserProcessAgainPromt
	INVOKE InputInt
	CMP eax, 0
	JE _start
	INVOKE OutputStr, ADDR strNL

	INVOKE ExitProcess, 0
Public _start
END
