data segment
letter db 0
digit  db 0
other  db 0
 msg db 'Please input :',0ah,0dh,'$'
 imsg db 'iloveyou',0ah,0dh,'$'
 ;数字 		30h-39h 0011,0000~0011,1001B
 ;大写字母  41h-5ah 0100,0001~0101,1010B
 ;小写字母  61h-7ah 0110,0001~0111,1010B
 ;也可以用test指令简化程序
 buf1 db 100 dup(0)
 dmsg db 0ah,'digit:',0ah,0dh,'$'
 lmsg db 0ah,'letter:',0ah,0dh,'$'
data ends
assume cs:code,ds:data
code segment
showtotal:mov ah,02h
add dx,30h
int 21h
ret
showstring:mov ah,09h
int 21h
ret
start:  mov ax,data
        mov ds,ax
        mov dx,offset msg
        mov ah,09h
        int 21h
     nextchar:      mov ah,01h
 		   int 21h
        cmp al,'A'
        jb xiao
        cmp al,'Z'
        ja  da
        inc letter
    xiao:cmp al,'0'
         jb exit
         cmp al,'9'
         ja exit
         inc digit
    da  :cmp al,'a'
         jb exit
         cmp al,'z'
         ja exit
         inc letter
  exit: 
        sub ax,0
  		cmp al,0dh
       jnz nextchar
      
final:
  
mov dx,offset dmsg
call showstring
mov dl,digit
call showtotal
mov dx,offset lmsg
call showstring
mov dl,letter
call showtotal

  		mov ax,4c00h
        int 21h

code ends
end start
