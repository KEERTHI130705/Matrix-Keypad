# 4×4 Matrix Keypad Based Calculator Using 8051

## 1. Introduction
This mini project demonstrates the implementation of a **4×4 matrix keypad–based calculator** using the **8051 microcontroller (AT89C51)**.  
The system detects key presses using **row–column scanning**, identifies the pressed key through a **lookup table**, displays the corresponding ASCII value via **Port 0**, and stores digits in internal memory.

When the **‘+’ key** is pressed, the last two entered digits are added, and the result is displayed and stored in memory.

---

## 2. Hardware Mapping and Keypad Layout

### 2.1 Port Assignments

#### Rows (Configured as Output)
- Row 0 → **P1.4**
- Row 1 → **P1.5**
- Row 2 → **P1.6**
- Row 3 → **P1.7**

#### Columns (Configured as Input)
- Column 0 → **P1.0**
- Column 1 → **P1.1**
- Column 2 → **P1.2**
- Column 3 → **P1.3**

---

### 2.2 Keypad Layout (Row–Column Mapping)

| Row / Column | Col 0 | Col 1 | Col 2 | Col 3 |
|--------------|-------|-------|-------|-------|
| **Row 0**    | 0     | 1     | 2     | 3     |
| **Row 1**    | 4     | 5     | 6     | 7     |
| **Row 2**    | 8     | 9     | A     | B     |
| **Row 3**    | C     | D     | E     | +     |

Each key is mapped to its **ASCII value**, stored in a lookup table in program memory.

---

## 3. Working Principle of a Matrix Keypad

A matrix keypad arranges keys in a grid of rows and columns.  
When a key is pressed, it creates an electrical connection between one row and one column.

### Key Detection Process:
1. Activate one row at a time by driving it **LOW**.
2. Read the column inputs.
3. If any column reads **LOW**, a key press is detected.
4. The active row and detected column together identify the pressed key.
5. The corresponding ASCII value is fetched from the lookup table.

---

## 4. Detailed Algorithm

### Step 1: Idle Check
- The microcontroller waits until **no key is pressed**.
- All column inputs read `1111b`, indicating idle state.

---

### Step 2: Wait for Key Press
- Columns are continuously monitored.
- If any column bit becomes **LOW**, a key press is detected.

---

### Step 3: Row Scanning
- Rows are activated one at a time:
  - One row is set **LOW**.
  - Remaining rows are kept **HIGH**.
- If a column reads **LOW**, the active row corresponds to the pressed key.

---

### Step 4: Column Identification
The pressed column is identified as:
- Column 0 → **P1.0 LOW**
- Column 1 → **P1.1 LOW**
- Column 2 → **P1.2 LOW**
- Column 3 → **P1.3 LOW**

The column number acts as an offset in the lookup table.

---

### Step 5: Fetch ASCII Using Lookup Table
- **DPTR** is loaded with the base address of the lookup table.
- **MOVC** instruction fetches the ASCII value of the pressed key.

---

### Step 6: Processing the Key

#### Numeric Keys (0–9)
- ASCII value is converted to its numeric equivalent.
- Values are stored as:
  - `num1` → latest digit
  - `num2` → previous digit

#### ‘+’ Key
- The program performs:
  - `result = num1 + num2`
- The result:
  - Is displayed on **Port 0**
  - Is stored at internal memory location **32H**

---

### Step 7: Display on Port 0
- The ASCII value or arithmetic result in the accumulator is transferred to **P0** for display.

---

## 5. Conclusion
This project demonstrates the practical implementation of a keypad interface with the 8051 microcontroller, covering **row–column scanning**, **lookup table usage**, **ASCII handling**, and **basic arithmetic operations**.  
It serves as a strong foundation for understanding human–machine interfacing using microcontrollers.

---

