# Four-Input 8-bit Adder: Unrolled vs Sequential vs Pipelined

Comparison of three hardware architectures that add four 8-bit numbers (a, b, c, d) into a 10-bit output, so the result can never overflow (maximum 4 x 255 = 1020).

- **HDL:** SystemVerilog / Verilog
- **Synthesis:** Quartus Prime Lite 18.1 (Cyclone V, 5CGXFC7C7F23C8), Slow 1100mV 85C model
- **Simulation:** ModelSim with simple directed testbenches
- **Full report:** `Adder_Architectures_Report.docx` (RTL views, waveforms, timing screenshots)

## Architectures

| Architecture | Idea |
|---|---|
| Unrolled (non-pipelined) | Three adders chained combinationally between an input register stage and an output register. One result per clock, but the clock must cover three adders. |
| Sequential | A 2-bit counter and a 4-to-1 mux feed one operand per clock into a single adder and a 10-bit accumulator. Smallest datapath, but 4 cycles per result. |
| Pipelined | Three register stages, one adder per stage (a+b, then +c, then +d). Fastest clock, one result per clock after the pipeline fills. |

## Testbench

Directed tests, each checked against the expected value in the waveform:

| a, b, c, d | Expected out |
|---|---|
| 3, 5, 9, 2 | 19 |
| 1, 1, 1, 1 | 4 |
| 3, 3, 3, 3 | 12 |
| 255, 255, 255, 255 | 1020 |

## Results

### Synthesis

| Architecture | ALMs | Registers | Fmax (MHz) | Clock period (ns) |
|---|---|---|---|---|
| Unrolled | 15 | 42 | 217.06 | 4.607 |
| Sequential | 20 | 12 | 239.12 | 4.182 |
| Pipelined | 15 | 53 | 377.64 | 2.648 |

The unrolled figures are for the final design with registered inputs and output (42 registers = four 8-bit input registers + one 10-bit output register). The first attempt with only the output registered used 11 ALMs and 10 registers.

Resource summary: the sequential design needs the most logic (20 ALMs) but the fewest registers (12). The unrolled and pipelined designs both contain three adders and use the same 15 ALMs; the pipelined design needs 11 more registers (53 versus 42) to carry data between stages.

### Latency and throughput

Latency = clock cycles x clock period. Throughput = Fmax x results per cycle.

| Architecture | Latency (cycles) | Latency (ns) | Results per cycle | Throughput (M results/s) |
|---|---|---|---|---|
| Unrolled | 1 | 4.607 | 1 | 217.06 |
| Sequential | 3 | 12.546 | 1/3 | 79.71 |
| Pipelined | 4 | 10.592 | 1 | 377.64 |

The unrolled design has the lowest latency and the sequential design the highest. The pipelined design has a higher latency than the unrolled one because data passes through every stage, but its fast clock keeps it below the sequential design.

## Key observations

- **Pipelined** has the highest Fmax and the highest throughput for the same 15 ALMs as the unrolled design, at the cost of more registers (53 versus 42).
- **Sequential** uses a single adder but needs the most logic (20 ALMs); it has the highest latency (12.546 ns) and a low throughput (79.71 M results/s) because it produces one result every 3 cycles.
- **Unrolled** is the simplest and has the lowest latency (4.607 ns), but its clock is limited by three chained adders.
- **Fmax is a register-to-register measure.** With only the output registered, Quartus reported "No paths to report" for Fmax. After registering the inputs as well, reg2reg paths existed and Fmax (217.06 MHz) was reported, at a cost of 4 more ALMs and 32 more registers (11 ALMs / 10 registers became 15 ALMs / 42 registers). Input-to-register and register-to-output paths are I/O paths and are not included in Fmax.

## Fixing setup violations (pipelined design)

1. Add a clock constraint (SDC file) on the clk port.
2. Open the Timing Analyzer and run Create Timing Netlist, Read SDC File and Update Timing Netlist.
3. Select the Slow 1100mV 85C model and run the Setup report for clk.
4. Inspect the worst paths (Summary of Paths, Data Path and Waveform tabs): launch/latch relationship, data delay, clock skew and slack.
5. In the first run, the setup slack was -1.648 ns with a 1.000 ns relationship and about 2.4 ns data delay, so all 10 reported paths violated.
6. Apply a realistic clock constraint for a one-adder-per-stage pipeline (3.0 ns in the run shown) and update the timing netlist. Slack became +0.274 ns with 0 violated paths (Fmax 366.84 MHz in that run).
7. Check the multicorner summary: in the final run setup +0.050 ns, hold +0.147 ns, minimum pulse width +0.587 ns, total negative slack 0.0. Final reported Fmax: 377.64 MHz.

## Repository contents

- `Adder_Architectures_Report.docx` - full report with cover page, page numbers and screenshots
- `README.md` - this summary

Made by Engr. Ayat Nauman Khan
