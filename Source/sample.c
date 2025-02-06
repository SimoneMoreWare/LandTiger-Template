/*----------------------------------------------------------------------------
 * Name:    sample.c
 * Purpose: to control led through debounced buttons and Joystick
 *        	- key1 switches on the led at the left of the current led on, 
 *		- it implements a circular led effect,
 * 		- joystick UP function returns to initial configuration (led11 on) .
 * Note(s): this version supports the LANDTIGER Emulator
 * Author: 	Paolo BERNARDI - PoliTO - last modified 15/12/2020
 *----------------------------------------------------------------------------
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2017 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/
                  
#include <stdio.h>
#include "LPC17xx.h"                    /* LPC17xx definitions                */
#include "led/led.h"
#include "button_EXINT/button.h"
#include "timer/timer.h"
#include "RIT/RIT.h"
#include "joystick/joystick.h"
#include "sample.h"

#ifdef SIMULATOR
extern uint8_t ScaleFlag; // <- ScaleFlag needs to visible in order for the emulator to find the symbol (can be placed also inside system_LPC17xx.h but since it is RO, it needs more work)
#endif

/*
unsigned char startState = 0xAA;
unsigned char currentState = 0xAA; //0b101010
unsigned char taps = 0x41; //01000001
*/

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void) {
  	
	SystemInit();  													/* System Initialization (i.e., PLL)  */
		
	// LED
  	//LED_init();                           /* LED Initialization                 */
	
	// Buttons
  	//BUTTON_init();												/* BUTTON Initialization              */
	
	// Joystick
	//joystick_init();
	
	// RIT
	//init_RIT(0x004C4B40); ///* RIT Initialization 50 msec       */
	//enable_RIT();
	
	//power_on_timer2(); 	// or LPC_SC -> PCONP |= (1 << 22);  // TURN ON TIMER 2
	//power_on_timer3(); 	// or LPC_SC -> PCONP |= (1 << 23);  // TURN ON TIMER 3	
	
	//init_timer(TIMER0, 0, 0, CONTROL_INTERRUPT, 0x017D7840);							/* TIMER0 Initialization              */
															/* K = T*Fr = [s]*[Hz] = [s]*[1/s]    */
															/* T = K / Fr = 0x017D7840 / 25MHz    */
															/* T = K / Fr = 25000000 / 25MHz      */
															/* T = 1s	(one second)   	      */

	/*
		How to change the frequency of peripherals?
		
		Go to the `systemLPCXX.c` file.  
		At the bottom, select the configuration wizard.  
		Go to the clock configuration section.  
		Then, there are two entries -> `Peripheral Clock Selection Register0` and `Peripheral Clock Selection Register1`.  
		- `Peripheral Clock Selection Register0` is for timers 0 and 1.  
		- `Peripheral Clock Selection Register1` is for timers 2 and 3.

		Next, you have the clock frequency of the main oscillator, which is 100MHz.  
		Normally, for the timers, it's set to 25MHz, which is `CCLK/4`.  
		To set it to 50MHz, just set it to `CCLK/2`.
	*/
	
	//init_timer(TIMER2,0,0,CONTROL_RESET,0x7A120); //100Hz
	//enable_timer(TIMER2);

	LPC_SC->PCON |= 0x1;		/* power-down	mode */
	LPC_SC->PCON &= 0xFFFFFFFFD;						
		
  while (1) {                           /* Loop forever */	
		__ASM("wfi");
  }

}
