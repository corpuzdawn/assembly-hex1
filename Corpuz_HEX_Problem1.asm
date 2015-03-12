.model tiny
.data
    mesg db "give me 5 hex digits $"
    buffer db 6,?, 6 dup(' ')     
    errormsg db "ERROR! A value you inputted isn't HEX $"

.code
    main proc
    
    ask:
        mov ah, 09h
        mov dx, offset mesg
        int 21h 
        jmp newline1
    
    newline1:
        mov dh, 1
    	mov dl, 0
    	mov bh, 0
    	mov ah, 2
    	int 10h
    	jmp input
        
    input:
        mov dx, offset buffer
		mov ah, 0ah
		int 21h
		mov bx,0  
		mov bl, buffer[1]
		mov buffer[bx+2], '$' 
		jmp newline2 
		
	newline2: 
	    mov dh, 2
    	mov dl, 0
    	mov bh, 0
    	mov ah, 2
    	int 10h
    	jmp read
		
	read: 
	    mov dl, [buffer+di+2]
        inc di
        cmp dl, 24h
        je stop
        cmp dl, 48
        jge checknumber 
        cmp dl, 65
        jge check_CapAtoF
        cmp dl, 97
        jmp check_atof
        
    
    checknumber:
        cmp dl, 57
        jle print    
    
    check_CapAtoF:
        cmp dl, 70
        jle print 
    
    check_atof:
        cmp dl, 102
        jle print
        jmp changeline3
       
    print:  
        mov ah, 2
        int 21h
        jmp read
        
    changeline3: 
        mov dh, 2
    	mov dl, 0
    	mov bh, 0
    	mov ah, 2
    	int 10h
    	jmp error
     
    error: 
        mov ah, 09h
        mov dx, offset errormsg
        int 21h 
        jmp stop          
    
    stop:
        mov ah, 4Ch
        mov al, 00
        int 21h

    main endp
end