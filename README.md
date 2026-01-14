# Intelligent Traffic Light Control System using Zynq-7000 FPGA

## 📖 Overview

This project implements an **Adaptive Traffic Light Control System** based on **Heterogeneous Computing** principles using the Xilinx Zynq-7000 SoC (Zybo Z7-20 development board). 

Unlike traditional traffic lights with fixed timers, this system dynamically adjusts the green light duration based on real-time traffic density. The core innovation lies in its **Hardware-Software Co-design architecture**:
* **Software (PS):** Handles data acquisition, signal filtering ("Smart Filter"), and user interface.
* **Hardware (PL):** Executes a custom **Fuzzy Logic Accelerator** and the Traffic Light Finite State Machine (FSM) for high-speed, deterministic decision-making.

## 🚀 Key Features

* **Hardware Acceleration:** Custom VHDL IP Core that implements Fuzzy Logic (Fuzzification, Inference, Defuzzification using Centroid Method) directly in the FPGA fabric.
* **Smart Signal Processing:** A software-based history filter (`val = 0.2*new + 0.8*old`) to stabilize sensor readings and remove noise.
* **Multiplexed Control:** Manages two independent traffic flows (North-South & East-West) using a single analog sensor via time-division multiplexing.
* **Safety Critical Design:** Hardware-enforced minimum safety times and a priority "Night Mode" (Yellow Blink) hard-wired in the FSM.
* **Real-time Interactive Shell:** Serial terminal interface (UART) to toggle modes and visualize system decisions in real-time.

## 🛠️ System Architecture

The system utilizes the Zynq-7000 AP SoC architecture:

1.  **Processing System (PS - ARM Cortex-A9):**
    * Reads analog values from Potentiometers via **XADC**.
    * Applies the "Smart Filter" algorithm.
    * Sends processed data to the FPGA via **AXI GPIO**.
    * Communicates with the PC via UART (115200 baud).

2.  **Programmable Logic (PL - FPGA):**
    * **Fuzzy Accelerator IP:** Receives traffic density (0-4095) and outputs optimal time (5s - 30s).
    * **Traffic Light Controller:** A Finite State Machine (FSM) driving the physical LEDs.
    * **Interconnect:** AXI4-Lite bus for PS-PL communication.

## 🧠 Fuzzy Logic Implementation

The decision engine is not a simple threshold check. It uses Fuzzy Logic to map input traffic to output time:

* **Inputs:** Traffic Density (0 to 4095).
* **Fuzzy Sets:** *Small* (Trapezoidal), *Medium* (Triangular), *Large* (Trapezoidal).
* **Rules:**
    * IF Traffic is Small THEN Time is 5s.
    * IF Traffic is Medium THEN Time is 18s.
    * IF Traffic is Large THEN Time is 30s.
* **Defuzzification:** Weighted Average (Centroid Method) calculated in hardware.

## 🔧 Hardware Setup

* **Board:** Digilent Zybo Z7 (Zynq-7000).
* **Input:** Potentiometer connected to Pmod Port JA (Pin VAUX14).
* **Controls:**
    * `SW[0]`: Night Mode (Yellow Blink).
    * `SW[1]`: Select Direction to Edit (DOWN = North-South, UP = East-West).
* **Output:** On-board LEDs representing the traffic lights.

## 💻 Software & Tools

* **Vivado 2024.x:** For VHDL synthesis, Block Design, and Bitstream generation.
* **Vitis Unified IDE 2024.x:** For C application development (Bare-metal driver).
* **Terminal:** Vitis Serial Terminal or HTerm.

## 📥 How to Run

1.  **Hardware Generation:**
    * Open the `.xpr` project in Vivado.
    * Generate Bitstream.
    * Export Hardware (`.xsa` file) including bitstream.
2.  **Software Deployment:**
    * Open Vitis Unified IDE and create a platform from the `.xsa`.
    * Create a "Hello World" or "Empty Application" project.
    * Import the `main.c` source code from `src/`.
    * Build the project.
3.  **Execution:**
    * Connect the Zybo board via USB.
    * Open Vitis Serial Terminal (**Baud Rate: 115200**).
    * Right-click project -> *Run As* -> *Launch on Hardware*.

## 🎮 Usage Guide (Terminal)

Once the application is running, the UART terminal will display the system status.

* **Mode Selection:**
    * Press **`0`**: **Direct Mode** (Raw sensor data sent to FPGA). Instant response.
    * Press **`1`**: **Smart Mode** (Filtered data sent to FPGA). Smooth, realistic response.
* **Observation:**
    * Rotate the potentiometer to simulate traffic.
    * Watch the calculated time change non-linearly (S-Curve) in the logs.
    * Flip `SW[0]` to test interrupt priority (Night Mode).

```text
--- Example Terminal Output ---
[EDIT: NS] [HW+SMART] InputFPGA_NS:3971 (~30s) | LED:0x2
[EDIT: NS] [HW+SMART] InputFPGA_NS:1856 (~16s) | LED:0x2
[EDIT: NS] [HW+SMART] InputFPGA_NS: 776 (~ 9s) | LED:0x1
