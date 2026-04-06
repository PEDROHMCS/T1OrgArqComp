# Relatório de Desenvolvimento: Projeto Montagem de Trem 

## 1. Breve Descrição do Programa

O projeto **"Montagem de Trem"** é uma aplicação interativa desenvolvida inteiramente em Assembly RISC-V. O simulador permite a gestão de uma composição ferroviária através de operações em baixo nível, lidando diretamente com a manipulação de endereços, registradores e chamadas de sistema.

### 1.1. Estrutura de Dados
Para representar o trem, o programa implementa uma **Lista Encadeada (Linked List)** com alocação dinâmica de memória na *Heap*. A estrutura foi projetada da seguinte forma:
* **Locomotiva (Nó Cabeça / *Head*):** É o ponto de partida fixo da lista, inicializado logo na abertura do programa.
* **Vagões (Nós da Lista):** Cada vagão adicionado representa um nó na lista e possui um espaço reservado na memória para armazenar três informações principais:
    * Um **ID único** sequencial auto-incrementado.
    * O **Tipo** de vagão (carga, passageiros, etc.).
    * O **Ponteiro** para o próximo elemento, garantindo o "engate" com o vagão sucessor.

### 1.2. Funcionalidades Principais
O usuário interage com o programa através de um console de linha de comando, que possibilita as seguintes operações:
* **Navegação e Interface:** Um menu interativo que recebe o *input* do usuário e executa uma das funções.
* **Inserção:** Adicionar novos vagões no início do trem (logo após a locomotiva) ou no final.
* **Busca e Exibição:** Busca iterativa da lista encadeada, permitindo tanto exibir o trem inteiro quanto localizar os dados de um vagão específico usando seu ID.
* **Remoção:** Remoção de vagões do meio ou do fim da lista, realizando a reconexão dos ponteiros dos vagões vizinhos para evitar perda de referência na memória.

---

## 2. Relatos dos Alunos

### Pedro Marques - 16819166
Minha principal responsabilidade no projeto foi a implementação das operações de busca e remoção de vagões específicos (`buscar_por_id` e `remover_por_id`). O maior aprendizado durante o processo foi compreender gestão de memória em Assembly, especialmente a diferença entre ler o conteúdo de um nó (como o seu ID) e manipular o seu endereço de memória (ponteiro). Para a funcionalidade de remoção, fiz a busca com dois ponteiros simultâneos (vagão atual e vagão anterior) para realizar o "desengate" com segurança, garantindo que o vagão anterior passasse a apontar para o sucessor do nó removido. Também adaptei a lógica de busca iterativa utilizando registradores temporários.

### Mariane Ferreira - 16840035
Fiquei responsável pela arquitetura central do programa, atuando diretamente na função `main` e na interação com o usuário. Implementei a interface do sistema criando um menu de navegação, onde gerenciei a leitura das opções inseridas e manipulei os saltos (`jal` / `jalr`) para as respectivas funções desenvolvidas pela equipe. Estruturei o fluxo de controle do programa utilizando instruções de desvio condicional, como os *branches* (`beq`), garantindo que o programa tomasse as decisões corretas com base no input. Além disso, gerenciei as chamadas de sistema (`ecall`) para a exibição de todas as mensagens de interface. O maior problema foi garantir a execução correta do fluxo da aplicação, conectando a entrada do usuário às operações de memória sem quebrar a lógica do sistema.

### Pablo Viera - 16895429
Minha colaboração envolveu as operações de inserção de novos vagões (tanto no início quanto no final do trem) e a função de exibição da lista completa. A inserção exigiu o desenvolvimento de laços de repetição para percorrer a lista a partir da locomotiva, avaliando as condições de parada dinamicamente (identificando ponteiros nulos para inserção no fim, ou o nó adjacente à cabeça para o início) e reajustando os engates. A função de exibição reutilizou essa lógica de travessia para ler e imprimir os dados iterativamente. O principal obstáculo enfrentado foi estruturar a manipulação segura dos registradores dentro dos loops, além de consolidar o entendimento técnico e prático sobre a diferença entre acessar a coordenada de um endereço na memória e manipular o valor armazenado nele.