
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h         

jmp start                                              ;0ah is equal to \n for new line   = 10 in decimal
                                                       ;0dh is carriage return            = 13 in decimal
                              

operationMsg: db 0dh,0ah, "Choose your operation 1- Addition 2- Subtraction 3- Multiplication 4- Division" ,0dh,0ah,"$"
firstNumberMsg: db 0dh,0ah, "Enter the first number: ", "$"
secondNumberMsg: db 0dh,0ah, "Enter the second number: ", "$"
errorMsg: db 0dh,0ah, "Not valid number, press any key to restart $"   ; if we removed the dollar sign ($) it will print the next message. it makes the console stops instead of it
resultMsg: db 0dh,0ah, "The result is: $"        





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
       
       
       
       
       
Addition:    



Subtraction:   



Multiplication:             



Division:
ret




