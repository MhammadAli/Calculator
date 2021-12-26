              
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
exitMsg: db 0dh,0ah, "Thanks for using our calculator,, press any key to exit",0dh,0ah,"$" 
reminderMsg: db 0dh,0ah, "The reminder is: $"



start:                   
       mov ah,9
       mov dx,offset operationMsg
       int 21h
       mov ah,0
       int 16h
       cmp al,31h
       je Addition
       cmp al,32h
       je Subtraction 
       cmp al,33h
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
        mov ah,9
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
        call ViewAll 
        pop dx
        mov cx,10000
        mov bx,dx
        
        mov ah,9
        mov dx,offset reminderMsg
        int 21h
        
        mov dx,bx
        call ViewAll 
        jmp exit 

InputNumber:
      mov ah,0
      int 16h
      mov dx,0
      mov bx,1
      cmp al,0dh
      je FormNumber
      sub al,30h
      call ViewDigit
      inc cx
      mov ah,0
      push ax
      jmp InputNumber
      ret
      


FormNumber:
        pop ax
        push dx
        mul bx
        pop dx
        add dx,ax
        
        mov ax,10
        push dx
        mul bx
        pop dx
        mov bx,ax
        
        
        
        dec cx
        cmp cx,0
        jne FormNumber
        ret
            
            
            
ViewDigit:
        push ax
        push dx
        mov dx,ax
        add dl,30h
        mov ah,2
        int 21h
        pop dx
        pop ax
        ret
 
     
ViewAll:
        mov ax,dx
        mov dx,0
        div cx
        
        call ViewDigit
        
        mov bx,dx
        mov ax,cx
        mov cx,10
        mov dx,0
        div cx
        mov cx,ax
        mov dx,bx
        cmp ax,0
        jne ViewAll  
        ret
      

Exit:
    mov ah,9
    mov dx,offset exitMsg
    int 21h
    mov ah,0
    int 16h
    ret
      
      
      
ret

           
           
           