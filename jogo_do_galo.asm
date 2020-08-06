	.data
MSG1:   .asciiz "Introduza \n: x - Para pontuar o jogador 1\n: o - Para pontuar o jogador 2\n: p - Imprime o estado do tabuleiro\n: e - Imprime a pontuacao de ambos os jogadores\n: f - Finaliza o prorama\n: j - Jogar novamente\n"
MSG2:	.asciiz "Partidas vencidas pelo jogador 1: "
MSG3:	.asciiz "\nPontuação jogador 1: "
MSG4:	.asciiz "\nPartidas vencidas pelo jogador: "
MSG5:	.asciiz "\nPontuação jogador 2: "

MSG6:	.asciiz "\nTabuleiro cheio, indique qual opção quer tomar \n: 1 - Para pontuar o jogador 1\n: 2 - Para pontuar o jogador 2\n: 3 - Para declarar empate e comecar novo jogo"
MSG7:   .asciiz "\nA posiçao está ocupada ou inseriu uma posicao inválida por favor jogue novamente\n"

tabin: .asciiz "\n | | \n | | \n | | \n"
tabjg: .asciiz "\n | | \n | | \n | | \n"
	.align 2
	.text
	.globl main

main:	
	li $s0,0 			# Partidas vencidas jogador 1=0
 	li $s1,0 			# Partidas vencidas jogador 2=0
 	li $s2,0 			# X=0
 	li $s3,0 			# Y=0
 	li $s4,0 			# Pontuação do jogador 1 =0
 	li $s5,0 			# Pontuação do jogador 2 =0
 	li $s6,0 			# Jogadas=0
 	li $s7,0 			# x ou o, s7=0->x, s7=1->0
 	j jogo
 	
novojogo: 				# Label novo jogo, apaga a matriz
	la $t0,tabin			# Lê para $t0 o tabuleiro inicial
	la $t1,tabjg			# Lê para $t1 o tabuleiro de jogo
	li $s7,0			# Inicializar o $s7 a zero
	li $t3,0			# Inicializar o $t3 a zero
	
loop:					# Label loop que percorre todos os caracteres da matriz e apaga-os
	beq $t3,18,jogo 		# Se $t3 = 18 salta para a label jogo 
	lb $t4, ($t0)			# Vai ao endereço $t1 na posição 0  e faz load do caracter para $t4
	sb $t4, ($t1)			# Guardar o caracter em $t1
	addi $t0,$t0,1			# Adicionar a $t0 1
	addi $t1,$t1,1			# Adicionar a $t1 1
	addi $t3,$t3,1			# Adicionar a $t3 1
	j loop				# Salto para o label loop
jogo:
	beq $s6,9,tabcheio 		# Se $s6 = 9 salta para a label tabcheio (testa se o tabuleiro esta cheio)
 	la $a0,MSG1			# Imprime a mensagem 1
	li $v0,4			# Lê um inteiro
	syscall
	li $v0,12			# Lê um caracter
	syscall
	move $t0,$v0			# Move o caracter de $v0 para o $t0
	li $v0,12			# Lê um caracter
	syscall
	beq $t0,'x',vjogador1		# Se $t0 for igual a 'x' salta para a label vjogador1( onde o jogador 1 é o vencedor )
	beq $t0,'o',vjogador2		# Se $t0 for igual a '0' salta para a label vjogador2( onde o jogador 2 é o vencedor )
	beq $t0,'p',printtab		# Se $t0 for igual a 'p' salta para a label printtab( onde é impressso o tabuleiro atual )
	beq $t0,'e',printpts		# Se $t0 for igual a 'e' salta para a label printpts( onde é impressso os pontos de cada jogador )
	beq $t0,'f',fim			# Se $t0 for igual a 'f' salta para a label fim( acaba o programa )
	beq $t0,'j',novojogo		# Se $t0 for igual a 'j' salta para a label novojogo( onde o tabuleiro antigo é apagado )
	addi $s2,$t0,-48		# Se não entrar numa das labels então o 4s2 fica com o velor de neste caso -48
	li $v0,5			# Lê um inteiro
	syscall
	move $s3,$v0			# Mover o valor lido anteriormente ($v0) para o $s3 (Y) 
	move $a0,$s2 			# Mover o conteúdo de $s2 para $a0 -> x
	move $a1,$s3 			# Mover o conteúdo de $s3 para $a1 -> y
	move $a2,$s6 			# Mover o valor de $s6 para o $a2 -> jogadas
	jal teste1			# Salto para a label testes1
	addi $s6,$s6,1 			# Jogadas ++
	la $t1,tabjg			# Ler endereço do tabuleiro de jogo
	li $t2,6			# Inicializar o $t2 = 6												
	mul $t2,$t2,$s2			# $a0 (linha) x 6 (o tabuleiro de jogo tem 6 colunas) ->primeira posiçao de cada linha do tabuleiro,+1 porque a primeira posiçao é \n
	addi $t2,$t2,1			# Adicionar 1 a $t2
	li $t3,2			# Inicializar o $t3 = 2
	mul $t3,$t3,$s3			# $a1 (coluna) x 2 (numero de caracteres a avançar)-> posiçao na coluna desejada (0x2=0, 1x2=2, 2x2=4)
	add $t2,$t2,$t3			# Depois de somar os dois valores adiciona se ao endereço e temos a posiçao desejada
	add $t1,$t1,$t2			# Adicionar $t1 o valor de $t2
	beq $s7,0,jogarx		# Se $s7 = 0 salta para a label de jogar o jogar 1
	beq $s7,1,jogaro		# Se $s7 = 0 salta para a label de jogar o jogar 2
	
jogarx:					# Jogar o jogador 1
	li $t6, 88			# Inicializar o $t6 = 88 nuúmero em ascci do X
	sb $t6, ($t1)			# Guardar o caracter em $t1
	li $s7,1			# Inicializar o $s7 = 1 (para colocar o 'X' no tabuleiro)
	j printtab			# Salto para a label printtab para a impressão do tabuleiro
	
jogaro:					# Jogar o jogador 2
	li $t6, 79			# Inicializar o $t6 = 79 nuúmero em ascci do Y
	sb $t6, ($t1)			# Guardar o caracter em $t1
	li $s7,0			# Inicializar o $s7 = 0 (para colocar o 'O' no tabuleiro)
	j printtab			# Salto para a label printtab para a impressão do tabuleiro
																
teste1: 				# Se estiver dentro do tabuleiro e a posição estiver vazia j $ra, se nao imprime erro e j JOGO
	blt $a0,$0,falso		# Se $a0 for menor que 0 salta para a label falso
	blt $a1,$0,falso		# Se $a1 for menor que 0 salta para a label falso
	li $t0,2			# Inicializar o $t0 = 2
	bgt $a0,$t0,falso		# Se $a0 for maior que $t0 salta para a label falso
	bgt $a1,$t0,falso		# Se $a1 for maior que $t0 salta para a label falso
	la $t1,tabjg			# O endereço que está em que o tabjg se encontra passa para o $t1 
	li $t2,6			# Inicializar o $t2 = 6												
	mul $t2,$t2,$a0			# a0(linha) x 6(porque temos 6 colunas na matrix tabuleiro)-> primeira posiçao de cada linha da matrix (+1 porque a primeira posiçao é \n)
	addi $t2,$t2,1			# Acionar 1 a $t2
	li $t3,2			# Inicializar o $t3 = 2
	mul $t3,$t3,$a1			# a1(coluna) x 2 (numero de caracteres a avançar)= posiçao na coluna desejada (0x2=0, 1x2=2, 2x2=4)
	add $t2,$t2,$t3			# Depois de somar os dois valores adiciona se ao endereço e temos a posiçao desejada
	add $t1,$t1,$t2			# Acionar a $t1 o $t2
	lb $t4, ($t1)			# Vai ao endereço $t1 na posição 0  e faz load do caracter para $t4															
	bne $t4,' ',falso		# Se $t4 for diferente de ' ' salta para a label falso																					
	jr $ra																						
																								
falso:					# Label falso
	la $a0,MSG7			# Imprimir a mensagem 7
	li $v0,4			
	syscall																									
	j jogo				# Salto para a label jogo
																																																					
tabcheio:				# label tabuleiro cheio
 	la $a0,MSG6			# Imprimir a mensagem 6
	li $v0,4
	syscall
	li $v0,5			# Leitura de um inteiro
	syscall
	move $t0,$v0			# Mover o inteiro lido $v0 para $t0
	beq $t0,1,vjogador1		# Se $t0 for igual a 1 o jogador 1 vence ( salta patra a respetiva label)
	beq $t0,2,vjogador2		# Se $t0 for igual a 2 o jogador 2 vence ( salta patra a respetiva label)
	beq $t0,3,novojogo		# Se $t0 for igual a 3 o jogador 3 vence ( salta patra a respetiva label)
	j tabcheio																																
						
vjogador1:				# Label para atualização dos pontos dos jogadores no caso do jogador 1 ganhe
	addi $s4,$s4,3			# Adicionar 3 pontos ao à pontuação do jogador 1
	addi $s0,$s0,1			# Número de jogadas vencidas do jogador 1 ++
	beq $s5,0,novojogo		# Se a pontuação do jogador 2 for zero salta para a label novo jogo
	addi $s5,$s5,-1			# Subtrair ao jogador 2 1 ponto
	j novojogo			# Salto para a label novo jogo
	
vjogador2:				# Label para atualização dos pontos dos jogadores no caso do jogador 2 ganhe
	addi $s5,$s5,3			# Adicionar 3 pontos ao à pontuação do jogador 2
	addi $s1,$s1,1			# Número de jogadas vencidas do jogador 2 ++
	beq $s4,0,novojogo		# Se a pontuação do jogador 1 for zero salta para a label novo jogo
	addi $s4,$s4,-1			# Subtrair ao jogador 1 1 ponto
	j novojogo			# Salto para a label novo jogo
	
printtab:				# Label para imprimir o tabuleiro
	la $a0,tabjg			
	li $v0,4			
	syscall
	j jogo				# Salto para a label jogo
	
printpts:
	
	la $a0,MSG2			# Imprimir a mensagem 2
	li $v0,4
	syscall
	move $a0,$s0			# Mover o valor de $s0 para $a0
	li $v0,1
	syscall
	la $a0,MSG3			# Imprimir a mensagem 3
	li $v0,4
	syscall
	move $a0,$s1			# Mover o valor de $s1 para $a0
	li $v0,1
	syscall
	la $a0,MSG4			# Imprimir a mensagem 4
	li $v0,4
	syscall
	move $a0,$s4			# Mover o valor de $s4 para $a0
	li $v0,1
	syscall
	la $a0,MSG5			# Imprimir a mensagem 5
	li $v0,4
	syscall
	move $a0,$s5			# Move o falar de $s5 para o $a0
	li $v0,1			# Fazer print do inteiro
	syscall
	j jogo				# Salta para a label jogo

fim:	
	li $v0,10 			# Exit
 	syscall
