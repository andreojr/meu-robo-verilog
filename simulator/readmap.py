import sys, os, time

class ReadMap():
    def __init__(self, mapname, watch):
        # Verifica existência de arquivo do mapa
        self.mapname = mapname
        self.watch = watch
        self.verify_map_exists()
        # Lê arquivo e formata em uma matriz
        self.map = [list(map(self.setmap, row.split())) for row in open(f"{os.getcwd()}/simulator/maps/{mapname}.map").readlines()]
        self.walls_to_paint = []
        self.painted_walls = []
        self.verify_map_is_valid()
        # Verifica se há um robô no mapa e retorna a posição dele
        self.robot_position = self.find_robot()
        self.cur_state = 'searching_wall'
        self.items = ((1, '🟫'), (0, '⬜'), ('^', '⏫'), ('v', '⏬'), ('<', '⏪'), ('>', '⏩'))
        self.entries = []
        self.exits = []

    def error(self, message):
        print(message)
        sys.exit()

    def verify_map_exists(self):
        files = next(os.walk(f'{os.getcwd()}/simulator/maps'))[-1]
        if f'{self.mapname}.map' not in files:
            self.error('Arquivo não encontrado!')

    def setmap(self, item):
        if item in ["1", "0"]:
            return int(item)
        elif item in ["^", "v", "<", ">"]:
            return item
        else:
            self.error('Mapa inválido!')

    def verify_map_is_valid(self):
        rows = len(self.map)

        # Verifica se todas as linhas possuem o mesmo número de colunas
        columns = set(len(row) for row in self.map)
        if len(columns) != 1:
            self.error('Há colunas inconsistentes no mapa!')
        columns = list(columns)[0]

        for i, row in enumerate(self.map):
            for j, value in enumerate(row):
                if (i == 0 or i == rows - 1 or j == 0 or j == columns - 1) and value != 1:
                    self.error('Mapa sem bordas!')
                if self.map[i][j] == 1 and ((i != 0 and not self.map[i-1][j]) or (i != rows - 1 and not self.map[i+1][j]) or (j != 0 and not self.map[i][j-1]) or (j != columns - 1 and not self.map[i][j+1])):
                    self.walls_to_paint.append((i,j))

    def find_robot(self):
        robot_count = 0
        i = 0; j = 0; k = ''
        for idx, row in enumerate(self.map):
            for symbol in '<>^v':
                if symbol in row:
                    robot_count += 1
                    if robot_count > 1:
                        self.error('Não é permitido vários robôs no mapa!')
                    i = idx
                    j = row.index(symbol)
                    k = symbol

        if not robot_count:
            self.error('Robô não encontrado!')
        return [i, j, k]

    def route(self):
        sensors = self.sensors_status()
        self.entries.append(f'{sensors[0]} {sensors[1]}\n')
        if (self.cur_state == 'reset_route'):
            self.cur_state = 'searching_wall'
        elif (self.cur_state == 'searching_wall' and sensors[0] == 1) or (self.cur_state == 'following_wall' and sensors == (1,1)):
            self.cur_state = 'rotating'
        elif (self.cur_state == 'searching_wall' and sensors == (0,1)) or (self.cur_state == 'rotating' and sensors == (0,1)):
            self.cur_state = 'following_wall'
        elif self.cur_state == 'following_wall' and sensors[1] == 0:
            self.cur_state = 'reset_route'

    def act(self):
        if self.cur_state == 'searching_wall' or self.cur_state == 'following_wall':
            self.exits.append('1 0\n')
            self.forward()
        elif self.cur_state == 'rotating' or self.cur_state == 'reset_route':
            self.exits.append('0 1\n')
            self.rotate()

    def forward(self):
        self.map[self.robot_position[0]][self.robot_position[1]] = 0
        match self.robot_position[2]:
            case "^":
                self.robot_position[0] = self.robot_position[0] - 1
            case "v":
                self.robot_position[0] = self.robot_position[0] + 1
            case "<":
                self.robot_position[1] = self.robot_position[1] - 1
            case ">":
                self.robot_position[1] = self.robot_position[1] + 1
        self.map[self.robot_position[0]][self.robot_position[1]] = self.robot_position[2]

    def rotate(self):
        match self.robot_position[2]:
            case "^":
                self.robot_position[2] = "<"
            case "v":
                self.robot_position[2] = ">"
            case "<":
                self.robot_position[2] = "v"
            case ">":
                self.robot_position[2] = "^"
        self.map[self.robot_position[0]][self.robot_position[1]] = self.robot_position[2]

    def paint(self, x, y):
        if (x,y) in self.walls_to_paint:
            self.walls_to_paint.remove((x,y))
            self.painted_walls.append((x,y))

    def front_sensor(self):
        x = self.robot_position[0]; y = self.robot_position[1]
        match self.robot_position[2]:
            case "^":
                x = self.robot_position[0] - 1; y = self.robot_position[1]
            case "v":
                x = self.robot_position[0] + 1; y = self.robot_position[1]
            case "<":
                x = self.robot_position[0]; y = self.robot_position[1] - 1
            case ">":
                x = self.robot_position[0]; y = self.robot_position[1] + 1

        self.paint(x, y)
        return self.map[x][y]

    def left_sensor(self):
        x = self.robot_position[0]; y = self.robot_position[1]
        match self.robot_position[2]:
            case "^":
                x = self.robot_position[0]; y = self.robot_position[1] - 1
            case "v":
                x = self.robot_position[0]; y = self.robot_position[1] + 1
            case "<":
                x = self.robot_position[0] + 1; y = self.robot_position[1]
            case ">":
                x = self.robot_position[0] - 1; y = self.robot_position[1]

        self.paint(x, y)
        return self.map[x][y]


    def sensors_status(self):
        return (self.front_sensor(), self.left_sensor())

    def clear(self):
        os.system('clear')

    def render_map(self):
        self.clear()
        for i, row in enumerate(self.map):
            line = ''
            for j, value in enumerate(row):
                for key, icon in self.items:
                    if value == key:
                        if key == 1 and (i,j) in self.painted_walls:
                            line += '🟩'
                        else:
                            line += icon
            print(line)
        time.sleep(.2)

    def run(self):

        while len(self.walls_to_paint) > 0:
            self.route()
            self.act()
            if self.watch:
                self.render_map()
        with open(f'{os.getcwd()}/simulator/maps/current.map.entries', 'w') as f:
            f.writelines(self.entries)
        with open(f'{os.getcwd()}/simulator/maps/current.map.exits', 'w') as f:
            f.writelines(self.exits)

if len(sys.argv) == 2:
    mapname = sys.argv[1]
    ReadMap(mapname, False).run()
elif len(sys.argv) == 3 and sys.argv[1] in ['-w', '--watch']:
    mapname = sys.argv[2]
    ReadMap(mapname, True).run()
else:
    print('Comando inválido!')
