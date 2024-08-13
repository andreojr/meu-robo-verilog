### Projeto de Robô Mealy e Moore com Contador Divisor de Frequência

Este repositório contém um projeto para simulação e teste de um robô baseado em máquinas de estados Mealy e Moore, com um contador divisor de frequência. O projeto inclui tanto a parte de hardware descrita em Verilog quanto uma parte destinada a simulação e visualização em Python.

## Estrutura do Repositório

### Diretório `modules`

- **`mealy.v`**: Módulo Verilog que implementa a máquina de estados Mealy do robô.
- **`moore.v`**: Módulo Verilog que implementa a máquina de estados Moore do robô.
- **`counter.v`**: Módulo Verilog que funciona como um divisor de frequência para o robô.

### Diretório `simulator`

- **`accuracy.py`**: Script Python para renderizar as saídas do testbench do robô em um mapa para visualização do caminho percorrido.
- **`compile.py`**: Script Python para compilar o código Verilog e rodar o simulador com base nas saídas do testbench para testar o robô.

### Arquivos Principais

- **`design.v`**: Módulo Verilog principal que integra o divisor de frequência com o robô.
- **`testbench.v`**: Testbench Verilog que envia diferentes sinais para o robô e verifica as saídas.

## Como Executar o Projeto

### Compilação e Simulação

## EDA Playground

O testbench, ambos os robôs e o divisor de frequência podem ser compilados pelo EDA Playground. O código de cada máquina pode ser acessado clicando nos links abaixo:

- [mealy](https://edaplayground.com/x/HfDh);
- [moore](https://edaplayground.com/x/UTnR).

## Executando na sua máquina

1. Certifique-se de ter o Icarus Verilog instalado.
- [Link para download do Icarus Verilog no Windows](https://bleyer.org/icarus/iverilog-v12-20220611-x64_setup.exe)
- Utilize o seguinte comando para instalar o Icarus Verilog no Linux:
    
    ```bash
    sudo apt-get install verilog
    ```
    
1. Use o script `compile.py` para compilar o código Verilog e rodar a simulação.
    
    ```bash
    python simulator/compile.py
    ```
