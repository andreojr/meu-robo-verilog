class Test:
    def __init__(self):
        self.output = open("output.txt", "r").readlines()
        self.columns = "ABCDEFGHIJKLMNO"
        self.lines = "01234567"
        self.right_way = ["C3↑", "C2↑", "C1↑", "C1←", "C1↓", "C1→", "D1→", "E1→", "F1→", "G1→", "G1↑", "G1←", "G1↓", "G2↓", "G2→", "H2→", "H2↑", "H2←", "H2↓", "H3↓", "H4↓"]
        initial_pos = [self.col("C"), 3]
        self.cur_pos = initial_pos
        self.looking_for = "↑"
        self.generate_data()

    def col(self, letter):
        return self.columns.find(letter)

    def forward(self):
        next_pos = []
        match self.looking_for:
            case "↑":
                next_pos = [self.cur_pos[0], self.cur_pos[1]-1]
            case "↓":
                next_pos = [self.cur_pos[0], self.cur_pos[1]+1]
            case "←":
                next_pos = [self.cur_pos[0]-1, self.cur_pos[1]]
            case "→":
                next_pos = [self.cur_pos[0]+1, self.cur_pos[1]]
        self.cur_pos = next_pos
    
    def rotate(self):
        match self.looking_for:
            case "↑":
                self.looking_for = "←"
            case "↓":
                self.looking_for = "→"
            case "←":
                self.looking_for = "↓"
            case "→":
                self.looking_for = "↑"

    def generate_data(self):
        self.data = []
        for line in self.output:
            data_line = {}
            line = [arg.strip() for arg in line.split(",")]
            data_line["head"] = int(line[0][-1])
            data_line["left"] = int(line[1][-1])
            data_line["out"] = "frente" if (line[2][-1] + line[3][-1] == "10") else "rotaciona"
            self.data.append(data_line)
    
    def display_position(self):
        return self.columns[self.cur_pos[0]] + self.lines[self.cur_pos[1]] + self.looking_for
    
    def run(self):
        for pos, step in enumerate(self.data):
            if self.display_position() == self.right_way[pos]:
                print(self.display_position()+" OK!")
            else:
                print(self.display_position()+" ERRO! CORRETO: "+self.right_way[pos])
            if step["out"] == "frente":
                self.forward()
            elif step["out"] == "rotaciona":
                self.rotate()
        print()


Test().run()
