TITLE Demonstrar
.model small
sortear4 macro
    mov ah,2ch
    int 21h
    shr dx,1
    and dx, 00000011b
    ;quatro matrizes inicias possíveis
endm



.stack 100h
.data ;Matriz 20x20 --> 400 de área 
 matriz db 20 dup(20 dup(0h))
 matrizshow db 20 dup(20 dup(0f7h));mostrar onde os disparos foram
 ma db 'Voce acertou! $'
 me db 'Voce errou! $'
 mossT db ' 0 1 2 3 4 5 6 7 8 910111213141516171819  '
 compar db 'a'
 extra_s dw 0
 .code
 ;num 1 -> restricao
 ;1 encouracado -> 4 (tamanho) -> num 2
 ;1 fragata -> 3 -> num 3
 ;2 submarinos -> 2 -> num 4 e 5
 ;2 hidroaviao -> 3 e 1 -> num 5 e 6
 main PROC
    mov ax, @data  ; Configura o segmento de dados ->DS
    mov ds, ax
    
    xor bx,bx
    xor si,si
    sortear4; devolve 0,1,2 ou 3 em dl

    add dl, 30h
    mov ah,2
    int 21h
    mov dh, dl
    mov dl, 10
    int 21h
    mov dl,dh
    sub dl, 30h

    cmp dl,3
    je config3
    
    cmp dl, 2
    je config2

    cmp dl, 1
    je config1
    
    call mod0
    jmp final_da_definicao

    config3:
    call mod3
    jmp final_da_definicao

    config2:
    call mod2
    jmp final_da_definicao

    config1:
    call mod1

    final_da_definicao:

    
    mov cx, 20
    mov ah,2
    mov dl, ' '
    int 21h
    int 21h
    int 21h
    mov dx, 'A'
    print_letras_tabela:
    int 21h
    push dx
    mov dx, ''
    int 21h
    pop dx
    inc dl
    loop print_letras_tabela
    mov dl, 10
    int 21h

    call addaprinta
    mov dl, ' '
    int 21h


    xor bx,bx
    mov di, 20
    test_print:
    mov cx, 20
    xor si,si
    test_print1:
    mov dl, matriz[bx][si]
    add dl, 30h
    int 21h
    inc si
    mov dl, ' '
    int 21h
    loop test_print1
    mov dl, 10
    int 21h

    push bx
    call addaprinta
    mov dl, ' '
    int 21h
    pop bx


    add bx, 20
    dec di
    jnz test_print





    mov ah,4ch ;encerrando
    int 21h
 main ENDP
 
 ;MOD3
 mod3 PROC
   xor bx,bx
   xor si,si 
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx,4
   mov al, 20
   mul bl
   xchg bx, ax
   encouracado1:
   mov matriz [bx][si], 1
   inc si
   loop encouracado1

   mov bx, 14
   mov si, 17
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   fragata1:
   mov matriz [bx][si], 2
   add bx, 20
   loop fragata1 

   mov bx, 10
   mov si, 5
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx,2
   mov al, 20
   mul bl
   xchg bx, ax
   submarino1:
   mov matriz [bx][si], 3
   inc si
   loop submarino1

   mov bx, 0
   mov si, 17
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 2
   mov al,20
   mul bl
   xchg bx, ax
   submarino2:
   mov matriz [bx][si], 4
   add bx, 20
   loop submarino2
  
   mov bx, 3
   mov si, 7
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   push bx
   push si; pilha -> si|bx
   add bx, 20
   add si, 1
   mov matriz [bx][si],5
   pop si
   pop bx
   porta_avioes1:
   mov matriz [bx][si],5
   add bx, 20
   loop porta_avioes1

   mov bx, 15
   mov si, 0
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   push bx
   push si; pilha -> si|bx
   add bx, 20
   add si, 1
   mov matriz [bx][si],6
   pop si
   pop bx
   porta_avioes2:
   mov matriz [bx][si],6
   add bx, 20
   loop porta_avioes2
   

  ret

 mod3 ENDP







 ;MOD2
 mod2 PROC
   mov bx, 0
   mov si, 13
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx,4
   mov al, 20
   mul bl
   xchg bx, ax
   encouracado1_2:
   mov matriz [bx][si], 1
   inc si
   loop encouracado1_2

   mov bx, 1
   mov si, 1
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   fragata1_2:
   mov matriz [bx][si], 2
   add bx, 20
   loop fragata1_2 

   mov bx, 5
   mov si, 10
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx,2
   mov al, 20
   mul bl
   xchg bx, ax
   submarino1_2:
   mov matriz [bx][si], 3
   inc si
   loop submarino1_2

   mov bx, 5
   mov si, 17
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 2
   mov al,20
   mul bl
   xchg bx, ax
   submarino2_2:
   mov matriz [bx][si], 4
   add bx, 20
   loop submarino2_2
  
   mov bx, 10
   mov si, 8
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   push bx
   push si; pilha -> si|bx
   add bx, 20
   add si, 1
   mov matriz [bx][si],5
   pop si
   pop bx
   porta_avioes1_2:
   mov matriz [bx][si],5
   add bx, 20
   loop porta_avioes1_2

   mov bx, 15
   mov si, 15
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   push bx
   push si; pilha -> si|bx
   add bx, 20
   add si, 1
   mov matriz [bx][si],6
   pop si
   pop bx
   porta_avioes2_2:
   mov matriz [bx][si],6
   add bx, 20
   loop porta_avioes2_2
   

  ret

 mod2 ENDP






 ;MOD1
 mod1 PROC
   mov bx, 13
   mov si, 0
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 4
   mov al,20
   mul bl
   xchg bx, ax
   encouracado1_1:
   mov matriz [bx][si], 1
   add bx, 20
   loop encouracado1_1 

   mov bx, 16
   mov si, 12
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx,3
   mov al, 20
   mul bl
   xchg bx, ax
   fragata1_1:
   mov matriz [bx][si], 2
   inc si
   loop fragata1_1

   mov bx, 8
   mov si, 10
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx,2
   mov al, 20
   mul bl
   xchg bx, ax
   submarino1_1:
   mov matriz [bx][si], 3
   inc si
   loop submarino1_1

   mov bx, 11
   mov si, 5
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 2
   mov al,20
   mul bl
   xchg bx, ax
   submarino2_1:
   mov matriz [bx][si], 4
   add bx, 20
   loop submarino2_1

   mov bx, 0
   mov si, 2
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   push bx
   push si; pilha -> si|bx
   add bx, 20
   dec si
   mov matriz [bx][si],5
   pop si
   pop bx
   porta_avioes1_1:
   mov matriz [bx][si],5
   add bx, 20
   loop porta_avioes1_1

   mov bx, 0
   mov si, 10
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   push bx
   push si; pilha -> si|bx
   add bx, 20
   inc si
   mov matriz [bx][si],6
   pop si
   pop bx
   porta_avioes2_1:
   mov matriz [bx][si],6
   add bx, 20
   loop porta_avioes2_1

   ret
 mod1 ENDP








 ;MOD0
 mod0 PROC
   
  mov bx, 13
   mov si, 1
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 4
   mov al,20
   mul bl
   xchg bx, ax
   encouracado1_0:
   mov matriz [bx][si], 1
   add bx, 20
   loop encouracado1_0

   mov bx, 16
   mov si, 12
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx,3
   mov al, 20
   mul bl
   xchg bx, ax
   fragata1_0:
   mov matriz [bx][si], 2
   inc si
   loop fragata1_0

   mov bx, 8
   mov si, 10
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx,2
   mov al, 20
   mul bl
   xchg bx, ax
   submarino1_0:
   mov matriz [bx][si], 3
   inc si
   loop submarino1_0

   mov bx, 11
   mov si, 5
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 2
   mov al,20
   mul bl
   xchg bx, ax
   submarino2_0:
   mov matriz [bx][si], 4
   add bx, 20
   loop submarino2_0

   mov bx, 0
   mov si, 10
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   push bx
   push si; pilha -> si|bx
   add bx, 20
   inc si
   mov matriz [bx][si],5
   pop si
   pop bx
   porta_avioes1_0:
   mov matriz [bx][si],5
   inc si
   loop porta_avioes1_0

   mov bx, 0
   mov si, 0
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   push bx
   push si; pilha -> si|bx
   add bx, 20
   inc si
   mov matriz [bx][si],6
   pop si
   pop bx
   porta_avioes2_0:
   mov matriz [bx][si],6
   inc si
   loop porta_avioes2_0

 ret
 mod0 ENDP

 ;Sortear3
 sortear3 proc
    mov ah,2ch
    ResortearMaior3:
    int 21h
    and dx, 00000011b
    cmp dx, 3
    jae ResortearMaior3
    cmp dl,compar[0]
    je ResortearMaior3
    mov compar[0], dl
    ret
endp




 addaprinta proc
  mov bx, extra_s
  mov dl, mossT[bx]
  int 21h
  add extra_s, 1

  mov bx, extra_s
  mov dl, mossT[bx]
  int 21h
  add extra_s, 1

  ret
 addaprinta endp

 end main