module testbench;
    // Variáveis para gerenciar os arquivos
    integer entries, exits;
    reg scan_entries, scan_exits;
    // Clocks
    reg  initial_clk;
    wire clk;
    // Entradas
    reg h, l;
    reg f_expected, r_expected;
    // Saídas
    wire f_mealy, r_mealy;
    wire f_moore, r_moore;
    // Definindo frequência como o maior número da matrícula
    parameter clk_freq = 7;
    // Simulando alternância de sinal do clock a cada instante
    always #1 initial_clk = ~initial_clk;
    // Instaciando a máquina de Mealy, passando os parâmetros necessários
    mealy #(clk_freq) mealy (
        initial_clk,
        clk,
        h,
        l,
        f_mealy,
        r_mealy
    );
    // Instaciando a máquina de Moore, passando os parâmetros necessários
    moore #(clk_freq) moore (
        initial_clk,
        clk,
        h,
        l,
        f_moore,
        r_moore
    );
    // Inicializando Clock e abrindo os Arquivos de E/S
    initial begin
        initial_clk = 1'b0;
        entries = $fopen("../simulator/maps/current.map.entries", "r");
        exits = $fopen("../simulator/maps/current.map.exits", "r");
    end

    always @(posedge clk) begin
        /* A cada instante de clock, um linha de cada arquivo é lida,
        definindo as entradas e as saídas esperadas */
        #2 begin
            scan_entries <= $fscanf(entries, "%d %d\n", h, l);
            scan_exits   <= $fscanf(exits, "%d %d\n", f_expected, r_expected);
        end
        /* A simulação é finalizada quando a leitura
        de ambos os arquivos é finalizada */
        if ($feof(entries) && $feof(exits)) #200 $finish;
    end
endmodule
