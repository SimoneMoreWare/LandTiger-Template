/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_RIT.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    RIT.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "LPC17xx.h"
#include "RIT.h"
#include "../led/led.h"
#include "../sample.h"

/* User Imports */

//#include "../main/user_RIT.h"

/* Variabili Globali Gestione De-Bouncing */
	
volatile int down_0 = 0;
volatile int down_1 = 0;
volatile int down_2 = 0;
volatile int toRelease_down_0 = 0;
volatile int toRelease_down_1 = 0;
volatile int toRelease_down_2 = 0;

volatile int J_up = 0;
volatile int J_down = 0;
volatile int J_right = 0;
volatile int J_left = 0;
volatile int J_click = 0;
volatile int J_up_left = 0;
volatile int J_up_right = 0;
volatile int J_down_left = 0;
volatile int J_down_right = 0;

	/* Variabili Globali */

int const long_press_count_1 = 0;		// => count = x / 50ms ; where x = time long press
//int const long_press_count_2 = 0;  


/******************************************************************************
** Function name:		RIT_IRQHandler
**
** Descriptions:		REPETITIVE INTERRUPT TIMER handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void RIT_IRQHandler(void) 
{			
	
	unsigned char UP_LEFT_activated = 0;
	unsigned char UP_RIGHT_activated = 0;
	unsigned char DOWN_LEFT_activated = 0;
	unsigned char DOWN_RIGHT_activated = 0;
	
	/* INT0 */
	
	if(down_0 !=0) {			/* INT0 */
		down_0++;
		if((LPC_GPIO2->FIOPIN & (1<<10)) == 0){ /* button premuto */
			switch(down_0) {
				case 2:				
					// short press
				  	// your_code	
					toRelease_down_0 = 1;
					break;
				case long_press_count_1:					
					// your code here (for long press)				
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			if(toRelease_down_0){
				//add code to manage release.
				toRelease_down_0=0;
			}
			down_0=0;			
			NVIC_EnableIRQ(EINT0_IRQn);					 /* disable Button interrupts		 */
			LPC_PINCON->PINSEL4    |= (1 << 20);     			 /* External interrupt 0 pin selection   */
		}
	} 	// end INT0

	///////////////////////////////////////////////////////////////////
	
	/* KEY1 */
	
	if(down_1 !=0) {			/* KEY1 */
		down_1++;
		if((LPC_GPIO2->FIOPIN & (1<<11)) == 0){ /* button premuto */
			switch(down_1){
				case 2:
					// short press
					// your code here
					toRelease_down_1=1;
					break;
				case long_press_count_1:
					// your code here (for long press)
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			if(toRelease_down_1){
				//add code to manage release.
				toRelease_down_1=0;
			}			
			down_1=0;	
			NVIC_EnableIRQ(EINT1_IRQn);					 /* disable Button interrupts	         */
			LPC_PINCON->PINSEL4    |= (1 << 22);     			 /* External interrupt 0 pin selection   */
		}
	}	// end KEY1
	
	///////////////////////////////////////////////////////////////////
	
	/* KEY2 */

	if(down_2 !=0) {			/* KEY2 */
		down_2++;
		if((LPC_GPIO2->FIOPIN & (1<<12)) == 0){ /* button premuto */
			switch(down_2){
				case 2:
					// short press
					// your code here
					toRelease_down_2=1;
					break;
				case long_press_count_1:
					// your code here (for long press)
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			if(toRelease_down_2){
				//add code to manage release.
				toRelease_down_2=0;
			}	
			down_2=0;		
			NVIC_EnableIRQ(EINT2_IRQn);					 /* disable Button interrupts	        */
			LPC_PINCON->PINSEL4    |= (1 << 24);     			 /* External interrupt 0 pin selection  */
		}
	}	// end KEY2
	
	///////////////////////////////////////////////////////////////////
		
	/*Joystick UP-LEFT*/
	if(((LPC_GPIO1->FIOPIN & (1<<27)) == 0) && ((LPC_GPIO1->FIOPIN & (1<<29)) == 0)) {		/* Joystick UP-LEFT */
		/* Joytick UP-LEFT pressed */
		J_up_left++;
		UP_LEFT_activated = 1;
		switch(J_up_left){
			case 1:				
				//short press
				//your code	
							
				//for just enabling up-left and not up-left + left + up without flags
				//LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				//return;					
				break;
			case long_press_count_1:
				// your code here (for long press)
				
				//for just enabling up-left and not up-left + left + up without flags
				//LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				//return;	
				break;
			default:
				// potential other code here
				
				//for just enabling up-left and not up-left + left + up without flags
				//LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				//return;	
				break;
		}
	}
	else {
		J_up_left=0;
	}	// end Joystick UP-LEFT
		
	///////////////////////////////////////////////////////////////////
		
	/*Joystick UP-RIGHT*/
	if(((LPC_GPIO1->FIOPIN & (1<<28)) == 0) && ((LPC_GPIO1->FIOPIN & (1<<29)) == 0)) {		/* Joystick UP-RIGHT*/
		/* Joytick UP-RIGHT pressed */
		J_up_right++;
		UP_RIGHT_activated = 1;
		switch(J_up_right){
			case 1:				
				//short press
				//your code	
				
				//for just enabling up-right and not up-right + right + up without flags
				//LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				//return;	
				break;
			case long_press_count_1:
				// your code here (for long press)
				
				//for just enabling up-right and not up-right + right + up without flags
				//LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				//return;	
				break;
			default:
				// J_uppotential other code here
				
				//for just enabling up-right and not up-right + right + up without flags
				//LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				//return;	
				break;
		}
	}
	else {
		J_up_right=0;
	}	// end Joystick UP-RIGHT
		
	///////////////////////////////////////////////////////////////////
		
	/*Joystick DOWN-LEFT*/
	if(((LPC_GPIO1->FIOPIN & (1<<27)) == 0) && ((LPC_GPIO1->FIOPIN & (1<<26)) == 0)) {		/* Joystick DOWN-LEFT */
		/* Joytick DOWN-LEFT pressed */
		J_down_left++;
		DOWN_LEFT_activated = 0;
		switch(J_down_left){
			case 1:				
				//short press
				//your code	
										
				//for just enabling down-left and not down-left + down + left without flags
				//LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				//return;	
				break;
			case long_press_count_1:
				// your code here (for long press)
				
				//for just enabling down-left and not down-left + down + left without flags
				//LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				//return;
				break;
			default:
				// potential other code here
								
				//for just enabling down-left and not down-left + down + left without flags
				//LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				//return;
				break;
		}
	}
	else {
		J_down_left=0;
	}	// end Joystick DOWN-LEFT
		
	///////////////////////////////////////////////////////////////////
		
	/*Joystick DOWN-RIGHT*/
	if(((LPC_GPIO1->FIOPIN & (1<<26)) == 0) && ((LPC_GPIO1->FIOPIN & (1<<28)) == 0)) {		/* Joystick DOWN-RIGHT */
		/* Joytick DOWN-RIGHT pressed */
		J_down_right++;
		DOWN_RIGHT_activated = 0;
		switch(J_down_right){
			case 1:				
				//short press
				//your code	
				
				//for just enabling down-right and not down-left + down + right without flags
				//LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				//return;
				break;
			case long_press_count_1:
				// your code here (for long press)
					
				//for just enabling down-right and not down-left + down + right without flags
				//LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				//return;
				break;
			default:
				// potential other code here
				
				
				//for just enabling down-right and not down-left + down + right without flags
				//LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				//return;
				break;
		}
	}
	else {
		J_down_right=0;
	}	// end Joystick DOWN-RIGHT
	
	///////////////////////////////////////////////////////////////////
	
	/* Joystick UP */
	
	if(UP_LEFT_activated==0 && UP_RIGHT_activated==0){
		if((LPC_GPIO1->FIOPIN & (1<<29)) == 0 ) {		/* Joystick UP */
			/* Joytick UP pressed */
			J_up++;
			switch(J_up){
				case 1:				
					// short press
					// your code		
					break;
				case long_press_count_1:
					// your code here (for long press)
					break;
				default:
					// potential other code here
					break;
			}
		}
		else {
			J_up=0;
		}	// end Joystick UP
	}
	
	///////////////////////////////////////////////////////////////////
	
	/* Joystick DOWN */
	
	if(DOWN_LEFT_activated==0 && DOWN_RIGHT_activated==0){
		if((LPC_GPIO1->FIOPIN & (1<<26)) == 0) {		/* Joystick DOWN */
			/* Joytick DOWN pressed */
			J_down++;
			switch(J_down){
				case 1:				
					//short press
					//your code
					break;
				case long_press_count_1:
					// your code here (for long press)
					break;
				default:
					// potential other code here
					break;
			}
		}
		else{
			J_down=0;
		}	// end Joystick DOWN
	}

	///////////////////////////////////////////////////////////////////
	
	/* Joystick RIGHT */

	if(DOWN_RIGHT_activated==0 && UP_RIGHT_activated==0){
		if((LPC_GPIO1->FIOPIN & (1<<28)) == 0) {		/* Joystick RIGHT */
			/* Joytick RIGHT pressed */
			J_right++;
			switch(J_right){
				case 1:				
					//short press
					//your code	
					break;
				case long_press_count_1:
					// your code here (for long press)
					break;
				default:
					// potential other code here
					break;
			}
		}
		else {
			J_right=0;
		}	// end Joystick RIGHT
	}
	
	///////////////////////////////////////////////////////////////////
	
	/* Joystick LEFT */

	if(UP_LEFT_activated==0 && DOWN_LEFT_activated==0){
		if((LPC_GPIO1->FIOPIN & (1<<27)) == 0) {		/* Joystick LEFT */
			/* Joytick LEFT pressed */
			J_left++;
			switch(J_left){
				case 1:				
					//short press
					//your code	
					break;
				case long_press_count_1:
					// your code here (for long press)
					break;
				default:
					// potential other code here
					break;
			}
		}
		else {
			J_left=0;
		}	// end Joystick LEFT
	}
	
	///////////////////////////////////////////////////////////////////
		
	/* Joystick CLICK */

	if((LPC_GPIO1->FIOPIN & (1<<25)) == 0) {		/* Joystick CLICK */
		/* Joytick CLICK pressed */
		J_click++;
		switch(J_click){
			case 1:
				//short press
				// your code here
				break;
			case long_press_count_1:
				// your code here (for long press)
				break;
			default:
				// potential other code here
				break;
		}
	}
	else {
		J_click=0;
	}	// end Joystick CLICK
		
	//reset_RIT(); se ci sono cose strane come il rit che si ferma
	LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
	return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
