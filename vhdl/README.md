# Laboratório VHDL

Continuação do projeto antigo de circuitos digitais no Logisim. O circuito original `first-version.circ` permanece intacto na raiz do repositório.

## Primeiro experimento: ALU de 4 bits

Uma **ALU** (Arithmetic Logic Unit) recebe dois operandos de 4 bits e escolhe a operação a realizar por meio de 3 bits de controle. É um circuito **combinacional**: não há clock nem memória nesta etapa.

| `op` | Operação | Saída |
| --- | --- | --- |
| `000` | ADD | `(a + b) mod 16` |
| `001` | SUB | `(a - b) mod 16` |
| `010` | AND | `a and b` |
| `011` | OR | `a or b` |
| `100` | XOR | `a xor b` |
| `101` | SHL | `a << 1`, descartando o bit alto |
| `110` | SHR | `a >> 1`, preenchendo com zero |
| `111` | MOV | `a` |

Flags:

- `zero = 1` se o resultado for 0;
- `carry = 1` somente quando ADD ultrapassa 15;
- `borrow = 1` somente quando SUB precisa emprestar (`a < b`);
- para operações lógicas, deslocamentos e MOV, `carry` e `borrow` ficam em 0.

Exemplo: `a = 1111` (15), `b = 0001` (1) e `op = 000` (ADD) produzem `y = 0000`, `carry = 1` e `zero = 1`.

## Rodando no Linux

Instale o [GHDL](https://github.com/ghdl/ghdl), um simulador de VHDL, e o `make`.

No Omarchy/Arch Linux:

```sh
sudo pacman -S ghdl make
```

No Ubuntu/Kubuntu:

```sh
sudo apt install ghdl make
```

Na pasta `vhdl/`:

```sh
make test
```

O testbench verifica **2048 combinações** (8 operações × 16 entradas A × 16 entradas B), incluindo os três flags. Uma falha interrompe a simulação.

Para gerar ondas e inspecioná-las no GTKWave, se instalado:

```sh
make wave
gtkwave alu4.vcd
```

## Estrutura

```text
vhdl/
├── rtl/
│   └── alu4.vhd       # Descrição do circuito
├── tb/
│   └── tb_alu4.vhd    # Simulação e verificações
├── Makefile
└── README.md
```

## Caminho de aprendizado

- [x] ALU combinacional de 4 bits
- [x] Testbench exaustivo e comando de simulação
- [ ] Somador de 1 bit e composição de somadores (entender a ALU por dentro)
- [ ] Registrador com clock e reset
- [ ] Contador síncrono
- [ ] Máquina de estados finitos (FSM)
- [ ] Banco de registradores e barramento
- [ ] CPU didática de 8 bits

**Importante:** VHDL descreve hardware. Instruções concorrentes representam circuitos que atuam ao mesmo tempo. Processos permitem descrever comportamento, mas não significam que todo o hardware execute sequencialmente como um programa comum.

Este laboratório usa VHDL-2008 e não requer FPGA. O teste é por simulação, não por execução em hardware físico.
