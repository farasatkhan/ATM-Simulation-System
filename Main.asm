Include Irvine32.inc

.data
cardNumberString	BYTE "Enter your Card: ", 0
invalidCardNumberString	BYTE "Invalid Card Number. Kindly Enter Again", 0ah, 0dh, 0
validCardNumberString	BYTE "The Card is Valid", 0ah, 0dh, 0

pinNumberString		BYTE "Enter PIN Number: ", 0
invalidPINNumberString	BYTE "Invalid PIN Number. Kindly Enter Again", 0ah, 0dh, 0
validPINumberString	BYTE "The PIN Number is Valid", 0ah, 0dh, 0

transferAccountString	BYTE "Enter Account Number: ", 0

homepageWelcomeString	BYTE "Welcome to Home Page, ", 0
welcomeString		BYTE "Welcome, ", 0

depositAmountString	BYTE "1. Deposit Money", 0ah, 0dh, 0
withdrawAmountString	BYTE "2. Withdraw Money", 0ah, 0dh, 0
transferAmountString	BYTE "3. Transfer Money", 0ah, 0dh, 0
checkBalanceString		BYTE "4. Check Balance", 0ah, 0dh, 0
exitHomePageString		BYTE "5. Exit", 0ah, 0dh, 0

pickOptionString		BYTE "Pick One of the Option: ", 0
invalidPickOptionString	BYTE "Invalid Number is Entered. Try Again!", 0dh, 0ah, 0

currentBalanceString	BYTE "Current Account Balance is: ", 0
newBalanceString	BYTE "New Account Balance is: ", 0

enterDepositAmountString	BYTE "Deposit Amount: ", 0
invalidAmountDepsoitString	BYTE "Invalid Deposit Amount.", 0dh, 0ah, 0

enterWithdrawAmountString	BYTE "Withdraw Amount: ", 0
invalidAmountWithdrawString	BYTE "Invalid Withdraw Amount.", 0dh, 0ah, 0

cardNumber		BYTE 17 DUP(0)
accountPINNumber	BYTE 5 DUP(0)

transferAccountNumber	BYTE 17 DUP(0)

masterCardInfoString	BYTE "Master Card is Detected...", 0ah, 0dh, 0
visaCardInfoString		BYTE "Visa Card is Detected...", 0ah, 0dh, 0
americanExpressInfoString	BYTE "American Express Card is Detected...", 0ah, 0dh, 0

accountNumbers	DWORD	OFFSET userAccount_1, OFFSET userAccount_2

accountPINS		DWORD	OFFSET userAccountPIN_1, OFFSET userAccountPIN_2

accountHolders	DWORD	OFFSET userAccountHolder_1, OFFSET userAccountHolder_2

accountHoldersBalance	DWORD	OFFSET userAccountHolderBalance_1, OFFSET userAccountHolderBalance_2

userAccount_1	BYTE "3714496353984310", 0
userAccount_2	BYTE "5555555555554420", 0

userAccountPIN_1	BYTE "2345", 0
userAccountPIN_2	BYTE "3456", 0

userAccountHolder_1		BYTE "Farasat Khan", 0dh, 0ah, 0
userAccountHolder_2		BYTE "Junaid Ali", 0dh, 0ah, 0

userAccountHolderBalance_1	DWORD 75000
userAccountHolderBalance_2	DWORD 23000

currentOpenedAccountID	DWORD ?
transferAccountID	DWORD ?

EXIT_FLAG	BYTE  0

sameAccountString			BYTE "Same Account, Cant transfer.", 0dh, 0ah, 0
enterTransferAmountString	BYTE "Transfer Amount: ", 0
invalidAmountTransferString	BYTE "Invalid Transfer Amount.", 0

changeAccountString			BYTE "Do you want to Enter New Credit Card (0: No, 1: Yes): ", 0
changeAccountOption			DWORD 0
invalidChangeAccountString	BYTE "Invalid Change Account Option. Try again!", 0dh, 0ah, 0

.code
HomeMenu PROC
	home:
	mov EXIT_FLAG, 0
	; Prints: Welcome to Home Page, Farasat Khan
	mov edx, OFFSET homepageWelcomeString
	call WriteString
	mov ebx, currentOpenedAccountID
	mov edx, DWORD PTR [accountHolders + ebx * 4]		; Personalized Message with Account Holder Name
	call WriteString
	call Crlf

	; Prints: Current Balance is: <Amount>				; Print the Current Balance
	mov edx, OFFSET currentBalanceString
	call WriteString

	mov esi, DWORD PTR [accountHoldersBalance + ebx * 4]
	mov eax, DWORD PTR [esi]
	call WriteDec
	call Crlf
	call Crlf

	mov edx, OFFSET depositAmountString					; Print Options to User such as Deposit, Withdraw, Tranfser, Check Balance and Exit
	call WriteString

	mov edx, OFFSET withdrawAmountString
	call WriteString

	mov edx, OFFSET transferAmountString
	call WriteString

	mov edx, OFFSET checkBalanceString
	call WriteString

	mov edx, OFFSET exitHomePageString
	call WriteString
	call Crlf

	enterOption:										; Pick one of the above option
		mov edx, OFFSET pickOptionString
		call WriteString

		call ReadDec
		jnc isValidInputOption
		mov edx, OFFSET invalidPickOptionString
		call WriteString
		jmp enterOption

	isValidInputOption:									; Check if the number entered is between 1 and 5
		cmp eax, 1
		jl	enterOption
		cmp eax, 5
		jg	enterOption

		cmp eax, 1
		je	DepositAmountAction
		cmp eax, 2
		je WithdrawAmountAction
		cmp eax, 3
		je TransferAmountAction
		cmp eax, 4
		je CheckBalanceAmountAction
		cmp eax, 5
		je ExitAction
	exit_proc:
		ret
HomeMenu ENDP

DepositAmountAction	PROC
	enterDepositAmount:
	mov edx, OFFSET enterDepositAmountString
	call WriteString

	call ReadDec
	jnc isValidAmountDeposit
	mov edx, OFFSET invalidAmountDepsoitString
	call WriteString
	jmp enterDepositAmount

	isValidAmountDeposit:
		cmp eax, 0
		jl	enterDepositAmount
		add [esi], eax
	
	mov edx, OFFSET newBalanceString
	call WriteString

	mov esi, DWORD PTR [accountHoldersBalance + ebx * 4]
	mov eax, DWORD PTR [esi]
	call WriteDec
	call Crlf

	ret
DepositAmountAction ENDP

WithdrawAmountAction PROC
	mov esi, DWORD PTR [accountHoldersBalance + ebx * 4]
	mov eax, DWORD PTR [esi]
	call WriteDec
	call Crlf

	enterDepositAmount:
	mov edx, OFFSET enterWithdrawAmountString
	call WriteString

	call ReadDec
	jnc isValidAmountWithdraw
	mov edx, OFFSET invalidAmountWithdrawString
	call WriteString
	jmp enterDepositAmount

	isValidAmountWithdraw:
		cmp eax, 0
		jl	enterDepositAmount
		cmp [esi], eax
		jl	enterDepositAmount
		sub [esi], eax
	
	mov edx, OFFSET newBalanceString
	call WriteString

	mov esi, DWORD PTR [accountHoldersBalance + ebx * 4]
	mov eax, DWORD PTR [esi]
	call WriteDec
	call Crlf

	ret
WithdrawAmountAction ENDP

TransferAmountAction PROC
	insertCard:
	; Enter the Account to Transfer Amount To
	mov edx, OFFSET transferAccountString
	call WriteString

	; Take 16 digit Card Number from the user
	mov edx, OFFSET transferAccountNumber
	mov ecx, (LENGTHOF transferAccountNumber)
	call ReadString

	mov ecx, (LENGTHOF accountNumbers)
	mov ebx, 0
	mov edx, 0
	printAccounts:
		mov esi, DWORD PTR [accountNumbers + ebx*4]
		printIndividualAccount:
			mov al, BYTE PTR [esi + edx]
			sub al, 48
			mov ah, transferAccountNumber[edx]
			sub ah, 48
			cmp al, ah
			jne goNextLoop
			inc edx
			cmp edx, 16
			jne printIndividualAccount
			jmp transferAmount
		goNextLoop:
		inc ebx
		cmp ebx, ecx
		jne printAccounts
		mov edx, OFFSET invalidCardNumberString
		call WriteString
		jmp insertCard
	transferAmount:
		mov transferAccountID, ebx
		cmp currentOpenedAccountID, ebx
		jne transferBalance
		mov edx, OFFSET sameAccountString
		call WriteString
		jmp quit_transfer

	transferBalance:
		enterTransferAmount:
			mov edx, OFFSET enterTransferAmountString	
			call WriteString

			call ReadDec
			jnc isValidAmountTransfer
			mov edx, OFFSET invalidAmountTransferString	
			call WriteString
			jmp enterTransferAmount

		isValidAmountTransfer:
			cmp eax, 0
			jl	enterTransferAmount

			mov ebx, currentOpenedAccountID
			mov esi, DWORD PTR [accountHoldersBalance + ebx * 4]
			
			cmp [esi], eax
			jl	enterTransferAmount

			sub [esi], eax

			mov ebx, transferAccountID
			mov esi, DWORD PTR [accountHoldersBalance + ebx * 4]
			add [esi], eax

	quit_transfer:
	ret
TransferAmountAction ENDP

CheckBalanceAmountAction PROC
	; Account Holder Name:
	mov edx, OFFSET welcomeString
	call WriteString

	mov edx, DWORD PTR [accountHolders + ebx * 4]		; Personalized Message with Account Holder Name
	call WriteString
	call Crlf

	; Prints: Current Balance is: <Amount>				; Print the Current Balance
	mov edx, OFFSET currentBalanceString
	call WriteString

	mov esi, DWORD PTR [accountHoldersBalance + ebx * 4]
	mov eax, DWORD PTR [esi]
	call WriteDec
	call Crlf
	ret
CheckBalanceAmountAction ENDP

ExitAction	PROC
	mov EXIT_FLAG, 1
	ret
ExitAction	ENDP

main PROC
	
	insertCard:
	; Enter your Card
	mov edx, OFFSET cardNumberString
	call WriteString

	; Take 16 digit Card Number from the user
	mov edx, OFFSET cardNumber
	mov ecx, (LENGTHOF cardNumber)
	call ReadString
	
	mov eax, 0
	mov al, cardNumber
	sub al, 48

	; Mastercard numbers start with a 2 or 5.
	masterCard:
		cmp al, 2
		je masterCardPrintInformation
		cmp al, 5
		jne visaCard
		masterCardPrintInformation:
		mov edx, OFFSET masterCardInfoString
		call WriteString
		jmp isValidCard

	; Visa card numbers start with a 4.
	visaCard:
		cmp al, 4
		jne americanExpress
		mov edx, OFFSET visaCardInfoString
		call WriteString
		jmp isValidCard

	; American Express numbers start with a 3.
	americanExpress:
		cmp al, 3
		jne invalidCardDetails
		mov edx, OFFSET americanExpressInfoString
		call WriteString
		jmp isValidCard
	
	; If card is neither mastercard, visa, or american express we ask the user to enter card again
	invalidCardDetails:
		mov edx, OFFSET invalidCardNumberString
		call WriteString
		mov eax, 3000		; Wait for 3 seconds and then Clear the Screen
		call Delay
		call Clrscr
		jmp insertCard

	; Add All the Digits in the "cardNumber" and divide by 10. If it is divisible then the card is valid
	isValidCard:
		mov eax, 0
		mov ecx, (LENGTHOF cardNumber - 1)
		mov ebx, 0
		mov edx, 0
		cardDivisibleTenValidity:
			mov dl, cardNumber[ebx]
			sub dl, 48
			cmp dl, 0						; Card Number should be between 0 and 9. It is used to detect non-digit characters.
			jl invalidCardDetails
			cmp dl, 9
			jg invalidCardDetails
			movsx edx, dl
			add eax, edx
			inc ebx
			cmp ebx, ecx
			jne cardDivisibleTenValidity
		mov edx, 0							; 1. Check if the sum in eax is divisible by 10, only then go to step 2
		mov cx, 10							
		div cx								
		cmp edx, 0
		jne invalidCardDetails				; 2. Jmp to CHECK IF USER ACCOUNT IS PRESENT BY COMPARING IT WITH "accountNumbers"
		mov ecx, (LENGTHOF accountNumbers)
		mov ebx, 0
		mov edx, 0
		printAccounts:
			mov esi, DWORD PTR [accountNumbers + ebx*4]
			printIndividualAccount:
				mov al, BYTE PTR [esi + edx]
				sub al, 48
				mov ah, cardNumber[edx]
				sub ah, 48
				cmp al, ah
				jne goNextLoop
				inc edx
				cmp edx, 16
				jne printIndividualAccount
				jmp isPINValid
			goNextLoop:
			inc ebx
			cmp ebx, ecx
			jne printAccounts
		mov edx, OFFSET validCardNumberString
		call WriteString
		mov eax, 3000							; Wait for 3 seconds and then Clear the Screen
		call Delay
		call Clrscr
		;jmp isPINValid						; 3. If true then go to isPINValid (I've applied a shortcut right now)			
										

	isPINValid:
		; Enter PIN Number
		mov edx, OFFSET pinNumberString
		call WriteString

		; Take 4 digit PIN Number from the user
		mov edx, OFFSET accountPINNumber
		mov ecx, (LENGTHOF accountPINNumber)
		call ReadString

		mov eax, 0						; Write a loop which compares if PIN belong to the particular account
		mov edx, 0						; In our case we would take the index from the accountNumber (mentioned in the above step)

		checkPins:
			mov esi, DWORD PTR [accountPINS + ebx*4]	; EBX contains the index of the account thus we can directly use it to locate the PIN
			checkIndividualPin:
				mov al, BYTE PTR [esi + edx]
				sub al, 48
				mov ah, accountPINNumber[edx]
				sub ah, 48
				cmp al, ah
				jne invalidAccountPin
				inc edx
				cmp edx, 4
				jne checkIndividualPin
				mov currentOpenedAccountID, ebx			; Current Opened Account Index to easily locate the account id
				mov edx, OFFSET validPINumberString
				call WriteString
				mov eax, 3000
				call Delay
				call Clrscr
				homePage:
					call HomeMenu										; CALL HomeMenu PROCEDURE
					mov eax, 5000
					call Delay
					call Clrscr
					cmp EXIT_FLAG, 1
					jne homePage
					changeAccount:
						mov edx, OFFSET changeAccountString
						call WriteString
						call ReadDec
						jnc validChangeAccountInput
						mov edx, OFFSET invalidChangeAccountString
						call WriteString
						jmp changeAccount
					validChangeAccountInput:
						cmp eax, 0
						jne insertCard
					jmp quit_program
			invalidAccountPin:
			mov edx, OFFSET invalidPINNumberString
			call WriteString
			mov eax, 3000							; Wait for 3 seconds and then Clear the Screen
			call Delay
			call Clrscr
			jmp isPINValid
	quit_program:
	exit
main ENDP
END main