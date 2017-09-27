data segment 
  msg  db '1+2+3+4+...+100=',0ah,0dh,'$'
  source db 100 dup(0)   ;源串
data ends
extra segment
  dest db 100 dup(0)     ;目的串
extra ends
stack segment 
   db 30 dup(0)
stack ends
assume cs:code,ds:data,es:extra,ss:stack 
code segment
showmsg proc           ;showmsg子程序调用dos9号中断，显示字符串
    mov ah,9
    mov dx,offset msg  ;AH=9,DS:DX=字符串地址
    int 21h
  ret
showmsg endp
enter proc            ;enter子程序显示回车字符
    mov ah,2          ;2号功能是单字符显示输出
    mov dl,0dh        ;回车ASCII码送dl
    int 21h
  ret
enter endp
start : mov ax,stack
        mov ss,ax
        mov sp,30     ;设栈顶指针
        mov ax,extra
        mov es,ax
        mov ax,data
        mov ds,ax
        call showmsg
        call enter
        mov bx,0            ;bx放源串的偏移地址
        mov al,1
        mov cx,100
    s : mov source[bx],al   ;给源串写入1——100的数据
         inc al
         inc bx
        loop s
  copy: lea si,source
        lea di,dest
        cld                 ;传送方向为正，传送100个字节
        mov cx,100
        rep movsb

        lea si,source
        lea di,dest
        cld                 ;串比较方向为正，比较100次
        mov cx,100
        repz cmpsb          ;结果为0或相等就重复操作
        cmp cx,0            ;若cx不为0，那一定是提前退出的
        jnz copy            ;即两个串并不完全相同，需要重新传送
        mov cx,100
        xor ax,ax           ;ax清零
        xor bx,bx           ;bx清零
        mov di,0
        plus:mov bl,byte ptr es:dest[di]
        add ax,bx
        inc di
        loop plus
        ;此时加完，ax里保存着结果的数值，接下来转十进制
        ;再用ASCII码输出显示

        mov bp,10
        xor bx,bx
        xor cx,cx
  bin2decimal  :mov dx,0
                inc cx  
               ;push多少次，就要pop多少次（again循环）     
               idiv bp     ;有符号字除 r16/m16 (ax)/(bp)
               push dx     ;idiv r16/m16 余数放在dx,商放在ax
               cmp ax,0
        jnz bin2decimal
        mov ah,2
  again:    pop dx
            add dl,30h  ;(dx)的数值加上30h,得到它的ASCII码
            int 21h     ;2号中断显示输出
          loop again    
          
  mov ax,4c00h
  int 21h
code ends
end start