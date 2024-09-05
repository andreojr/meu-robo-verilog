from numpy import random
import cuid, os

r = random.choice(range(5, 20))
c = random.choice(range(5, 20))

M = []
for i in range(r):
    row = []
    for j in range(c):
        if i == 0 or j == 0 or i == r - 1 or j == c - 1:
            row.append(1)
        else:
            border = min(i, j, r - i - 1, c - j - 1)
            if border > 0:
                odds = 0
                match border:
                    case 1:
                        odds = 0.5
                    case 2:
                        odds = 0.2
                num = random.random()
                row.append(0 if num > odds else 1)
    M.append(row)

empty_positions = [[i, j] for i in range(len(M)) for j in range(len(M[0])) if M[i][j] == 0]
if not empty_positions:
    raise ValueError("Não há posições disponíveis sem parede.")
for i, j in empty_positions:
    if M[i-1][j] and M[i+1][j] and M[i][j-1] and M[i][j+1]:
        M[i][j] = 1
        empty_positions.remove([i,j])
    elif not M[i-1][j] and not M[i+1][j] and not M[i][j-1] and not M[i][j+1]:
        M[i][j] = 0
        empty_positions.append([i,j])

init = empty_positions[random.choice(list(range(len(empty_positions))))]
M[init[0]][init[1]] = random.choice(["^", "v", "<", ">"])

mapname = cuid.cuid()
print(mapname)
with open(f'{os.getcwd()}/simulator/maps/{mapname}.map', 'w') as f:
    M = [' '.join(map(str, m)) + '\n' for m in M]
    f.writelines(M)
