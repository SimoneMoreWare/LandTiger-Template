# LandTiger ARM Cortex-M3 Peripheral Template

This repository provides a ready-to-use template for quickly working with the peripherals of the LandTiger development board based on the ARM Cortex-M3 (LPC1768). It includes modular drivers, practical examples, and an organized structure for embedded projects.

## Why use it?
- Accelerate development with the LandTiger board.  
- Organize embedded projects in a modular and reusable way.  
- Access working examples for quick testing and implementation.  

## Academic Context  
This repository is designed to support coursework and projects for the following courses at Politecnico di Torino:  
- **Architetture dei Sistemi di Elaborazione** (course code: 02GOLOV).  
- **Computer Architecture** (English version of the same course).  

The template provides practical tools to simplify development with the LandTiger board, helping students focus on learning core concepts in embedded systems.  

## Landtiger NXP LPC1768
The code is written for the *Landtiger NXP LPC1768* used in Politecnico. <br/>
Meaningful informations about the chip composition:
- **ARM 32-bit Cortex-M3** microcontroller with MPU, CPU clock up to 100MHz
- 512kB on-chip Flash ROM
- 4x 32-bit Timers and a Repetitive Interrupt Controller 
- 64kB RAM, Nested Vectored Interrupt Controller
- Power Management Unit and Wakeup Interrupt Controller
The IDE used to develop this project is [Keil uVision](https://www2.keil.com/mdk5/uvision/).

## Project Structure


```
LandTiger_LPC1768
├── startup_file
│   └── startup_LPC17xx.s          # Startup assembly file for LPC1768
├── main
│   ├── sample.c                   # Main example (system_init, button_init, etc.)
│   ├── sample.h                   
│   ├── function.c                 # Utility C functions (e.g., extract_bits)
│   ├── function.h                 
│   ├── utils.c                    # Additional exam-specific utilities
│   └── utils.h                    
├── lib_SoC_board
│   └── system_LPC17xx.c           # SoC-level configuration (e.g., clock frequency)
├── led
│   ├── funct_led.c                # High-level LED control
│   ├── lib_led.c                  # Low-level LED library
│   └── led.h                      
├── button_EINT
│   ├── button.h                   # Button initialization and definitions
│   ├── IRQ_button.c               # Button interrupt handlers
│   └── lib_button.c               # Low-level button library
├── RIT
│   ├── irq_rit.c                  # Repetitive Interrupt Timer IRQ handler
│   ├── lib_RIT.c                  # Low-level RIT library
│   └── RIT.h                      
├── joystick
│   ├── joystick.h                 # Joystick initialization and definitions
│   └── lib_joystick.c             # Low-level joystick library
├── ASM
│   └── AMS_funcs.s                # Useful Assembly functions
└── timer
    ├── IRQ_timer.c                # Timer interrupt handlers
    ├── lib_timer.c                # Low-level timer library
    └── timer.h                    # Timer initialization and definitions
```
---

### Functions Available

1. **`unsigned short extract_bits(unsigned int value, int start, int end)`**

   Extracts bits from a 32-bit value between two specified indices.
   
   **Parameters:**
   - `value` (unsigned int): The 32-bit value from which the bits will be extracted.
   - `start` (int): The starting index of the bit range to extract (0 to 31).
   - `end` (int): The ending index of the bit range to extract (0 to 31).

   **Returns:**
   - An unsigned short (16 bits) containing the extracted bits.

   **Description:**
   This function extracts the bits from a specified range (from `start` to `end`) within a 32-bit integer. It performs bitwise operations to create a mask, isolating the desired bits, and then shifts the result to align with the least significant bits.

---

2. **`void represent_on_leds(unsigned int res, int position)`**

   Represents a 32-bit value on LEDs, displaying 8 bits at a time, starting from the least significant byte.
   
   **Parameters:**
   - `res` (unsigned int): The 32-bit value to be displayed on the LEDs.
   - `position` (int): The byte position (0 to 3) to display.
     - `0`: Least significant byte (LSB).
     - `1`: Second byte, etc.

   **Returns:**
   - None (the output is directly sent to the LEDs).

   **Description:**
   This function takes a 32-bit value and displays it on the LEDs, 8 bits at a time. It extracts one byte from the value based on the specified `position` (0 to 3) and outputs the extracted byte to the LEDs.

---

### LED Management Functions

#### **`void LED_init(void)`**

Initializes the LEDs and turns them off.

**Description:**
This function configures the GPIO pins for the LEDs (P2.0 to P2.7) as output and initializes them to be off. It also sets the `led_value` to 0.

---

#### **`void LED_On(unsigned int num)`**

Turns on the requested LED.

**Parameters:**
- `num` (unsigned int): The LED number to turn on (0 to 7).

**Description:**
This function turns on the LED corresponding to the given `num` by setting the corresponding bit in the GPIO output register.

---

#### **`void LED_Off(unsigned int num)`**

Turns off the requested LED.

**Parameters:**
- `num` (unsigned int): The LED number to turn off (0 to 7).

**Description:**
This function turns off the LED corresponding to the given `num` by clearing the corresponding bit in the GPIO output register.

---

#### **`void LED_Out(unsigned int value)`**

Outputs a 32-bit value to the LEDs, turning them on or off based on the value.

**Parameters:**
- `value` (unsigned int): A 32-bit value where each bit represents the state of an LED (1 for on, 0 for off).

**Description:**
This function iterates through all 8 LEDs and turns them on or off based on the corresponding bits in the `value`.

---

#### **`void LED_Out_reverse(unsigned int value)`**

Outputs a 32-bit value to the LEDs in reverse order.

**Parameters:**
- `value` (unsigned int): A 32-bit value where each bit represents the state of an LED (1 for on, 0 for off).

**Description:**
This function iterates through the LEDs in reverse order (from the most significant to the least significant) and turns them on or off based on the corresponding bits in the `value`.

---

#### **`void LED_OnAll(void)`**

Turns on all LEDs.

**Description:**
This function turns on all 8 LEDs by calling `LED_On()` for each one.

---

#### **`void LED_OffAll(void)`**

Turns off all LEDs.

**Description:**
This function turns off all 8 LEDs by calling `LED_Off()` for each one.

---

#### **`void LED_Out_Range(unsigned int value, uint8_t from_led_num, uint8_t to_led_num)`**

Outputs a 32-bit value to a range of LEDs, from `from_led_num` to `to_led_num`.

**Parameters:**
- `value` (unsigned int): A 32-bit value where each bit represents the state of an LED.
- `from_led_num` (uint8_t): The starting LED number (0 to 7).
- `to_led_num` (uint8_t): The ending LED number (0 to 7).

**Description:**
This function allows you to control a specific range of LEDs. It turns each LED on or off based on the corresponding bits in the `value`.

---

### Button Management Functions

#### **`void BUTTON_init(void)`**

Initializes the buttons and configures interrupts.

**Description:**
This function configures the pins for the buttons as input, sets up external interrupts for the buttons, and enables them in the NVIC (Nested Vectored Interrupt Controller) with appropriate priority levels. It ensures that the pins are correctly mapped to external interrupts for each button and sets the pin direction to input.

---

#### **Interrupt Handlers**

These functions handle the button press interrupts.

1. **`void EINT0_IRQHandler(void)`**

   **Description:**
   Handles the interrupt for Button 0 (INT0). When the button is pressed, the `down_0` flag is set to 1, and the interrupt for Button 0 is disabled. It also clears the pending interrupt.

2. **`void EINT1_IRQHandler(void)`**

   **Description:**
   Handles the interrupt for Button 1 (KEY1). When the button is pressed, the `down_1` flag is set to 1, and the interrupt for Button 1 is disabled. It also clears the pending interrupt.

3. **`void EINT2_IRQHandler(void)`**

   **Description:**
   Handles the interrupt for Button 2 (KEY2). When the button is pressed, the `down_2` flag is set to 1, and the interrupt for Button 2 is disabled. It also clears the pending interrupt.

---

### Global Variables for Debouncing

- **`extern int down_0;`**
- **`extern int down_1;`**
- **`extern int down_2;`**

These global variables are used to manage the debouncing process. They are set to 1 when the corresponding button is pressed and the interrupt is handled. These flags allow the program to detect button presses after debouncing.

---

### lib_RIT.c - Description

This file contains functions to manage the RIT (Repetitive Interrupt Timer) on the LPC17xx microcontroller. These functions are typically used for setting up periodic timers and handling interrupts for time-sensitive operations.

---

### **Functions in lib_RIT.c**

1. **`void enable_RIT(void)`**

   **Description:**
   Enables the Repetitive Interrupt Timer (RIT) by setting the corresponding bit in the `RICTRL` register.

   **Parameters:**
   - None

   **Returned value:**
   - None

2. **`void disable_RIT(void)`**

   **Description:**
   Disables the Repetitive Interrupt Timer (RIT) by clearing the corresponding bit in the `RICTRL` register.

   **Parameters:**
   - None

   **Returned value:**
   - None

3. **`void reset_RIT(void)`**

   **Description:**
   Resets the RIT counter by setting the `RICOUNTER` register to 0.

   **Parameters:**
   - None

   **Returned value:**
   - None

4. **`uint32_t init_RIT(uint32_t RITInterval)`**

   **Description:**
   Initializes the RIT with a specified interval (`RITInterval`). It configures the clock, enables power to the RIT, and sets up the match value and control register for the timer. It also enables the interrupt and sets the priority.

   **Parameters:**
   - `RITInterval`: The interval at which the RIT interrupt should trigger.

   **Returned value:**
   - `0` (success)

5. **`unsigned int get_RIT_value(void)`**

   **Description:**
   Retrieves the current value of the RIT counter.

   **Parameters:**
   - None

   **Returned value:**
   - The current value of the `RICOUNTER` register.

---

### **Overview of RIT Usage**

- **Enabling and Disabling RIT:**
   The `enable_RIT` and `disable_RIT` functions allow for enabling and disabling the RIT for periodic interrupts.
  
- **Initializing RIT:**
   The `init_RIT` function is used to set up the RIT with a specific interval, enabling it and setting up the interrupt with priority.

- **Resetting and Monitoring the RIT Counter:**
   The `reset_RIT` function resets the counter, and the `get_RIT_value` function reads the current value of the timer, which can be used to determine elapsed time.

---

### IRQ_RIT.c - Description

The IRQ_RIT.c file you provided is for handling the Repetitive Interrupt Timer (RIT) interrupts on an LPC17xx microcontroller, specifically dealing with multiple button and joystick inputs. Here's a breakdown of what the code does and some key elements:

### Overview
The code is managing multiple input buttons and joystick directions using RIT interrupts, with specific checks for short and long presses. It includes functions to handle both the press and release of each button or joystick action.

### Key Sections
1. **Global Variables**:  
   - Several `volatile` variables are defined to manage debouncing and track the states of different buttons and joystick directions. These variables include `down_0`, `down_1`, `down_2`, `J_up`, `J_down`, and joystick directional variables such as `J_up_left`, `J_up_right`, etc.
   
2. **Interrupt Handling**:  
   The `RIT_IRQHandler()` function is the main handler for the RIT interrupt. The interrupt is triggered periodically, and the function checks the status of various buttons and joystick inputs:
   - **Button checks (INT0, KEY1, KEY2)**: For each button, the code checks if the button is pressed or released. When a button is pressed, it counts the number of times the interrupt occurs to determine if it is a short or long press. For long presses, the `long_press_count_1` constant determines the duration.
   - **Joystick Directional Checks**: There are similar checks for joystick directions like UP, DOWN, LEFT, RIGHT, as well as diagonals (UP-LEFT, UP-RIGHT, DOWN-LEFT, DOWN-RIGHT). These checks use the state of GPIO pins to detect joystick movements.
   - **Joystick Click**: The click action is also handled, where the GPIO pin corresponding to the joystick click is checked for a press.

3. **Press Handling**:  
   For each button and joystick direction, the code checks if the button is pressed (`FIOPIN` value) and counts the number of interrupts to differentiate between short and long presses. Each action has a specific case for handling the press event, and if the press is released, additional code can be added for release management.

4. **Resetting the Interrupt Flag**:  
   The RIT interrupt flag is cleared with the command:  
   ```c
   LPC_RIT->RICTRL |= 0x1; /* clear interrupt flag */
   ```
   This ensures the interrupt is acknowledged and cleared before returning from the handler.

### Notes:
- **Debouncing**: The code uses a simple counter (`down_0`, `down_1`, `down_2`, etc.) to debounce the button presses. This ensures that multiple presses are not falsely registered.
- **Interrupts and GPIO Pins**: The code handles external interrupts (INT0, KEY1, KEY2) using GPIO pin checks and manipulates the `PINSEL` registers for configuring the pin function.
- **Joystick Direction Management**: Each direction of the joystick is checked with a combination of GPIO pins. The joystick is treated as a directional input, and the various cases handle each direction and click independently.

### Potential Improvements:
- **Long Press Handling**: The code provides placeholders for long press actions, but specific actions for long presses need to be added where indicated (`// your code here (for long press)`).
- **Code Modularity**: The `switch` statements for short and long presses can be modularized into separate functions for cleaner code and easier management.
- **Interrupt Enabling/Disabling**: The enabling and disabling of interrupts are done manually in the code. It might be more efficient to manage these interrupts in a centralized way to avoid redundant code.

This setup is designed for embedded systems where quick and reliable input handling is critical, particularly in embedded applications such as control systems or user interfaces.

---

The joystick initialization code you provided sets up four buttons (up, down, left, right) and one click functionality on the joystick, configuring them as input pins on the GPIO ports of the LPC17xx microcontroller. Each button's respective pin is set to GPIO mode and marked as an input. Here's a brief breakdown of what's happening in the code:

1. **Joystick Up**:
   - Pin P1.29 is set to GPIO mode.
   - P1.29 is configured as an input.

2. **Joystick Right (dx)**:
   - Pin P1.28 is set to GPIO mode.
   - P1.28 is configured as an input.

3. **Joystick Left (sx)**:
   - Pin P1.27 is set to GPIO mode.
   - P1.27 is configured as an input.

4. **Joystick Down**:
   - Pin P1.26 is set to GPIO mode.
   - P1.26 is configured as an input.

5. **Joystick Clicked**:
   - Pin P1.25 is set to GPIO mode.
   - P1.25 is configured as an input.

### Key functions:
- `LPC_PINCON->PINSEL3 &= ~(3<<xx);` – This sets the respective pins to GPIO mode by clearing the relevant bits in the PINSEL register.
- `LPC_GPIO1->FIODIR &= ~(1<<xx);` – This configures the pins (P1.25, P1.26, etc.) as inputs.

---

### lib_timer.c - Description

The provided code is for managing timers on an LPC17xx microcontroller (likely using the ARM Cortex-M3 or M4 architecture). It contains functions for enabling, disabling, resetting, initializing, and toggling timers, as well as managing their behavior through the match control register (MCR). These timers are typically used for scheduling and time-based events in embedded systems.

Here's a brief breakdown of the key functions in the code:

### 1. **enable_timer()**
   - Activates the specified timer by setting its Timer Control Register (TCR) to 1.
   - It supports timers 0 through 3 on the LPC17xx microcontroller.

### 2. **disable_timer()**
   - Deactivates the specified timer by setting its TCR to 0, essentially stopping the timer.
   
### 3. **reset_timer()**
   - Resets the specified timer by setting the reset bit (bit 1) in its TCR to 1.
   - This function is used to reset the timer, which can be useful when reconfiguring or restarting the timer.

### 4. **init_timer()**
   - Initializes the timer with specific parameters like the prescaler, match register, and match interval.
   - It also configures the timer's behavior by setting the match control register (MCR) to determine whether the timer will trigger interrupts, reset itself, or stop when a match occurs.

### 5. **toggle_timer()**
   - Toggles the state of a timer (enabling it if it's disabled, or disabling it if it's enabled).
   - This function inverts the value of the timer's TCR, effectively enabling or disabling the timer.

### 6. **Match Control Register (MCR)**
   - The code contains detailed explanations about how to configure the MCR, which controls the timer's behavior when it reaches a match value.
   - It offers several configurations: generating an interrupt, resetting the timer, stopping the timer, and more, depending on the combination of flags (MR0I, MR0R, MR0S).

### 7. **Interrupt Configuration**
   - The `init_timer` function enables timer interrupts and sets the priority for each timer's interrupt request (IRQ).
   - This allows the microcontroller to respond to timer events by triggering interrupt service routines (ISR).

### 8. **Prescaler**
   - The prescaler value is used to slow down the timer clock by dividing it, which is important for generating specific time intervals.
   
This code is quite typical for embedded systems programming, where hardware timers are used to manage delays, periodic events, and real-time tasks. The LPC17xx is a popular family of microcontrollers for such tasks, and the timers are critical for precise control in embedded systems.

---

### IRQ_timer.c - Description

This code defines interrupt service routines (ISR) for four timer modules (Timer 0, Timer 1, Timer 2, Timer 3) in the LPC17xx microcontroller. Each timer module can generate interrupts based on the match register values, and the code handles these interrupts by checking the interrupt flags and clearing them accordingly. Here's an explanation of the key components:

### Key Features:
1. **Timer Interrupt Handlers:**
   - Each timer module (TIMER0, TIMER1, TIMER2, and TIMER3) has an interrupt handler function (e.g., `TIMER0_IRQHandler`) that gets triggered when the corresponding timer generates an interrupt.
   
2. **Interrupt Flag Checking and Clearing:**
   - Inside each ISR, the interrupt flags for the match registers (MR0, MR1, MR2, MR3) are checked using bitwise AND operations (`&`).
   - If a specific match register interrupt flag is set, the interrupt is handled, and the corresponding interrupt flag is cleared by writing the flag value to the interrupt flag register (e.g., `LPC_TIM0->IR = 1` for clearing MR0 interrupt on Timer 0).

3. **Code Structure:**
   - The ISRs follow a similar structure for each timer. For each match register (MR0 to MR3), if an interrupt occurs, the code clears the interrupt flag by writing to the interrupt flag register (`IR`).
   
### Areas for Customization:
- **Your code section:** Each ISR has a comment `// your code`, where specific functionality can be added for each match register interrupt. This is where user-defined actions should be implemented for each interrupt event (e.g., toggling LEDs, updating counters).

### Example Workflow for Timer0:
- If Timer0 generates an interrupt for MR0 (i.e., `LPC_TIM0->IR & 1`), the interrupt flag for MR0 is cleared by writing `LPC_TIM0->IR = 1`, and then any additional code can be added to handle the MR0 event.
  
### Usage:
- These interrupt handlers are typically used for managing time-based tasks such as controlling periodic events, generating PWM signals, or other time-sensitive operations. The actions performed within these ISRs are dependent on the application requirements.

---

### ASM_functs.s

The assembly code you provided contains several functions written in ARM assembly, primarily for processing integer arrays and performing bit-level operations. Here's a summary of the various functions:

1. **`asm_funct`**: This function appears to be a placeholder, saving registers to the stack and restoring them at the end. It doesn't seem to perform any meaningful operation in the current code snippet.

2. **`bsort`**: Implements a **Bubble Sort** algorithm to sort an array of integers. It uses registers to manipulate the array, compares adjacent elements, and swaps them if necessary. The algorithm continues to loop through the array until no more swaps are made.

3. **`my_division`**: A wrapper for the ARM **`__aeabi_fdiv`** function, which performs division on floating-point numbers. It saves the registers, loads the operands into registers, calls the division function, and restores the registers. The result is stored in register `R0`.

4. **`call_svc`**: This function seems to be a placeholder for a system call (`SVC` instruction). It saves the registers, sets up the system call address in `R0`, and then triggers the system call with `SVC 0x15`.

5. **`count_leading_zero`**: This function counts the number of leading zeros in the integer stored in `R0`. It uses the **`CLZ`** instruction, which counts the number of leading zeros in a register.

6. **`count_bit1`**: This function counts the number of `1` bits in a given integer. It shifts the integer left, checks for a carry (`ADDCS`), and decrements the bit count until all bits are processed.

7. **`get_max`**: This function finds the maximum value in an array of integers. It loads the first element as the initial maximum and then iterates over the array, updating the maximum value whenever a larger element is found.

8. **`get_min`**: Similar to `get_max`, this function finds the minimum value in an array of integers. It starts with the first element as the minimum and iterates over the array, updating the minimum whenever a smaller element is found.

9. **`is_monotonic_increasing`**: This function checks whether a given array of integers is monotonically increasing. It compares each element of the array with the next one and returns 1 (true) if the array is monotonically increasing, otherwise it returns 0 (false).

10. **`module`**: This function performs integer division. It calculates the quotient and the remainder when dividing two integers. The result is returned in register `R0` as the remainder.

11. **`abs_value`**: This function calculates the absolute value of the difference between two integers. It compares `R0` and `R1`, and if `R0` is less than `R1`, it swaps the values, then subtracts to compute the absolute difference.

12. **`Prime_or_Not`**: This function checks if a given number is prime. It iteratively divides the number by integers starting from 2. If no division results in a remainder of zero, the number is considered prime, otherwise, it is not.

13. **`DIVISION`**: A sub-function used in `Prime_or_Not`, it performs division through successive subtraction, which essentially mimics division using a loop.

14. **`next_state`**: This function computes the next state of a linear feedback shift register (LFSR). It uses taps (specified positions in the register) and the current state to calculate the output bit and the next state.

15. **`value_is_in_a_range`**: This function checks if a given value is within a specified range. It compares the value with the minimum and maximum values and returns 1 if the value is within the range, otherwise returns 0.

16. **`brianKernighan`**:
   - **Description**: This function counts the number of bits set to 1 in a given integer using Brian Kernighan's algorithm.
   - **Usage**: The number to process is passed in `r0`, and the result (count of 1 bits) is returned in `r0`.

17. **`isPrime`**:
   - **Description**: Checks if a given number is prime using a linear algorithm. It iteratively tests divisibility of the number by all integers greater than 1 and less than the number itself.
   - **Usage**: The number to check is passed in `r0`, and `1` is returned if prime, or `0` if not.

18. **`calc_mod`**:
   - **Description**: Performs the modulo operation `r1 % r2` using ARM's `udiv` (unsigned division) and `mls` (multiply and subtract) instructions.
   - **Usage**: The dividend is passed in `r1`, and the divisor in `r2`. The result of the modulo operation is returned in `r0`.

19. **`check_lowerCase`**:
   - **Description**: Checks if a given character (in `r0`) is a lowercase letter (between `'a'` and `'z'`).
   - **Usage**: The character to check is passed in `r0`, and `1` is returned if lowercase, or `0` if not.

20. **`check_upperCase`**:
   - **Description**: Checks if a given character (in `r0`) is an uppercase letter (between `'A'` and `'Z'`).
   - **Usage**: The character to check is passed in `r0`, and `1` is returned if uppercase, or `0` if not.

21. **`do_2_complement`**:
   - **Description**: Computes the two's complement of a 32-bit number. This is done by flipping the bits and adding 1 to the result.
   - **Usage**: The number to convert is passed in `r0`, and the result is returned in `r0`.

22. **`do_2_complement_64`**:
   - **Description**: Computes the two's complement of a 64-bit number. It works on the upper 32 bits (`r0`) and the lower 32 bits (`r1`), performing the operation separately for both parts.
   - **Usage**: The upper 32 bits are passed in `r0` and the lower 32 bits in `r1`. The result is returned with the upper 32 bits in `r0` and the lower 32 bits in `r1`.

### Key Points:
- **Register Usage**: The functions extensively use ARM registers (`R0`, `R1`, `R2`, etc.) to pass arguments and return values. `R0` is commonly used for return values, while other registers (`R1`, `R2`, etc.) hold parameters or intermediate results.
- **Stack Management**: Each function starts by saving the registers that will be used to avoid overwriting their values (using `STMFD sp!, {...}`). After the function completes, it restores the registers using `LDMFD sp!, {...}`.
- **Control Flow**: Functions often use branching (`B`, `BL`, `BEQ`, etc.) to control the flow based on conditions, such as loops and comparisons.

---

## Contacts
Candido Simone: https://t.me/Simonecandido [https://t.me/Simonecandido]
If you need help or want to know something more about all of this, we are ready and excited to help you!

## Licence
[Licence](LICENCE)
