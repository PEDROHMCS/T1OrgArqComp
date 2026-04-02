	.data
	.align 2
	ptr_head: .word 0 #ponteiro para o no head (locomotiva)
	.align 2
	next_id: .word 2 #contador para IDs
	
	#outputs da interface
	msg_encontrado: .asciz "Vagao encontrado!\n"
	msg_nao_encontrado: .asciz "Vagao nao encontrado.\n"
	msg_printID: .asciz "ID do vagão: \n"
	msg_printCOD: .asciz "Codigo do vagao: \n"
	
	.text
	.align 2
	.globl main

main:
	#inicializar o trem (cria a locomotiva)
	jal ra, construtor
	
	# input dos vagï¿½es
	
	
	
	
	addi a7, zero, 10
	ecall

construtor:
	# Alocar 12 bytes na memoria dinamica para o no=
	# 4 bytes para o ID;
	# 4 bytes para string do tipo (3 caracteres e \0);
	# 4 bytes para o ponteiro do proximo 
	addi a7, zero, 9
	addi a0, zero, 12
	ecall
	
	# definir valores padroes do no
	sw zero, 0(a0) # define o ID para 0
	sw zero, 8(a0) # define o ponteiro do prï¿½ximo para 0
	
	# Definir o endereï¿½o para onde ptr_head vai apontar 
	la t1, ptr_head
	sw a0, 0(t1) # ptr_head aponta para o espaï¿½o na heap que a0 guarda
	
	# Voltar para a main
	jalr zero, 0(ra)

# ================ INSERÇÃO ====================		
new_no:
	# Argumentos esperados
	# a0 = Tipo do vagï¿½o

	add t4, zero, a0 # guarda o tipo do vagï¿½o no registrador temporï¿½rio
	
	# Alocar os bytes na heap
	addi a7, zero, 9
	addi a0, zero, 12
	ecall
	
	# Ler o valor do Id atual e escrever na heap
	la t1, next_id # t1 recebe o endereï¿½o de next_id
	lw t3, 0(t1) # t3 recebe o valor do id atual
	sw t3, 0(a0) # escreve o valor do id atual nos 4 primeiros bytes
	
	# Incrementar valor do next_Id
	addi t3, t3, 1 # incrementa o id para o prï¿½ximo nï¿½
	sw t3, 0(t1) # atualiza o valor de next_id
	
	# Escrever o tipo do vagï¿½o na heap
	sw t4, 4(a0) # escreve o tipo do vagï¿½o nos bytes 4 - 7
	sw zero, 8(a0) # escreve o valor 0 nos bytes do ponteiro para o prï¿½ximo vagï¿½o
	
	la t1, ptr_head # t1 recebe o endereï¿½o de ptr_head
	lw t0, 0(t1) # t0 recebe o conteï¿½do de head
	# programa entra na funï¿½ï¿½o de busca do ï¿½ltimo nï¿½

search_last:
	lw t1, 8(t0) # t1 lï¿½ o ponteiro para o prï¿½ximo nï¿½ do vagï¿½o atual
	
	# Verificar se o valor ï¿½ 0 (se sim, significa que ï¿½ o ï¿½ltimo vagï¿½o)
	beq t1, zero, link_no
	
	# Se nï¿½o for zero, percorre a lista
	add t0, t1, zero #t0 recebe o endereï¿½o guardado no ponteiro para o prï¿½ximo vagï¿½o
	jal zero, search_last

link_no:
	# Guardar o endereï¿½o do nï¿½ atual no ponteiro do anterior
	sw a0, 8(t0)
	
	# Retornar para a main
	jalr zero, 0(ra)
	
# ================ REMOÇÃO ====================
	
remove_no:
	add t0, a0, zero # Copia o id que queremos apagar para t0
	
	# t1 armazena o endereÃ§o da locomotiva
	la t1, ptr_head
	lw t1, 0(t1)
	
	# Se a lista estiver vazia t1 == 0, nÃ£o faz nada
	beq t1, zero, fim_remove
	
	#t2 le o id da locomotiva, se o que o usuario digitou for da locomotiva
	lw t2, 0(t1)
	beq t0, t2, fim_remove

remove_busca:
	#t1 Ã© o anterior e t2 Ã© o atual
	
	# t2 recebe o endereÃ§o do proximo vagao
	lw t2, 8(t1)
	
	# Se t2 for zero, Ã© o fim do trem e o ID nao existe
	beq t2, zero, fim_remove
	
	# ID do vagÃ£o atual que esta em t2, Ã© colocado em t3
	lw t3, 0(t2)
	
	# Se o id a ser apagado for igual ao atual, executamos a remocao
	beq t3, t0, remove_executa
	
	# caso nao, continuamos na busca recursiva, e t1(anterior), passa a ser o t2(atual)
	add t1, t2, zero
	jal zero, remove_busca

remove_executa:
	# t4, armazena o endereco do vagao depois do que serÃ¡ removido agora
	lw t4, 8(t2)
	sw t4, 8(t1)

fim_remove:
	jalr zero, 0(ra)

# ================ BUSCA ====================

busca_por_id:	
	#a0 = id de busca
	# copia o id que o usuario quer buscar
	add t0, a0, zero
	
	# carrega o endereco de ptr_head no registrador t1
	la t1, ptr_head
	
	lw t1, 0(t1)
	
loop_busca:
	#compara o t1 com zero, se for igual nao achamos o vagao, salta pra nao achou
	beq t1, zero, nao_achou
	
	## armazena o id do vagao
	lw t2, 0(t1)
	
	# verifica se o id do vagao e igual ao do t0, que o usuario ta buscando
	beq t2, t0, achou
	
	# le o endereco no deslocamento 8, ponteiro pro proximo e atualiza o proprio t1 com esse endereco
	lw t1, 8(t1)
	
	# retorna a fazer o loop
	jal zero, loop_busca

achou:
	# codigo 4 no a7 Ã© para avisar o sistema que queremos imprimir texto
	addi a7, zero, 4
	# carrega o endereco do texto em a0
	la a0, msg_encontrado
	# executa
	ecall
	
	#retorna para a main
	jalr zero, 0(ra)

nao_achou:
	# codigo 4 no a7 Ã© para avisar o sistema que queremos imprimir texto
	addi a7, zero, 4
	# carrega o endereco do texto em a0
	la a0, msg_nao_encontrado
	# executa
	ecall
	
	#retorna para a main
	jalr zero, 0(ra)

# ================ EXIBIÇÃO ====================

printTrain:
	# Inicia a partir do começo da lista (locomotiva)
	la t1, ptr_head
	lw t0, 8(t1) # t1 recebe o valor do ponteiro para o próximo vagão

loop_printTrain:
	# Verificar se o valor do ponteiro é 0 (se sim, significa que é o último vagão)
	beq t0, zero, fim_printTrain
	
	# Se não for o final do trem, imprime os campos
	# Imprime o texto de ID do vagão
	addi a7, zero, 4
	la a0, msg_printID
	ecall
	
	#Imprime o ID do vagão
	lw t2, 0(t0)
	add a0, zero, t2
	addi a7, zero, 1
	ecall
	
	# Imprime o texto de código do vagão
	addi a7, zero, 4
	la a0, msg_printCOD
	ecall
	
	#Imprime o código do vagão
	addi a0, t0, 4 #passa o endereço do byte 4
	addi a7, zero, 4
	ecall
	
	#Vai para o próximo vagão
	lw t0, 8(t0)
	jal zero, loop_printTrain

fim_printTrain:
	# retorna para a main
	jalr zero, 0(ra)