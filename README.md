@ ACTIVITY-AWARE REVERSIBLE ALU WITH GARBAGE-LINE REUSE: 16-BIT FPGA IMPLEMENTATION WITH 8-BIT OPERAND EVALUATION

@@ Overview
This project implements a reversible Arithmetic Logic Unit (ALU) optimized using:
- Activity-aware gating
- Garbage-line reuse

The objective is to reduce unnecessary switching activity and improve reversible resource efficiency while preserving reversibility.

---------------

>> Features
= Supported Operations
- ADD
- SUB
- AND
- OR
- XOR

>> Optimization Techniques
- Arithmetic/logic selective gating
- Garbage output reuse
- Reduced ancilla input dependency

---------------

>> Design Versions
This repository contains the final optimized version:
- Combined Gating + Reuse Architecture

---------------

>> Tools Used
- Verilog HDL
- Vivado 2024.1
- Xcelium
- FPGA Target: Artix-7

---------------

>> Key Results

| Metric       | Value     |
============================
| LUTs         | 79        |
| Delay        | 19.429 ns |
| Logic Levels | 10        |  
| Timing Slack | 0.546 ns  |

---------------

>> Included Files

| File                                 | Description                      |
===========================================================================
| `both_revalu.v`                      | Main reversible ALU design       |
| `both_revalu_tb.v`                   | Testbench for simulation         |
| `switching_both_8.txt`               | 8-bit switching activity report  |
| `switching_both_16.txt`              | 16-bit switching activity report |
| `timing_both_20ns.txt`               | Timing analysis report           |
| `util_both.txt`                      | FPGA utilization report          |
| `REV_ALU_both 8 Bit Simulation.png`  | 8-bit waveform output            |
| `REV_ALU_both 16 Bit Simulation.png` | 16-bit waveform output           |
| `REV_ALU_both 8 bit Power.png`       | 8-bit power analysis             |
| `REV_ALU_both 16 bit Power.png`      | 16-bit power analysis            |

---------------

>> Project Goal
- Inactive reversible ALU blocks can be selectively gated to reduce switching activity
- Garbage outputs can be reused as helper inputs instead of introducing fresh ancilla inputs
- Reversible optimization introduces trade-offs between power efficiency, area, and timing

---------------

>> Author
Shoban Raj Sivakumar
