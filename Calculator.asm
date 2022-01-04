
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h         

jmp start                                              ;0ah is equal to \n for new line   = 10 in decimal
                                                       ;0dh is carriage return            = 13 in decimal
                              
operationMsg: db 0dh,0ah, "Choose your operation" ,0dh,0ah,"1- Addition" ,0dh,0ah,"2- Subtraction" ,0dh,0ah,"3- Multiplication" ,0dh,0ah,"4- Division" ,0dh,0ah,"$"
firstNumberMsg: db 0dh,0ah, "Enter the first number: ", "$"
secondNumberMsg: db 0dh,0ah, "Enter the second number: ", "$"
errorMsg: db 0dh,0ah, "Not valid number, press any key to restart $"   ; if we removed the dollar sign ($) it will print the next message. it makes the console stops instead of it
resultMsg: db 0dh,0ah, "The result is: $"
SubNegativeMessage: db      0dh,0ah,"Result : -$"
reminderMsg: db 0dh,0ah, "The reminder is: $" ,0dh,0ah



start: mov ah,9
       mov dx,offset operationMsg
       int 21h                                           ; call the interrupt handler 0x21 which is the DOS Function dispatcher. ; we must enter 9 in ah as a function code then it will check the content in dx then display it
       mov ah,0                                          ; we must enter the code of function then we can use the int 16h 
       int 16h                                           ; like cin or scanf. it will check the function code in ah then it will return the ascii character of the pressed button
       cmp al,31h                                        ; 1 in ascii  (Addition) 
       je Addition
       cmp al, 32h
       je Subtraction 
       cmp al, 33h
       je Multiplication
       cmp al,34h
       je Division
       mov ah,9      
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
            cmp si,1
            je  negativetwo
            cmp di,1
            je negativeone
            jmp normal
             


negativeone:cmp bx,dx
            jl onelistwo
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
                   


InputNumber:    mov ah,0             ;Store input in al so clear ah
                int 16h              ;Inturrept cpu to get input from keyboard
                mov dx,0             ;The previous digit that shall be added (eg: 12 ==> 1*100(bx) + 2(dx)) 
                mov bx,1             ;the weight of the digit (initially 1)         
                cmp al,0dh           ;Compare al to 0dh which represents 'Enter' key to assert that numebr is entered
                je GatheringDigits   ;Concatenate the digits of the input number
                sub ax,30h           ;Convert the value stored in al from Ascii to decimal
                call ViewNumber      ;Displays the input number
                mov ah,0        
                push ax
                inc cx              ;Increment the number of digits of the input number  
                jmp InputNumber     ;Taking a new number from the user 
        
;multiply each digit to its weight and adding to the previous number 
     
GatheringDigits:pop ax          ;Load the last input digit to register ax (Least significant digit)
                push dx 
                mul bx 
                pop dx         
                add dx,ax
                mov ax,bx
                mov bx,10   
                push dx
                mul bx       
                pop dx
                mov bx,ax
                dec cx          ;Decrement the count of digits
                cmp cx,0        ;Last digit is reached   
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
                
                                           
;function to view one digit                                                          
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
        mov ah, 09h     
        mov dx,offset operationMsg
        int 21h  
        mov ah, 0
        int 16h
        call start  ;return to menu to select a new operation




Subtraction:mov ah,09h
            mov dx, offset firstNumberMsg
            int 21h
            mov cx,0
            call InputNumber
            push dx
            mov ah,9
            mov dx, offset secondNumberMsg
            int 21h 
            mov cx,0
            call InputNumber
            pop bx
            mov ax,dx
            cmp bx,ax
            jl  Liss
            sub bx,ax
            mov dx,bx
            push dx
            mov ah,9
            mov dx, offset resultMsg
            jmp complet
              
Liss:       sub ax,bx
            mov dx,ax
            push dx
            mov ah,9
            mov dx, offset SubNegativeMessage

complet:    int 21h
            mov cx,10000
            pop dx
            call View 
            jmp exit   



Multiplication: mov ah,09h
                mov dx, offset firstNumberMsg             
                int 21h 
                mov cx,0
                call InputNumber
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
                mov dx, offset resultMsg
                int 21h
                mov cx,10000
                pop dx
                call View 
                jmp exit              



Division:   mov ah,9
            mov dx,offset firstNumberMsg   
            int 21h
            mov cx,0
            call InputNumber
            push dx
              
            mov ah,9
            mov dx,offset secondNumberMsg   
            int 21h
            mov cx,0
            call InputNumber 
            
            mov bx,dx
            mov dx,0
            pop ax
            div bx
            push dx
            mov dx,ax
            push dx
            mov ah,9
            mov dx,offset resultMsg   
            int 21h
            pop dx
            mov cx,10000
            call View 
            pop dx
            mov cx,10000
            mov bx,dx
            
            mov ah,9
            mov dx,offset reminderMsg
            int 21h
            
            mov dx,bx
            call View 
            jmp exit 
    ret
    
    
