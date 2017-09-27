;x-|y|+|z|
;9-6+5=8
;最大支持两位数，97-|67|+|45|=75
;在输入负六时应输入-06
;目前暂不支持结果为负的情况
data segment
  x dw 9
  y dw -6
  z dw 5
  flag db 0
  msg db 'x-|y|+|z|=?,Please input x,y,z:',0ah,0dh,'$'
  xmsg db 0ah,'  x=?  ',0ah,0dh,'$'
  ymsg db 0ah,'y=?  ',0ah,0dh,'$'
  zmsg db 0ah,'z=?  ',0ah,0dh,'$'
  resultmsg db 0ah,'x-|y|+|z|=?',0ah,0dh,'$'
  result dw ?
data ends
stack segment
  dw 16 dup(0)
stack ends
assume cs:code,ds:data,ss:stack 
code segment
absolute:
sub ax,0
jns ok
neg ax
ok:
ret 
input :
push bx
mov flag,0
chongshu:

mov ah,01h
int 21h
cmp al,'-'
jnz continue
mov flag,1

mov ah,01h
int 21h
continue:

sub ax,0
aaa
mov bl,al
int 21h
aaa

mov ah,0
mov bh,0
mov cx,10
shi:add ax,bx
loop shi
;mov ax,bx
pop bx

cmp flag,0
jz zhen
neg ax
zhen:
mov word ptr[bx],ax

nop
ret 
showstring:
mov ah,9
int 21h
mov ax,0
ret

start:

mov ax,data
mov ds,ax

mov dx,offset msg
call showstring
mov dx,offset xmsg
call showstring
lea bx,x
call input
mov ax,0200h
mov dx,word ptr[bx]
add dx,30h
;int 21h ;输出x

mov dx,offset ymsg
call showstring
lea bx,y
call input
mov ax,0200h
mov dx,word ptr[bx]
add dx,30h
;int 21h ;输出y

mov dx,offset zmsg
call showstring
lea bx,z
call input
mov ax,0200h
mov dx,word ptr[bx]
add dx,30h
;int 21h  ;输出z

mov dx,offset resultmsg
call showstring

mov ax,y
call absolute 
mov bx,ax
mov ax,z
call absolute
mov bp,ax
mov ax,x
nop
sub ax,bx
add ax,bp
mov dx,ax
nop
mov bp,10
mov ax,dx
mov bx,1
imul bx
aam
add ax,3030h
mov bx,ax
mov dx,0
mov dl,bh
mov ah,2
int 21h
mov dl,bl
int 21h
mov ax,4c00h
int 21h
code ends
end start