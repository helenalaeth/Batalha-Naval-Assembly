TITLE Projeto
.model small
sortear4 macro
    mov ah,2ch                            ;pega a hora do computador, coloca os segundos em dx
    int 21h
    shr dx,1
    and dx, 00000011b                     ;remover numeros irrelevantes
    ;quatro matrizes inicias possíveis
endm

ZerarValor macro                          ;macro para reseta os índices da matriz
   xor bx,bx
   xor si,si
endm
SortearMacro macro
   call sortear3                           ;sorteia 3 valores (quantidade de casa que o barco pode andar pro lado)
   add bx, dx                              ;altera a linha
   call sortear3                           ;sorteia 3 valores (quantidade de casa que o barco pode andar pro lado)
   add si, dx                              ;altera a coluna
endm
PrintaMsg macro Valor
   mov ah,Valor                            ;O número da função é passado para ah e a função é executada
   int 21h
endm
PopVMatriz macro
   pop si                                  ;macro para retornar valores dos índices, é usado nos modelos, para inserir os hidroaviões na matriz
   pop bx
endm
PushVMatriz macro                          ;macro para retornar valores dos índices, é usado nos modelos, para inserir os hidroaviões na matriz
   push bx
   push si
endm
PulaLinha macro                           ;macro LF (pula uma linha imprimindo o enter na tela)
   mov ah,2
   mov dl,10
   int 21h
endm


.stack 200h
.data ;Matriz 20x20 --> 400 de área 

 matriz db 20 dup(20 dup(0h))

 matrizshow db 20 dup(20 dup(30h))                                                                                   ;matriz onde os barcos são alocados

 ma db 'Voce acertou!',10,' Digite D para desistir ou qualquer outra tecla para disparar novamente$'                 ;ma= mensagem de acerto

 me db 'Voce errou!',10,' Digite D para desistir ou qualquer outra tecla para disparar novamente$'                   ;me= mensagem de erro

 mj db 'Ja disparou nesse local!',10,' Digite D para desistir ou qualquer outra tecla para disparar novamente$'      ;mj= mensagem já disparou nesse local

 minicial db 10,'Seja bem vindo, digite qualquer tecla para continuar$'                                              ;mensagem inicial

 mossT db ' 0 1 2 3 4 5 6 7 8 910111213141516171819  '                                                               ;numeros para as colunas

 mossL db 'abcdefghijklmnopqrst'                                                                                     ;quando a coordenada for digitada, as letras podem ser maiusculas ou minusculas

 menleicord db 10,'Digite a cordenada do disparo',10,'$'                                                             ;mensagens pedindo as coordenadas   

 menleiletra db 'Entre com a letra(somente de A ate T):$'                                                   

 menleinum db 'Entre com o numero (2 digitos, exemplo->01) de 00 ate 19:$'

 optroccord db 'Deseja continuar com a sua cordenada? [','$'                                                         ;pergunta se quer continuar com a mesma coordenada   

 contoptroccord db ']',10,'Digite 1 para trocar ou qualquer outra tecla para confirmar o disparo:$'                  ;continuação do optrocccord

 quantungacertungprintungs db 'Quantidade de acertos total:$'                                                        ;mensagem para mostrar a quantidade de acertos total

 totaldeposs db '/19$'                                                                                               ;total de acertos possíveis, baseado na quantidade de posições das embarcações

 totaldenau db '/6$'                                                                                                 ;quantidade de naufrágios   

 stringquantnau db 'Quantidade de embarcacoes que naufragaram:$'       

 compar db 'a'                                                                                                       ;não ressortear números iguais

 obrigado db 10,'Obrigado por jogar',10,'Encerrando...$'                                                             ;fim de jogo

 extra_s dw 0                                                                                                        ;guarda a posição para printar a próxima matriz

 controleEncerrar db 0                                                                                               ;usada para parar o jogo

 quantidadenaufragios db 6                                                                                           ;controla a quantidade de náufragios

 quantacertosTotal db 0                                                                                              ;quantidade de acertos até o momento
 .code
 ;num 1 -> restricao
 ;1 encouracado -> 4 (tamanho) -> num 2
 ;1 fragata -> 3 -> num 3
 ;2 submarinos -> 2 -> num 4 e 5
 ;2 hidroavião -> 3 e 1 -> num 5 e 6
 main PROC
    mov ax, @data                                             ; Configura o segmento de dados -> DS
    mov ds, ax
    
    ZerarValor                                                ;zera indices
    sortear4                                                  ;devolve 0,1,2 ou 3 em dl

    cmp dl,3                                                  ;se o sorteado for 3, pula para config3      
    je config3
    
    cmp dl, 2                                                 ;se o sorteado for 2, pula para config2  
    je config2

    cmp dl, 1                                                 ;se o sorteado for 1, pula para config1    
    je config1
    
    call mod0                                                 ;se o sorteado for 0, pula para o procedimento mod0 (modelo 0)
    jmp final_da_definicao                                    ;pula para final da definição após sair do procedimento

    config3:                                                  ;a depender de cada config sorteada, entra em seu respectivo procedimento
    call mod3                                                 ;chama procedimento da config3
    jmp final_da_definicao

    config2:                                                  ;chama procedimento da config2
    call mod2
    jmp final_da_definicao

    config1:
    call mod1                                                  ;chama procedimento da config1

    final_da_definicao:                                                                                               

    call lim_km_prinn                                         ;chama o procedimento que imprime a matriz que será mostrada ao usuário

    lea dx, minicial                                          ;imprime a mensagem inicial
    PrintaMsg 9
    PrintaMsg 8                                               ;"Digite qualquer tecla para continuar"       
    call lim_km_prinn                                         ;Após o usuário digitar qualquer tecla, chama o procedimento que imprime a matriz novamente
    call in_game                                              ;após imprimir a matriz 


    mov ah,4ch                                                 ;encerrando
    int 21h
 main ENDP
 
 

;                       *********TODOS OS MODELOS SEGUEM O MESMO PRINCÍPIO************



;                                   MODELO3


mod3 PROC
   ZerarValor                                                  ;zera índices SI e DI
   SortearMacro                                                ;sorteia valor
   mov cx,4                                                    ;define contagem para encouraçado
   mov al, 20                                                  ;carrega valor 20 em al
   mul bl                                                      ;multiplica al por bl
   xchg bx, ax                                                 ;troca valores de bx e ax
   encouracado1:                                               ;dispõe o encouraçado na posição sorteada
   mov matriz [bx][si], 1                                      ;insere o valor 1 na matriz
   inc si                                                      ;incrementa si
   loop encouracado1                                           ;loop para a próxima posição

   mov bx, 14                                                  ;muda a posição dos índices
   mov si, 17                                                  ;define índice si
   SortearMacro                                                ;sorteia valor
   mov cx, 3                                                   ;define contagem para fragata
   mov al,20                                                   ;a depender do valor sorteado, irá para uma posição aleatória da matriz
   mul bl                                                      ;multiplica al por bl
   xchg bx, ax                                                 ;troca valores de bx e ax
   fragata1:                                                   ;dispõe a fragata na posição sorteada
   mov matriz [bx][si], 2                                      ;insere o valor 2 na matriz
   add bx, 20                                                  ;vai para próxima linha (continuação da disposição da fragata na matriz)
   loop fragata1                                               ;loop para a próxima posição

   mov bx, 10                                                  ;muda a posição dos índices
   mov si, 5                                                   ;define índice si
   SortearMacro                                                ;sorteia valor
   mov cx,2                                                    ;define contagem para submarino1
   mov al, 20                                                  ;a depender do valor sorteado, irá para uma posição aleatória da matriz
   mul bl                                                      ;multiplica al por bl
   xchg bx, ax                                                 ;troca valores de bx e ax
   submarino1:                                                 ;dispõe o submarino1 na posição sorteada
   mov matriz [bx][si], 3                                      ;insere o valor 3 na matriz
   inc si                                                      ;incrementa si
   loop submarino1                                             ;loop para a próxima posição

   xor bx,bx                                                   ;muda a posição dos índices
   mov si, 17                                                  ;define índice si
   SortearMacro                                                ;sorteia valor
   mov cx, 2                                                   ;define contagem para submarino2
   mov al,20                                                   ;a depender do valor sorteado, irá para uma posição aleatória da matriz
   mul bl                                                      ;multiplica al por bl
   xchg bx, ax                                                 ;troca valores de bx e ax
   submarino2:                                                 ;dispõe o submarino2 na posição sorteada   
   mov matriz [bx][si], 4                                      ;insere o valor 4 na matriz
   add bx, 20                                                  ;vai para próxima linha
   loop submarino2                                             ;loop para a próxima posição
  
   mov bx, 3                                                   ;muda a posição dos índices
   mov si, 7                                                   ;define índice si
   SortearMacro                                                ;sorteia valor  
   mov cx, 3                                                   ;define contagem para hidroavião1
   mov al,20                                                   ;a depender do valor sorteado, vai para uma posição aleatória da matriz
   mul bl                                                      ;multiplica al por bl
   xchg bx, ax                                                 ;troca valores de bx e ax
   PushVMatriz                                                 ;pilha -> si|bx                                                                                           
   add bx, 20                                                  ;bx na próxima linha
   add si, 1                                                   ;si na próxima coluna
   mov matriz [bx][si],5                                       ;insere a "cabeça" do hidroavião
   PopVMatriz                                                  ;retorna valor dos registradores
   hidro_aviao1:                                               ;insere o resto do corpo do hidroavião
   mov matriz [bx][si],5                                       ;insere o valor 5 na matriz
   add bx, 20                                                  ;vai para próxima linha
   loop hidro_aviao1                                           ;loop para a próxima posição

   mov bx, 15                                                  ;muda a posição dos índices
   xor si,si                                                   ;zera índice si
   SortearMacro                                                ;sorteia valor 
   mov cx, 3                                                   ;define contagem para hidroavião2                                      
   mov al,20                                                   ;a depender do valor sorteado, vai para uma posição aleatória da matriz
   mul bl                                                      ;multiplica al por bl
   xchg bx, ax                                                 ;troca valores de bx e ax
   PushVMatriz                                                 ;pilha -> si|bx   
   add bx, 20                                                  ;bx na próxima linha  
   add si, 1                                                   ;si na próxima coluna
   mov matriz [bx][si],6                                       ;insere a "cabeça" do hidroavião     
   PopVMatriz                                                  ;retorna valor dos registradores  
   hidro_aviao2:                                               ;insere o resto do corpo do hidroavião
   mov matriz [bx][si],6                                       ;insere o valor 6 na matriz
   add bx, 20                                                  ;vai para próxima linha
   loop hidro_aviao2                                           ;loop para a próxima posição

  ret

mod3 ENDP



;                                          MODELO 2
 mod2 PROC
   xor bx,bx                                                 ;zera índice bx
   mov si, 13                                                ;define índice si
   SortearMacro                                              ;sorteia valor
   mov cx,4                                                  ;define contagem para encouraçado
   mov al, 20                                                ;carrega valor 20 em al
   mul bl                                                    ;multiplica al por bl
   xchg bx, ax                                               ;troca valores de bx e ax
   encouracado1_2:                                           ;dispõe o encouraçado na posição sorteada
   mov matriz [bx][si], 1                                    ;insere o valor 1 na matriz
   inc si                                                    ;incrementa si
   loop encouracado1_2                                       ;loop para a próxima posição

   mov bx, 1                                                 ;muda a posição dos índices
   mov si, 1                                                 ;define índice si
   SortearMacro                                              ;sorteia valor
   mov cx, 3                                                 ;define contagem para fragata
   mov al,20                                                 ;carrega valor 20 em al
   mul bl                                                    ;multiplica al por bl
   xchg bx, ax                                               ;troca valores de bx e ax
   fragata1_2:                                               ;dispõe a fragata na posição sorteada
   mov matriz [bx][si], 2                                    ;insere o valor 2 na matriz
   add bx, 20                                                ;vai para próxima linha
   loop fragata1_2                                           ;loop para a próxima posição

   mov bx, 5                                                 ;muda a posição dos índices
   mov si, 10                                                ;define índice si
   SortearMacro                                              ;sorteia valor
   mov cx,2                                                  ;define contagem para submarino1
   mov al, 20                                                ;carrega valor 20 em al
   mul bl                                                    ;multiplica al por bl
   xchg bx, ax                                               ;troca valores de bx e ax
   submarino1_2:                                             ;dispõe o submarino1 na posição sorteada
   mov matriz [bx][si], 3                                    ;insere o valor 3 na matriz
   inc si                                                    ;incrementa si
   loop submarino1_2                                         ;loop para a próxima posição

   mov bx, 5                                                 ;muda a posição dos índices
   mov si, 17                                                ;define índice si
   SortearMacro                                              ;sorteia valor
   mov cx, 2                                                 ;define contagem para submarino2
   mov al,20                                                 ;carrega valor 20 em al
   mul bl                                                    ;multiplica al por bl
   xchg bx, ax                                               ;troca valores de bx e ax
   submarino2_2:                                             ;dispõe o submarino2 na posição sorteada
   mov matriz [bx][si], 4                                    ;insere o valor 4 na matriz
   add bx, 20                                                ;vai para próxima linha
   loop submarino2_2                                         ;loop para a próxima posição
  
   mov bx, 10                                                ;muda a posição dos índices
   mov si, 8                                                 ;define índice si
   SortearMacro                                              ;sorteia valor
   mov cx, 3                                                 ;define contagem para hidroavião1
   mov al,20                                                 ;carrega valor 20 em al
   mul bl                                                    ;multiplica al por bl
   xchg bx, ax                                               ;troca valores de bx e ax
   PushVMatriz                                               ;pilha -> si|bx
   add bx, 20                                                ;bx na próxima linha
   add si, 1                                                 ;si na próxima coluna
   mov matriz [bx][si],5                                     ;insere a "cabeça" do hidroavião
   PopVMatriz                                                ;retorna valor dos registradores
   hidro_aviao1_2:                                           ;insere o resto do corpo do hidroavião
   mov matriz [bx][si],5                                     ;insere o valor 5 na matriz
   add bx, 20                                                ;vai para próxima linha
   loop hidro_aviao1_2                                       ;loop para a próxima posição
 
   mov bx, 15                                                ;muda a posição dos índices
   mov si, 15                                                ;define índice si
   SortearMacro                                              ;sorteia valor
   mov cx, 3                                                 ;define contagem para hidroavião2
   mov al,20                                                 ;carrega valor 20 em al
   mul bl                                                    ;multiplica al por bl
   xchg bx, ax                                               ;troca valores de bx e ax
   PushVMatriz                                               ;pilha -> si|bx
   add bx, 20                                                ;bx na próxima linha  
   add si, 1                                                 ;si na próxima coluna
   mov matriz [bx][si],6                                     ;insere a "cabeça" do hidroavião     
   PopVMatriz                                                ;retorna valor dos registradores  
   hidro_aviao2_2:                                           ;insere o resto do corpo do hidroavião
   mov matriz [bx][si],6                                     ;insere o valor 6 na matriz
   add bx, 20                                                ;vai para próxima linha
   loop hidro_aviao2_2                                       ;loop para a próxima posição

  ret

mod2 ENDP




;                                                  MODELO 1
mod1 PROC
   mov bx, 13                                                 ;define índice bx
   xor si,si                                                  ;zera índice si
   SortearMacro                                               ;sorteia valor
   mov cx, 4                                                  ;define contagem para encouraçado
   mov al,20                                                  ;carrega valor 20 em al
   mul bl                                                     ;multiplica al por bl
   xchg bx, ax                                                ;troca valores de bx e ax
   encouracado1_1:                                            ;dispõe o encouraçado na posição sorteada
   mov matriz [bx][si], 1                                     ;insere o valor 1 na matriz
   add bx, 20                                                 ;vai para próxima linha
   loop encouracado1_1                                        ;loop para a próxima posição 

   mov bx, 16                                                 ;muda a posição dos índices
   mov si, 12                                                 ;define índice si
   SortearMacro                                               ;sorteia valor
   mov cx,3                                                   ;define contagem para fragata
   mov al, 20                                                 ;carrega valor 20 em al
   mul bl                                                     ;multiplica al por bl
   xchg bx, ax                                                ;troca valores de bx e ax
   fragata1_1:                                                ;dispõe a fragata na posição sorteada
   mov matriz [bx][si], 2                                     ;insere o valor 2 na matriz
   inc si                                                     ;incrementa si
   loop fragata1_1                                            ;loop para a próxima posição

   mov bx, 8                                                  ;muda a posição dos índices
   mov si, 10                                                 ;define índice si
   SortearMacro                                               ;sorteia valor
   mov cx,2                                                   ;define contagem para submarino1
   mov al, 20                                                 ;carrega valor 20 em al
   mul bl                                                     ;multiplica al por bl
   xchg bx, ax                                                ;troca valores de bx e ax
   submarino1_1:                                              ;dispõe o submarino1 na posição sorteada
   mov matriz [bx][si], 3                                     ;insere o valor 3 na matriz
   inc si                                                     ;incrementa si
   loop submarino1_1                                          ;loop para a próxima posição

   mov bx, 11                                                 ;muda a posição dos índices
   mov si, 5                                                  ;define índice si
   SortearMacro                                               ;sorteia valor
   mov cx, 2                                                  ;define contagem para submarino2
   mov al,20                                                  ;carrega valor 20 em al
   mul bl                                                     ;multiplica al por bl
   xchg bx, ax                                                ;troca valores de bx e ax
   submarino2_1:                                              ;dispõe o submarino2 na posição sorteada
   mov matriz [bx][si], 4                                     ;insere o valor 4 na matriz
   add bx, 20                                                 ;vai para próxima linha
   loop submarino2_1                                          ;loop para a próxima posição

   xor bx,bx                                                  ;zera índice bx
   mov si, 2                                                  ;define índice si
   SortearMacro                                               ;sorteia valor
   mov cx, 3                                                  ;define contagem para hidroavião1
   mov al,20                                                  ;carrega valor 20 em al
   mul bl                                                     ;multiplica al por bl
   xchg bx, ax                                                ;troca valores de bx e ax
   PushVMatriz; pilha -> si|bx                                ;pilha -> si|bx
   add bx, 20                                                 ;bx na próxima linha
   dec si                                                     ;decrementa si
   mov matriz [bx][si],5                                      ;insere a "cabeça" do hidroavião
   PopVMatriz                                                 ;retorna valor dos registradores
   hidro_aviao1_1:                                            ;insere o resto do corpo do hidroavião
   mov matriz [bx][si],5                                      ;insere o valor 5 na matriz
   add bx, 20                                                 ;vai para próxima linha
   loop hidro_aviao1_1                                        ;loop para a próxima posição

   xor bx,bx                                                  ;zera índice bx
   mov si, 10                                                 ;define índice si
   SortearMacro                                               ;sorteia valor
   mov cx, 3                                                  ;define contagem para hidroavião2
   mov al,20                                                  ;carrega valor 20 em al
   mul bl                                                     ;multiplica al por bl
   xchg bx, ax                                                ;troca valores de bx e ax
   PushVMatriz; pilha -> si|bx                                ;pilha -> si|bx
   add bx, 20                                                 ;bx na próxima linha  
   inc si                                                     ;incrementa si
   mov matriz [bx][si],6                                      ;insere a "cabeça" do hidroavião     
   PopVMatriz                                                 ;retorna valor dos registradores  
   hidro_aviao2_1:                                            ;insere o resto do corpo do hidroavião
   mov matriz [bx][si],6                                      ;insere o valor 6 na matriz
   add bx, 20                                                 ;vai para próxima linha
   loop hidro_aviao2_1                                        ;loop para a próxima posição

   ret
mod1 ENDP








 ;                                            MODELO 0
 mod0 PROC
   
   mov bx, 13                                                 ;define índice bx
   mov si, 1                                                  ;define índice si
   SortearMacro                                               ;sorteia valor
   mov cx, 4                                                  ;define contagem para encouraçado
   mov al,20                                                  ;carrega valor 20 em al
   mul bl                                                     ;multiplica al por bl
   xchg bx, ax                                                ;troca valores de bx e ax
   encouracado1_0:                                            ;dispõe o encouraçado na posição sorteada
   mov matriz [bx][si], 1                                     ;insere o valor 1 na matriz
   add bx, 20                                                 ;vai para próxima linha
   loop encouracado1_0                                        ;loop para a próxima posição

   mov bx, 16                                                 ;muda a posição dos índices
   mov si, 12                                                 ;define índice si
   SortearMacro                                               ;sorteia valor
   mov cx,3                                                   ;define contagem para fragata
   mov al, 20                                                 ;carrega valor 20 em al
   mul bl                                                     ;multiplica al por bl
   xchg bx, ax                                                ;troca valores de bx e ax
   fragata1_0:                                                ;dispõe a fragata na posição sorteada
   mov matriz [bx][si], 2                                     ;insere o valor 2 na matriz
   inc si                                                     ;incrementa si
   loop fragata1_0                                            ;loop para a próxima posição

   mov bx, 8                                                  ;muda a posição dos índices
   mov si, 10                                                 ;define índice si
   SortearMacro                                               ;sorteia valor
   mov cx,2                                                   ;define contagem para submarino1
   mov al, 20                                                 ;carrega valor 20 em al
   mul bl                                                     ;multiplica al por bl
   xchg bx, ax                                                ;troca valores de bx e ax
   submarino1_0:                                              ;dispõe o submarino1 na posição sorteada
   mov matriz [bx][si], 3                                     ;insere o valor 3 na matriz
   inc si                                                     ;incrementa si
   loop submarino1_0                                          ;loop para a próxima posição

   mov bx, 11                                                 ;muda a posição dos índices
   mov si, 5                                                  ;define índice si
   SortearMacro                                               ;sorteia valor
   mov cx, 2                                                  ;define contagem para submarino2
   mov al,20                                                  ;carrega valor 20 em al
   mul bl                                                     ;multiplica al por bl
   xchg bx, ax                                                ;troca valores de bx e ax
   submarino2_0:                                              ;dispõe o submarino2 na posição sorteada
   mov matriz [bx][si], 4                                     ;insere o valor 4 na matriz
   add bx, 20                                                 ;vai para próxima linha
   loop submarino2_0                                          ;loop para a próxima posição

   xor bx,bx                                                  ;zera índice bx
   mov si, 10                                                 ;define índice si
   SortearMacro                                               ;sorteia valor
   mov cx, 3                                                  ;define contagem para hidroavião1
   mov al,20                                                  ;carrega valor 20 em al
   mul bl                                                     ;multiplica al por bl
   xchg bx, ax                                                ;troca valores de bx e ax
   PushVMatriz; pilha -> si|bx                                ;pilha -> si|bx
   add bx, 20                                                 ;bx na próxima linha
   inc si                                                     ;incrementa si
   mov matriz [bx][si],5                                      ;insere a "cabeça" do hidroavião
   PopVMatriz                                                 ;retorna valor dos registradores
   hidro_aviao1_0:                                            ;insere o resto do corpo do hidroavião
   mov matriz [bx][si],5                                      ;insere o valor 5 na matriz
   inc si                                                     ;incrementa si
   loop hidro_aviao1_0                                        ;loop para a próxima posição

   xor bx,bx                                                  ;zera índice bx
   xor si,si                                                  ;zera índice si
   SortearMacro                                               ;sorteia valor
   mov cx, 3                                                  ;define contagem para hidroavião2
   mov al,20                                                  ;carrega valor 20 em al
   mul bl                                                     ;multiplica al por bl
   xchg bx, ax                                                ;troca valores de bx e ax
   PushVMatriz; pilha -> si|bx                                ;pilha -> si|bx
   add bx, 20                                                 ;bx na próxima linha  
   inc si                                                     ;incrementa si
   mov matriz [bx][si],6                                      ;insere a "cabeça" do hidroavião     
   PopVMatriz                                                 ;retorna valor dos registradores  
   hidro_aviao2_0:                                            ;insere o resto do corpo do hidroavião
   mov matriz [bx][si],6                                      ;insere o valor 6 na matriz
   inc si                                                     ;incrementa si
   loop hidro_aviao2_0                                        ;loop para a próxima posição

 ret
mod0 ENDP


 ;Sortear3

 sortear3 proc
    mov ah,2ch                                         ;pega os segundos da hora do computador
    ResortearMaior3:
    int 21h
    and dx, 00000011b                                  ;remove números irrelevantes
    cmp dx, 3
    jae ResortearMaior3                                ;ressortear caso for 3 ou maior          
    cmp dl,compar[0]                                   ;evitar que ele pegue a mesma hora
    je ResortearMaior3
    mov compar[0], dl
    ret
endp




 addaprinta proc
                                                        ;na primeira vez:
  mov bx, extra_s                                       ;bx <-0                               
  mov dl, mossT[bx]                                     ;move primeiro espaço para DL e imprime
  int 21h
  add extra_s, 1

  mov bx, extra_s                                       ;bx <-1
  mov dl, mossT[bx]                                     ;move numero para DL e imprime
  int 21h
  add extra_s, 1                                        ;extra_s <- 2

  ret
 addaprinta endp

 lim_km_prinn proc                                     
    mov cx, 20                                         ;procedimento que imprime as letras de cima do tabuleiro do jogo
    mov dl, ' '                                       
    PrintaMsg 2
    int 21h                                            ;printa espaços
    int 21h
    mov dx, 'A'                                       
    print_letras_tabela:
    int 21h                                            ;printa primeira letra   
    push dx                                            ;salva na pilha
    mov dx, ''                                         ;printa espaço
    int 21h 
    pop dx                                             ;retorna a letra e vai para a próxima          
    inc dl
    loop print_letras_tabela                           ;até imprimir 20 letras
    mov dl, 10                                         ;ENTER
    int 21h

    call addaprinta
    mov dl, ' '                                        ;após printar o primeiro número, dá um espaço 
    int 21h

   ;imprimindo a matrizshow, que é a matriz definida para a impressão

    xor bx,bx                                         ;zera índice das linhas
    mov di, 20                                        ;di é o contador das linhas
    test_print:
    mov cx, 20                                        ;cx é o contador das colunas
    xor si,si                                         ;zera índice das colunas
    test_print1:
    mov dl, matrizshow[bx][si]                        ;primeiro elemento em dl
    add dl, 30h                                       ;transforma em aspas
    int 21h                                           ;imprime
    inc si                                            ;próxima coluna
    mov dl, ' '                                       ;espaço entre colunas
    int 21h
    loop test_print1                                  ;enquanto as colunas não forem totalmente impressas, pula para test_print1
    mov dl, 10                                        ;imprime o enter para espaçar as linhas      
    int 21h

    push bx                                           ;salva bx na pilha (índice das linhas)
    call addaprinta                                   ;insere o próximo número antes de printar as linhas da matriz, (refaz o processo com o extra_s em 2)
    mov dl, ' '                                       ;espaço
    int 21h
    pop bx                                            ;índice das linhas novamente em bx


    add bx, 20                                        ;próxima linha
    dec di                                            ;faz isso 20 vezes
    jnz test_print
    mov extra_s, 0                                    ;reseta a variável extra_s
    ret
 lim_km_prinn endp


 in_game proc
    jogo:
    mov al, 1                                         ;o encerrento do programa acontece quando a variável controle_encerrar é igual a 1.
    cmp controleEncerrar, al                          ;se a quantidade de acertos for igual a 19, ele acertou todos os barcos, e o controle_encerrar é igual a 1.               
    je enddd                                          ;se for 1, pula para o final
    call perguntar_cord                               ;usuário não acertou tudo ainda, chama procedimento para perguntar coordenada
    call conferir_disparo
    call ganhar_jogo
    mov al, 19; Quantidade total de slots de barco
    cmp quantacertosTotal, al
    jne jogo
    enddd:
    mov dx, offset obrigado                            ;fim de jogo
    PrintaMsg 9
    ret
 in_game endp


 perguntar_cord proc
    

    lerdnovo_ampliado:
    call limpar_tela                                  ;limpa a tela
    mov dx, offset stringquantnau                     ;mostra a quantidade de naufrágios
    PrintaMsg 9
    
    call naufragios                                   ;chama o procedimento para verificar a quantidade de naufrágios 

    mov dl, quantidadenaufragios                      ;imprime a quantidade de embarcações que o usuário naufragou
    or dl, 30h
    PrintaMsg 2

    mov dx,offset totaldenau                          ;mostra o /6 para indicar quantos naufrágios restam para ganhar o jogo
    PrintaMsg 9

    PulaLinha                                            

    mov dx, offset quantungacertungprintungs          ;mostra string antes de mostrar a quantidade de posições das embarcações que o usuário acertou (total=19)
    PrintaMsg 9


    mov ah,2
    mov dl, quantacertosTotal                         ;imprime a quantidade de acertos até agora
    add dl, 30h
    cmp dl, 39h                                       ;verifica se o número é maior que 9
    jb naosubitrair
    push dx                                           ;guarda o número na pilha
    mov dl, 31h                                       ;imprime o 1 na frente
    int 21h
    pop dx                                            ;volta o número em dx
    sub dl, 10                                        ;remove a dezena
    naosubitrair:                                     ;não é maior, imprime normalmente
    int 21h

    mov dx, offset totaldeposs                        ;mostra o /19 para indicar quantos acertod restam
    PrintaMsg 9

    PulaLinha
    xor cx,cx
    mov dx, offset menleicord                         ;imprime mensagem para o usuário digitar a coordenadas
    PrintaMsg 9

    mov dx, offset menleiletra                        ;imprime mensagem para o usuário digitar a coordenada das colunas (letras)  
    int 21h

    jmp codigonormal
    lerdnovo:
    jmp lerdnovo_ampliado
    codigonormal:

    PrintaMsg 1                                       ;lê um caractere
    cmp al, 60h                                       ;verifica se é menor que 60h, se for, é uma letra maiúscula
    jb maius
    sub al, 61h
    jmp minusc
    maius:
    sub al, 41h                                       ;se for maiuscula, subtrai 41 para as letras ficarem "numeradas" coretamente, A=1, B=2, C=3...               
    minusc:
    and ax, 00ffh                                     ;se for minúscula transforma em numero direto
    mov si, ax                                        ;passa valor numérico para o índice das colunas

    PulaLinha

    mov dx, offset menleinum                          ;pede que o usuário digite a coordenada das linhas (números)
    PrintaMsg 9

    PrintaMsg 1                                       ;lê um caractere
    xor al, 30h                                       ;transforma em número
    mov ch, al                                        ;move para ch
    mov bl, 10                                        ;multiplica o número digitado por 10, para entrada de números superiores a 9
    mul bl
    mov bx, ax                                        ;resultado da multiplicação vai para bx (linhas)
    PrintaMsg 1                                       ;lê segundo dígito            
    and ax, 000fh                                     ;limpa ah            
    mov cl, al                                        ;move número para cl
    add bx, ax                                        ;soma com o bx que foi multiplicado por 10
    mov al, 20                                        ;multiplica por 20 para ir para a linha digitada                      
    mul bx                                            
    mov bx, ax                                        ;move para indice das linhas 

    PulaLinha

    lea dx, optroccord                                ;pergunta se o usuário quer trocar de coordenada   
    PrintaMsg 9

    mov dl,mossL[si]                                  ;mostra as coordenadas atuais
    PrintaMsg 2

    mov dl, ch                                        ;o que está no ch é o primeiro número da coordenada
    add dl, 30h                                       ;transforma em caractere
    int 21h
    mov dl, cl                                        ;o que está no cl é o segundo número da coordenada    
    add dl,30h                                        ;transforma em caractere   
    int 21h
    
    lea dx, contoptroccord                            ;continuação da string
    PrintaMsg 9
    
    PrintaMsg 1                                       ;lê caractere para verificar se o usuário irá trocar
    cmp al, 31h                                       ;se for 1, ele refaz o processo de leitura de coordenada
    je lerdnovo
                                                      ;se não, volta para o procedimento que chamou
    ret
 perguntar_cord endp


 limpar_tela proc
 mov dl, 10                                           ;procedimento para limpar a tela com LF sucessivos
 mov cx, 30                                           ;imprime o enter 30 vezes
 mov ah, 2
 loopdelimpartela:
 int 21h
 loop loopdelimpartela
 ret
 limpar_tela endp


 conferir_disparo proc
   
   PulaLinha

   mov dl, 30h                                         ;move '0' para dl e verifica se a posição da matriz do usuário sofreu disparo  
   cmp matrizshow[bx][si], dl                          ;se for o 0, não é disparo
   jne ja_disparou                                     ;se não for 0, já disparou   

   cmp matriz[bx][si], 0                               ;se esta parte da matriz das embarcações continua sendo 0, errou                                     
   je errou
   

   mov matriz[bx][si], 0                               ;se acertou, move zero parao local da embarcação que sofreu disparo
   mov matrizshow[bx][si],0Fah                         ;move asterisco para a matriz do usuário
   call lim_km_prinn                                   ;imprime a matriz
   lea dx, ma                                          ;informa acerto e pede outra tecla para disparar novamente
   PrintaMsg 9
   
   jmp acertou
   errou:
   mov matrizshow[bx][si],1fh                          ;se errou, move as aspas para a matriz de volta  
   call lim_km_prinn                                   ;imprime a matriz do usuário     
   lea dx, me                                          ;imprime a mensagem de erro  
   PrintaMsg 9                         
   acertou:                                            ;se acertou  

   jmp nao_dsp_ja                                      ;pula para label nao_dsp_ja  

   ja_disparou:
   call lim_km_prinn                                   ;se não for 0, printa a matriz de novo
   lea dx, mj                                          ;mostra mensagem informando que já disparou nesse local           
   PrintaMsg 9                                           
   
   nao_dsp_ja:

   PrintaMsg 1                                         ;lê caractere                                         

   cmp al, 100                                         ;verifica se é o caractere de desistência    
   jne naosub
   sub al, 32                                          ;encerrar antes e aceitar tanto D como d
   naosub:                                            
   cmp al, 68
   jne n_encerrar                                      ;passou pelas duas comparações, não encerra
   
  
   
   mov al, 1                                           ;setando a variável de controle de encerramento como 1  
   
   mov controleEncerrar, al                              ;encerrar
   
   n_encerrar:

   ret


 conferir_disparo endp




 ganhar_jogo proc
 mov ah, 0
 mov quantacertosTotal, ah                               ;a quantidade de acertos total é 0 em um primeiro momento  
 xor bx, bx                                                 
 mov di, 20
 loopconferirganho:                                      ;loop percorrendo a matriz
 mov cx, 20                                              ;loop para as colunas         
 xor si, si
 trocalinhaconferirganho:
 mov ah, matrizshow[bx][si]                              ;coloca elemento da matriz em ah para comparar com o asterisco                                 
 inc si
 cmp ah, 0Fah
 jne naoparaumponto
 push ax                                                 ;se for o asterisco: guarda contéudo de ax na pilha 
 mov ax, 1                                               
 add quantacertosTotal,al                                ;incrementa a variável de quantidade de acertos   
 pop ax
 naoparaumponto:                                         ;se não for asterisco, continua fazendo loop
 loop trocalinhaconferirganho
 add bx, 20
 dec di
 jnz loopconferirganho
 

 ret
 ganhar_jogo endp





 naufragios proc
                                                            ;Recebe a info de qual é o numero da embarcação com Al antes do call
 mov ah, 6                                                  ;a quantidade de naufrágios é 6 no máximo
 mov quantidadenaufragios, ah

                                                            ;mov ah, 6  Haviao
 call confnauplural

 mov ah, 5                                                  ;Hidroavião
 call confnauplural

 mov ah, 4                                                  ;Submarino
 call confnauplural
  
 mov ah, 3                                                  ;Submarino 
 call confnauplural

 mov ah, 2                                                  ;Fragrata
 call confnauplural

 mov ah, 1                                                  ;Encouraçado
 call confnauplural

 ret 
 naufragios endp

 confnauplural proc
 xor bx, bx                                                 ;laço para leitura da matriz
 mov di, 20                                                 ;contador para as linhas      
 laco1:                 
 xor si, si
 mov cx, 20                                                 ;contador para colunos
 laco2:
 cmp matriz[bx][si], ah                                     ;verifica se o elemento é igual ao número da embarcação  
 jne negativo
 mov al, 1                                                  ;se for, subtrai 1 da quantidade de naufrágios (que era 6)
 sub quantidadenaufragios, al
 jmp finalneg
 negativo:
 inc si
 loop laco2
 add bx, 20
 dec di
 jnz laco1


 finalneg:

 ret
 confnauplural endp

 end main