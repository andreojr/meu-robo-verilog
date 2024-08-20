import os, sys, platform
rm, sep = ["del", "\\"] if platform.system() == "Windows" else ["rm", "/"]; args = len(sys.argv); py = sys.executable

path = 'simulator'
machines = ['mealy', 'moore']

def define_machine(machine):
    design = 'design.v'
    content = open(design).read()
    content = content.replace(machines[int(not machines.index(machine))], machine)
    open(design, 'w').write(content)

def run(machine):
    define_machine(machine)
    cmd = ' && '.join([
        f'iverilog -o {path}{sep}output .{sep}testbench.v',
        f'vvp {path}{sep}output > {path}{sep}output.csv',
        f'{rm} {path}{sep}output',
        f'{py} {path}{sep}accuracy.py',
    ])
    os.system(cmd)

if args == 2:
    machine = sys.argv[1]
    run(machine)
else:
    machine = input('Qual máquina quer testar? [mealy/moore] ')
    if machine not in machines:
        print("A máquina informada não é válida!")
        sys.exit()
    print(f'Carregando teste para máquina de {machine}...')
    run(machine)
