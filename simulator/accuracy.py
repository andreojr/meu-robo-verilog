import os
import sys
import csv
import time
import platform

class Accuracy:
    def __init__(self):
        self.UP = "\x1B[99A"
        self.CLR = "\x1B[0K"
        self.fail = None
        self.output_path = "simulator/output.csv"
        self.columns = "ABCDEFGHIJKLMNO"
        self.lines = "01234567"
        self.walls = ["A0","B0","C0","D0","E0","F0","G0","H0","I0","A1","H1","I1","A2","I2","A3","E3","F3","G3","I3","J3","K3","L3","M3","N3","O3","A4","E4","G4","I4","O4","A5","B5","C5","D5","E5","G5","N5","O5","E6","J6","K6","N6","E7","F7","G7","H7","I7","J7","K7","L7","M7","N7"]
        initial_pos = [self.col("C"), 3]
        self.cur_pos = initial_pos
        self.looking_for = "⏫"
        self.head = "C2"
        self.left = "B3"
        self.painted_walls = []
        self.generate_data()

    def col(self, letter):
        return self.columns.find(letter)

    def clear(self):
        os.system("cls" if platform.system() == "Windows" else "clear")

    def forward(self):
        next_pos = []
        match self.looking_for:
            case "⏫":
                next_pos = [self.cur_pos[0], self.cur_pos[1] - 1]
            case "⏬":
                next_pos = [self.cur_pos[0], self.cur_pos[1] + 1]
            case "⏪":
                next_pos = [self.cur_pos[0] - 1, self.cur_pos[1]]
            case "⏩":
                next_pos = [self.cur_pos[0] + 1, self.cur_pos[1]]
        self.cur_pos = next_pos

    def rotate(self):
        match self.looking_for:
            case "⏫":
                self.looking_for = "⏪"
            case "⏬":
                self.looking_for = "⏩"
            case "⏪":
                self.looking_for = "⏬"
            case "⏩":
                self.looking_for = "⏫"

    def front_sensor(self):
        self.head = None
        match self.looking_for:
            case "⏫":
                self.head = self.columns[self.cur_pos[0]] + self.lines[self.cur_pos[1] - 1]
            case "⏬":
                self.head = self.columns[self.cur_pos[0]] + self.lines[self.cur_pos[1] + 1]
            case "⏪":
                self.head = self.columns[self.cur_pos[0] - 1] + self.lines[self.cur_pos[1]]
            case "⏩":
                self.head = self.columns[self.cur_pos[0] + 1] + self.lines[self.cur_pos[1]]
        return int(self.head in self.walls)

    def left_sensor(self):
        self.left = None
        match self.looking_for:
            case "⏫":
                self.left = self.columns[self.cur_pos[0] - 1] + self.lines[self.cur_pos[1]]
            case "⏬":
                self.left = self.columns[self.cur_pos[0] + 1] + self.lines[self.cur_pos[1]]
            case "⏪":
                self.left = self.columns[self.cur_pos[0]] + self.lines[self.cur_pos[1] + 1]
            case "⏩":
                self.left = self.columns[self.cur_pos[0]] + self.lines[self.cur_pos[1] - 1]
        return int(self.left in self.walls)

    def generate_data(self):
        self.data = []
        finish = "$finish" in open(self.output_path).readlines()[-1]
        with open(self.output_path, "r", encoding='utf-8') as file:
            reader = csv.reader(file, delimiter=",")
            reader = list(reader)[0:-1] if finish else reader
            for row in reader:
                data_line = {}
                data_line["head"] = int(row[0][-1])
                data_line["left"] = int(row[1][-1])
                out = row[2][-1] + row[3][-1]
                if out == "10":
                    data_line["out"] = "frente"
                elif out == "01":
                    data_line["out"] = "rotaciona"
                else:
                    data_line["out"] = "ambígua"
                self.data.append(data_line)

    def display_position(self):
        return (
            self.columns[self.cur_pos[0]]
            + self.lines[self.cur_pos[1]]
            + self.looking_for
        )

    def render(self):
        coord = self.display_position()[0:2]
        direction =self.display_position()[-1]
        output = f"{self.UP}"
        for i in self.lines:
            line = []
            for j in self.columns:
                track = f"{j}{i}"
                if track in self.walls and track == coord:
                    line.append("💢")
                    self.fail = "O robô bateu no muro!"
                elif track in self.walls and track in self.painted_walls:
                    line.append("🟩")
                elif track in self.walls:
                    line.append("🟫")
                elif track == coord:
                    line.append(direction)
                else:
                    line.append("⬜️")
            for l in line:
                output += l
            output += f"{self.CLR}\n"
        print(output)

    def move(self, step):
        if step["out"] == "frente":
            self.forward()
        elif step["out"] == "rotaciona":
            self.rotate()
        else:
            self.fail = "Saída ambígua!"

    def verify_exception(self):
        if self.fail:
            print(f'\nFalha: {self.fail}', end=f"{self.CLR}\n")
            sys.exit()

    def track_sensors(self):
        print(f"Head: {self.front_sensor()}", end=f"{self.CLR} ")
        print(f"Left: {self.left_sensor()}", end=f"{self.CLR}\n")

    def paint_wall(self):
        if self.left_sensor():
            if self.left == "C0" and self.left in self.painted_walls:
                sys.exit()
            self.painted_walls.append(self.left)

    def run(self):
        self.clear()

        for step in self.data:
            time.sleep(0.1)
            self.move(step)
            self.render()
            self.verify_exception()
            self.track_sensors()
            self.paint_wall()
            print(step, end=f"{self.CLR}\n")
Accuracy().run()
