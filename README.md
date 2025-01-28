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

## Contacts
Candido Simone: https://t.me/Simonecandido [https://t.me/Simonecandido]
If you need help or want to know something more about all of this, we are ready and excited to help you!

## Licence
[Licence](LICENCE)
