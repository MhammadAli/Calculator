Addition:   mov ah,09h ;
            mov dx, offset firstNumberMsg    ;Prompt asking user to enter the first number  
            int 21h                          ;Inturrept cpu to get input from keyboard   
            mov cx,0                         ;Holds the number of digits of the input number 
            call InputNumber                 ;Handling input number as each number will be taken seprately
            push dx 
            mov ah,9
            mov dx, offset secondNumberMsg   ;Prompt asking user to enter the second number 
            int 21h
            mov cx,0                         ;reset the digit counter to be prepared to deal with the second number
            call InputNumber
            pop bx                           ;Recieve the value of the first number
            add dx,bx                        ;Addition performed and stored in dx register
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


ViewNumber:     push ax         ;push the entered number to the stack
                push dx         
                mov dx,ax       ;the output number is stored in dx 
                add dl,30h      ;convert the input number to ascii so it can be displayed
                mov ah,2
                int 21h         
                pop dx          ;pop register's values back from the stack              
                pop ax                                                                              
                ret                                                                             
                                                                                                      
        
               
            
            
            
            