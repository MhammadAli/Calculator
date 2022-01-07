                        
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h         

jmp start                                              ;0ah is equal to \n for new line   = 10 in decimal
                                                       ;0dh is carriage return            = 13 in decimal

                                                       
num dw ?                                                ; this variable is for hold the result of the square to multibly to ax to get the cube of number         
operationMsg: db 0dh,0ah, "Choose your operation" ,0dh,0ah,"1- Addition" ,0dh,0ah,"2- Subtraction" ,0dh,0ah,"3- Multiplication" ,0dh,0ah,"4- Division" ,0dh,0ah,"5- Square of Number" ,0dh,0ah, "6- Cube of Number" ,0dh,0ah,"7- Square Root",0dh,0ah,"8- Cubic Root",0dh,0ah, "$"
firstNumberMsg: db 0dh,0ah, "Enter the first number: ", "$" 


secondNumberMsg: db 0dh,0ah, "Enter the second number: ", "$"
rootNumberMsg: db 0dh,0ah, "Enter the number: ", "$"
errorMsg: db 0dh,0ah, "Not valid number, press any key to restart $"   ; if we removed the dollar sign ($) it will print the next message. it makes the console stops instead of it
resultMsg: db 0dh,0ah, "The result is: $"
SubNegativeMessage: db      0dh,0ah,"The Result is : -$"
AppSubNegativeMessage: db      0dh,0ah,"The Approximated result is: -$"
reminderMsg: db 0dh,0ah, "The reminder is: $" ,0dh,0ah
ApproxMsg: db 0dh,0ah, "The Approximated result is: $" ,0dh,0ah
jApproMsg: db 0dh,0ah, "The Approximated result is: J $" ,0dh,0ah
jMsg: db 0dh,0ah, "The result is: J $" ,0dh,0ah 

Error2: db 0dh,0ah, "Logic Error $" ,0dh,0ah
;This part is for the square and cube of a Number  

SqrcbNumMsg: db 0dh,0ah, "Enter the number: ", "$"  

resultSqrcb: db 0dh,0ah, "The result is: $"
negativeReminderMsg: db 0dh,0ah, "The reminder is: -$" ,0dh,0ah



start: mov si,0
       mov di,0
       mov ah,9
       mov dx,offset operationMsg
       int 21h              
       mov cx,0
       call inputNumber
       cmp si,1
       je  e
       mov al,dl
       add al,30h                                        
       cmp al,31h                                        ; 1 in ascii  (Addition) 
       je Addition
       cmp al, 32h
       je Subtraction 
       cmp al, 33h
       je Multiplication
       cmp al,34h
       je Division
       cmp al,35h
       je sqrNum
       cmp al,36h
       je cubeNum
       cmp al,37h
       je SquareRoot
       cmp al,38h
       je CubicRoot  
      
e:     mov ah,9      
       mov dx,offset errorMsg
       int 21h   
       mov ah,0
       int 16h
       jmp start     
                                                                                
       
       
       
Addition:   mov ah,09h ;
            mov dx, offset firstNumberMsg    ;Prompt asking user to enter the first number  
            int 21h                          ;Inturrept cpu to get input from keyboard   
            mov cx,0                         ;Holds the number of digits of the input number 
            call InputNumber                 ;Handling input number as each number will be taken seprately 
            mov di,si                        ;di sign of first si secound  
            mov si,0
            push dx 
            mov ah,9
            mov dx, offset secondNumberMsg   ;Prompt asking user to enter the second number 
            int 21h
            mov cx,0                         ;reset the digit counter to be prepared to deal with the second number
            call InputNumber
            pop bx                             ;Recieve the value of the first number 
subb:       cmp si,1
            je  negativetwo
            cmp di,1
            je negativeone
            jmp normal
             


negativeone:cmp bx,dx           ; the first number is negative  and the second is positive
            jl onelesstwo
            sub bx,dx
            mov dx,bx
            push dx                          ;push the addition result to the stack
            mov ah,9
            mov dx,offset SubNegativeMessage          ;Display the addition result
            int 21h
            mov cx,10000                     ;Setting the max number of digits that an input can be contained 
            pop dx                           
            call View                       
            jmp exit


onelesstwo:  sub dx,bx
            push dx                          ;push the addition result to the stack
            mov ah,9
            mov dx,offset resultMsg          ;Display the addition result
            int 21h
            mov cx,10000                     ;Setting the max number of digits that an input can be contained 
            pop dx                           
            call View                       
            jmp exit
                   
negativetwo:cmp di,1            
            je res       ; the first is negative and the second is negative
            mov ax,dx    ; the first is positive and the second is negative
            cmp bx,dx
            jl  li
            sub bx,dx                        ;Addition performed and stored in dx register
            mov dx,bx
            push dx                          ;push the addition result to the stack
            mov ah,9
            mov dx,offset resultMsg          ;Display the addition result
            int 21h
            mov cx,10000                     ;Setting the max number of digits that an input can be contained 
            pop dx                           
            call View                       
            jmp exit
            
; the first number is less than the second number
li:         sub ax,bx
            mov dx,ax
            push dx
            mov ah,9
            mov dx, offset SubNegativeMessage
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit
            
 ; the first number is negative and the second is negative            
res:        add dx,bx                        ;Addition performed and stored in dx register
            push dx                          ;push the addition result to the stack
            mov ah,9
            mov dx,offset SubNegativeMessage
            int 21h
            mov cx,10000                     ;Setting the max number of digits that an input can be contained 
            pop dx                           
            call View                       
            jmp exit

normal:    add dx,bx                        ;Addition performed and stored in dx register
            push dx                          ;push the addition result to the stack
            mov ah,9
            mov dx,offset resultMsg          ;Display the addition result
            int 21h
            mov cx,10000                     ;Setting the max number of digits that an input can be contained 
            pop dx                           
            call View                       
            jmp exit                    

InputNumber:    mov ah,0             ;Store input in al so clear ah
                int 16h              ;Inturrept cpu to get input from keyboard
                mov dx,0             ;The previous digit that shall be added (eg: 12 ==> 1*100(bx) + 2(dx)) 
                mov bx,1             ;the weight of the digit (initially 1)
                cmp al,08h           ; asci code of back space
                je backSpace                      
continue:       cmp al,0dh           ;Compare al to 0dh which represents 'Enter' key to assert that numebr is entered
                je GatheringDigits   ;Concatenate the digits of the input number
                sub ax,30h           ;Convert the value stored in al from Ascii to decimal
                call ViewNumber      ;Displays the input number
                mov ah,0        
                push ax
                inc cx              ;Increment the number of digits of the input number  
                jmp InputNumber     ;Taking a new number from the user 
        
                                                   
                                        
                                                             
backSpace:      mov ah,02h                              
                mov dl,08h             ; Another backspace character to move cursor back again
                int 21h 
                mov dl,20h             ; A space to clear old character
                int 21h   
                mov dl,08h             ; Another backspace character to move cursor back again
                int 21h  
                dec cx                 ; to decrease the number of digits
                pop ax                 ; to delete the old number from stack 
                jmp inputNumber 
 
 
;multiply each digit to its weight and adding to the previous number     
GatheringDigits:cmp cx,1
                je one
                pop ax          
                
 notnegative:   push dx 
                mul bx 
                pop dx                      
                add dx,ax
                mov ax,bx                      
                mov bx,10   
                push dx                                                         
                mul bx                                                          
                pop dx                                                         
                mov bx,ax
                jmp decre 
                
; check the last digit if it - or a number
 one:          pop ax
               cmp ax,0fdH      ; ascii for -
               jne notnegative
               mov si,1
  
  
 decre:         dec cx    
                cmp cx,0           
                jne GatheringDigits
                ret

;function to view the whole number
ViewNumber:     push ax         ;push the entered number to the stack
                push dx         
                mov dx,ax       ;the output number is stored in dx 
                add dl,30h      ;convert the input number to ascii so it can be displayed
                mov ah,2
                int 21h         
                pop dx          ;pop register's values back from the stack              
                pop ax                                                                              
                ret  
                
                                           
;function to view one digit       4                                                   
View:  mov ax,dx
       mov dx,0
       div cx 
       call ViewNumber
       mov bx,dx 
       mov dx,0
       mov ax,cx 
       mov cx,10
       div cx
       mov dx,bx 
       mov cx,ax
       cmp ax,0
       jne View
       ret
       

exit:   
       ; mov ah, 09h     
        ;mov dx,offset operationMsg
        ;int 21h  
        mov ah, 0
        int 16h
        call start  ;return to menu to select a new operation




Subtraction:mov ah,09h
            mov dx, offset firstNumberMsg
            int 21h
            mov cx,0
            call InputNumber
            mov di,si                        ;di sign of first si secound  
            mov si,0
            push dx
            mov ah,9
            mov dx, offset secondNumberMsg
            int 21h 
            mov cx,0
            call InputNumber
            pop bx 
            xor si,1
            jmp subb  



Multiplication: mov ah,09h
                mov dx, offset firstNumberMsg             
                int 21h 
                mov cx,0
                call InputNumber
                mov di,si                        ;di sign of first si secound  
                mov si,0
                push dx     
                mov ah,9
                mov dx, offset secondNumberMsg
                int 21h
                mov cx,0
                call InputNumber
                pop bx
                mov ax,dx
                
                
                mul bx 
                mov dx,ax
                push dx 
                mov ah,9 
                xor di,si
                cmp di,1
                je mullneg 
                mov dx, offset resultMsg
                jmp comp1  
                
                
 mullneg:      mov dx,offset SubNegativeMessage
 
 
 comp1:         int 21h
                mov cx,10000
                pop dx
                call View 
                jmp exit



sqrNum:         
                mov ah,09h
                mov dx, offset SqrcbNumMsg
                int 21h 
                mov cx,0
                call InputNumber
                push dx     
                pop bx
                mov ax,dx
                mov bl , al
                mul bx 
                mov dx,ax
                push dx 
                mov ah,9
                mov dx, offset resultSqrcb
                int 21h
                mov cx,10000
                pop dx
                call View 
                jmp exit  

cubeNum:         
                mov ah,09h
                mov dx, offset SqrcbNumMsg
                int 21h 
                mov cx,0
                call InputNumber
                push dx     
                pop bx
                mov ax,dx
                mov bl , al
                mul bx
                mov num,bx
                mul num 
                mov dx,ax
                push dx 
                mov ah,9
                cmp si,1
                je cubneg
                mov dx,offset resultSqrcb
                jmp cubpos
                
cubneg:         mov dx, offset SubNegativeMessage
                
                
                
                
 cubpos:        int 21h
                mov cx,10000
                pop dx
                call View 
                jmp exit
                                      
Error:    
            mov ah,9
            mov dx,offset Error2  
            int 21h 
            call exit


Division:   mov ah,9
            mov dx,offset firstNumberMsg   
            int 21h
            mov cx,0
            call InputNumber
            mov di,si                        ;di sign of first , si secound  
            mov si,0
            push dx
              
            mov ah,9
            mov dx,offset secondNumberMsg   
            int 21h
            mov cx,0
            call InputNumber 
            
            mov bx,dx                        
            mov dx,0
            pop ax                           ;ax is the first number , bx is the second number
            
            cmp bx,0
            je  Error
            div bx      ; divide ax / bx
            push dx
            mov dx,ax
            push dx
            mov ah,9
            
            xor si,di
            cmp si,1
            je divvneg                       ;if negative we will print negative sign message
            mov dx,offset resultMsg
            jmp divpos


   divvneg: mov dx,offset SubNegativeMessage
            
    divpos: int 21h
            pop dx
            mov cx,10000
            call View                       
            pop dx               
            mov cx,10000
            mov bx,dx
            mov ah,9 
            cmp di,1
            je remneg
   rempos:  mov dx,offset reminderMsg      
            jmp continue1
   remneg:  mov dx,offset negativeReminderMsg  ;if first number is negative, print negative reminder
 
 continue1:  int 21h        
            mov dx,bx
            call View 
            jmp exit
            
             
root:       inc bx
            jmp  here                
     
big:        cmp si,1
            je  jAppr
            dec bx
            mov ah,9
            mov dx,offset ApproxMsg  
            int 21h 
            mov dx,bx 
            mov cx,10000
            call view
            call exit
            
big2:       cmp si,1
            je  minus
            dec bx
            mov ah,9
            mov dx,offset ApproxMsg  
            int 21h 
            mov dx,bx 
            mov cx,10000
            call view
            call exit


minus:      dec bx
            mov ah,9
            mov dx,offset AppSubNegativeMessage  
            int 21h 
            mov dx,bx 
            mov cx,10000
            call view
            call exit

                         
                
jAppr:      dec bx
            mov ah,9
            mov dx,offset jApproMsg  
            int 21h 
            mov dx,bx 
            mov cx,10000
            call view
            call exit
            
Jnormal:    mov ah,9
            mov dx,offset jMsg  
            int 21h 
            mov dx,bx 
            mov cx,10000
            call view
            call exit


cubeminus:   mov ah,9
            mov dx,offset SubNegativeMessage  
            int 21h 
            mov dx,bx 
            mov cx,10000
            call view
            call exit                                
            
SquareRoot: mov ah,9 ;2 print char  9 print
            mov dx,offset rootNumberMsg
            int 21h
            mov cx,0                         ;Holds the number of digits of the input number 
            call InputNumber
            
            mov bx,1
            mov cx,dx
  here:     mov ax,bx 
            mul bx 
            mov dx,ax
            cmp dx,cx
            jg  big
            jne root
            
            cmp si,1
            je  Jnormal 
            mov ah,9
            mov dx,offset resultMsg  
            int 21h 
            mov dx,bx 
            mov cx,10000
            call view
            call exit 
            
  cubic: inc bx
         jmp there          
            
            
CubicRoot: mov ah,9
           mov dx,offset rootNumberMsg
           int 21h
           mov cx,0
           call InputNumber
           mov bx,1
           mov cx,dx
 there:    mov ax,bx
           mul bx
           mul bx
           mov dx,ax
           cmp dx,cx
           jg  big2
           jne cubic
            
           
           cmp si,1
            je  cubeminus
           mov ah,9
            mov dx,offset resultMsg  
            int 21h 
            mov dx,bx 
            mov cx,10000
            call view
            call exit  




    ret
    
    
