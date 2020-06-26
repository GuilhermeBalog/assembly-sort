# 1- Ler arquivo
# 2- Salvar caracteres do arquivo em array
# 3- Percorrer array transformando caracteres em inteiros
# 4- Mnadar array para o bubble sort
# 5- Printar array ordenado

.data  
antes:			.asciiz "\n\n-------- Numeros antes da Ordenacao --------\n\n"
ordenado:		.asciiz "\n\n--------     Numeros Ordenados      --------\n\n"

meuArquivo: 	.asciiz "numbers.txt" 	# nome do arquivo
buffer: 		.space 4096				# buffer que armazena o arquivo		
vetor:			.word 10				# vetor a ser ordenado

.text

# Abrir arquivo para leitura

li $v0, 13          					# system call pra abrir arquivo
la $a0, meuArquivo  					# input do nome do arquivo
li $a1, 0           					# flag pra leitura
li $a2, 0           					# mode is ignored
syscall               					# abre o arquivo

move $s0, $v0         					# save the file descriptor 


# Lendo do arquivo aberto

li   $v0, 14        					# system call pra ler do arquivo
move $a0, $s0       					# file descriptor 
la   $a1, buffer    					# address of buffer from which to read
li   $a2,  50       					# hardcoded buffer length
syscall             					# ler do arquivo


# Exibindo o conteudo do arquivo

li $v0, 4					
la $a0, antes
syscall

li $v0, 4          						# system call pra PRINT STRING
la $a0, buffer     						# buffer contains the values
syscall             					# print a string

la $a0, buffer 							# load byte space into address
move $t0, $a0 							# save string to t0


# Armazenando o conteúdo do arquivo no vetor

addi  $t1, $0, 0  						# i = 0 (indice no buffer)
sw $zero, vetor($t1)					# vetor[i] = 0

percorre:
	lb  $a0, ($t0)						# carrega o caracter atual
	beq $a0, 0, fimpercorre				# termina se está no fim 
	
	move $t2, $a0						# move o caracter para $t2

	sub $t4, $t2, 48					# converte para inteiro
	
	beq $t4, -16, proximo				# se é um espaço, pula pro próximo
	beq $t4, -38, proximo				# se é uma quebra de linha, pula pro próximo
	
	# Tratamento de mais de um dígito

	lw $t5, vetor($t1)					# carrega o valor atual do vetor em $t5
	
	mul $t5, $t5, 10					# multiplica o valor na posicao $t1 por 10
	add $t4, $t4, $t5					# salva t4 como a soma t4 + t5
	
	sw  $t4, vetor($t1)					# salva o valor no vetor

	addi  $t0, $t0, 1 					# incrementa indice do buffer

	j percorre							# faz o loop

proximo:
    addi  $t0, $t0, 1 					# incrementa indice do buffer
    addi  $t1, $t1, 4					# incrementa indice no vetor
    
	sw $zero, vetor($t1)				# inicializa como zero antes de usar
    
    j percorre							# faz o loop
    
fimpercorre:        


# Ordenação com Bubble Sort

addi $t0, $0, 0
addi $t3, $0, 4 
addi $t7, $0, 4							# t7 = 4

for1:
	slti $t1, $t0, 10					# $t1 = i <= 10
	beq	 $t1, $0, fimfor1				# Se for falso, pula para fimfor1
	addi $t2, $t0, 1 					# j = i + 1

	for2: 
		slti $t3, $t2, 10				# $t3 = j <= 10
		beq	 $t3, $0, fimfor2			# Se for falso, pula para fimfor2
		mul  $t4, $t7, $t0				# Indice I
		mul	 $t5, $t7, $t2				# Indice J
		lw	 $s1, vetor($t4)			# vetor[i]
		lw	 $s2, vetor($t5)			# vetor[j]

		if1:
			sgt	$t6, $s1, $s2			# (vetor[i] > vetor[j])
			beq	$t6, $0, fimif1
			add	$t6, $s1, $0			# aux = vetor[i]
			add	$s1, $s2, $0			# vetor[i] = vetor[j]
			add	$s2, $t6, $0			# vetor[j] = aux
			sw	$s1, vetor($t4)			# salva vetor[i] na memoria
			sw	$s2, vetor($t5)			# salva vetor[j] na memoria
		fimif1:
			addi $t2, $t2, 1			# j++
			j	 for2

	fimfor2:
		addi $t0, $t0, 1				# i++
		j 	 for1

fimfor1:


# Exibindo o vetor ordenado 

li $v0, 4					
la $a0, ordenado
syscall

addi $t0, $0, 0							# i = 0
addi $t3, $0, 4							# t3 = 4

forimprimir:
	
	slti $t1, $t0, 10					# (i < 10)
	beq	 $t1, $0, fimforimprimir
	mul	 $t2, $t0, $t3					# Indice I
	
	lw	 $a0, vetor($t2)				# vetor[i]
	li	 $v0, 1	
	syscall
	
	li 	 $v0, 11					
	la	 $a0, 32						# Imprimi " " na tela
	syscall								# Chamada do Sistema 
	
	addi $t0, $t0, 1					# i++
	j	 forimprimir
fimforimprimir:


# Fim do programa

termina:
	li $v0, 10
	syscall

