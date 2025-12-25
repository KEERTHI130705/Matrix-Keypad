## 6. Software Implementation and Output Verification (Keil Simulation)

This project was implemented and verified **entirely in software** using the **Keil µVision IDE**.  
No external hardware components such as physical keypads, displays, or breadboards were used.

---

### 6.1 Development Environment
- **IDE**: Keil µVision
- **Target Device**: AT89C51 (8051 family)
- **Language**: 8051 Assembly Language
- **Simulation Mode**: Software simulation using Keil debugger

---

### 6.2 Software-Only Verification Approach

Instead of using real hardware, the functionality of the keypad and display was verified using Keil’s **debugging and simulation tools**, such as:
- **Parallel Port Windows (P0, P1)**
- **Internal RAM / Memory Window**
- **Step-by-step execution (Single Step / Run)**

Key presses were simulated by **manually forcing Port 1 values** corresponding to row–column combinations.

---

### 6.3 Verification Steps in Keil

#### Step 1: Initial State Verification
- All ports are initialized to `FFH`.
- Columns (P1.0–P1.3) read `1111b`, indicating **no key pressed**.
- This confirms the idle condition of the keypad.

#### Step 2: Simulating a Key Press
- A key press is simulated by:
  - Driving one row LOW (P1.4–P1.7)
  - Forcing one column LOW (P1.0–P1.3)
- This mimics the electrical connection created when a key is pressed in real hardware.

#### Step 3: Row–Column Detection
- The program identifies:
  - Active row based on which row line is LOW
  - Active column based on which column line is LOW
- The row–column combination is used to index the lookup table.

#### Step 4: ASCII Fetch and Display
- The ASCII value of the pressed key is fetched using:
  - `DPTR` for lookup table base address
  - `MOVC` instruction
- The fetched value is displayed on **Port 0 (P0)** and observed in the Parallel Port window.

---

### 6.4 Memory-Based Result Verification

- Entered digits are stored in internal RAM:
  - **30H** → previous digit (`num2`)
  - **31H** → latest digit (`num1`)
- When the `'+'` key is simulated:
  - The two digits are added
  - Result is stored at **memory location 32H**
  - Result is displayed on **Port 0**

Example:
- If digits `9` and `6` are entered:
  - `30H = 09H`
  - `31H = 06H`
  - On pressing `'+'` → `32H = 0FH`
  - **P0 shows the result in binary**

---

### 6.5 Output Observation in Keil

The following Keil debugger windows were used for verification:
- **Parallel Port 1** → to simulate keypad input
- **Parallel Port 0** → to observe display output
- **Memory Window** → to confirm storage at 30H, 31H, and 32H

This confirms correct implementation of:
- Key detection
- Lookup table access
- Memory storage
- Arithmetic operation

---

## 7. Note on Hardware Usage
This project was intentionally implemented as a **software-verified mini project**.  
The logic, algorithm, and behavior remain identical to a real hardware implementation and can be directly extended to physical components if required.

---
