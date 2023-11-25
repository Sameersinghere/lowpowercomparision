# lowpowercomparision
This Repo contains my codes for my project on Comparative study on low power techniques
Low Power techniques:

1. Clock Gating:
    - Definition: Clock gating is a technique used to save power by turning off the clock to certain parts of a circuit when they are not in use. By "gating" the clock, one can stop the clock signal from reaching specific parts of a design, preventing unnecessary switching activity and thereby saving dynamic power.
    - **How it Works**: It involves the use of control logic to enable or disable clock signals to specific parts of a design based on the system's operational mode or requirements. For instance, if a module doesn't need to operate, its clock can be gated off.
    - **Use Cases**: It's particularly effective in digital designs where certain components or subsystems are idle for significant periods. Examples include inactive units in microprocessors or unused peripherals in SoCs.

2. Power Gating:
    - Definition: Power gating is a technique used to reduce leakage power by turning off the power supply to sections of a chip that are not in use. This is done using special transistors known as "header" or "footer" switches.
    - How it Works: Power gating introduces 'sleep transistors' that disconnects specific portions of the design from the power supply (or ground) when not in use. When a block is power-gated, it goes into a low-power state and retains no data. Upon 'waking up', it usually requires a reset or reinitialization.
    - **Use Cases**: Ideal for scenarios where certain blocks can remain inactive for extended durations. Examples include shutting off power to certain processor cores in multi-core designs when they aren't needed.

3. Dynamic Voltage Scaling (DVS):
    - Definition: DVS is a power management technique where the voltage supplied to a device is dynamically adjusted in real-time based on system requirements. The aim is to provide just enough voltage for the device to meet its performance requirements, thus saving power.
    - How it Works: DVS systems typically have a feedback mechanism where the performance or load of a system is monitored. Depending on the performance requirements, the supply voltage is adjusted. This often works in tandem with Dynamic Frequency Scaling (DFS), where both voltage and frequency are adjusted simultaneously.
    - Use Cases: Used widely in processors for laptops and mobile devices, where performance needs can vary dramatically based on user activity (e.g., idle vs. gaming).

Differences:

- Operational Level: 
    - Clock gating deals with the toggling activity (dynamic power) and operates by controlling the clock signal.
    - Power gating deals primarily with leakage power (static power) and operates by shutting off power supply.
    - DVS operates by adjusting the supply voltage based on performance needs.
    
- Power Savings:
    - Clock gating saves dynamic power but doesn't help with static or leakage power.
    - Power gating aims to save leakage power.
    - DVS can save both dynamic and static power by reducing the voltage.
