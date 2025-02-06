/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           lib_timer.h
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        atomic functions to be used by higher sw levels
** Correlated files:    lib_timer.c, funct_timer.c, IRQ_timer.c
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "LPC17xx.h"
#include "timer.h"

/******************************************************************************
** Function name:    enable_timer
**
** Description:      Activates the specified timer by setting its TCR (Timer Control Register) to 1.
**
** Parameters:       timer_num: The number of the timer to enable. Valid values are:
**                        0 - Enables Timer 0 (LPC_TIM0)
**                        1 - Enables Timer 1 (LPC_TIM1)
**                        2 - Enables Timer 2 (LPC_TIM2)
**                        3 - Enables Timer 3 (LPC_TIM3)
**
** Returned value:   None
**
******************************************************************************/
void enable_timer( uint8_t timer_num )
{
  	if ( timer_num == 0 )
  	{
		LPC_TIM0->TCR = 1;
  	}
  	else if (timer_num == 1)
  	{
		LPC_TIM1->TCR = 1;
 	}
	else if (timer_num == 2)
	{
		LPC_TIM2->TCR = 1;
	}
	else if (timer_num == 3)
	{
		LPC_TIM3->TCR = 1;
	}	
  	return;
}

/******************************************************************************
** Function name:    disable_timer
**
** Description:      Deactivates the specified timer by setting its TCR (Timer Control Register) to 0.
**
** Parameters:       timer_num: The number of the timer to disable. Valid values are:
**                        0 - Disables Timer 0 (LPC_TIM0)
**                        1 - Disables Timer 1 (LPC_TIM1)
**                        2 - Disables Timer 2 (LPC_TIM2)
**                        3 - Disables Timer 3 (LPC_TIM3)
**
** Returned value:   None
**
******************************************************************************/

void disable_timer( uint8_t timer_num )
{
  	if ( timer_num == 0 )
  	{
		LPC_TIM0->TCR = 0;
  	}
  	else if (timer_num == 1)
  	{
		LPC_TIM1->TCR = 0;
  	}
	else if (timer_num == 2)
	{
		LPC_TIM2->TCR = 0;
	}
	else if (timer_num == 3)
	{
		LPC_TIM3->TCR = 0;
	}
  	return;
}

/******************************************************************************
** Function name:    reset_timer
**
** Description:      Resets the specified timer by setting the reset bit (bit 1) 
**                   in its TCR (Timer Control Register) to 1.
**
** Parameters:       timer_num: The number of the timer to reset. Valid values are:
**                        0 - Resets Timer 0 (LPC_TIM0)
**                        1 - Resets Timer 1 (LPC_TIM1)
**                        2 - Resets Timer 2 (LPC_TIM2)
**                        3 - Resets Timer 3 (LPC_TIM3)
**
** Returned value:   None
**
** Notes:            If an invalid timer number is passed, the function will 
**                   have no effect.
******************************************************************************/

void reset_timer( uint8_t timer_num )
{
  	uint32_t regVal;

  	if ( timer_num == 0 )
  	{
		regVal = LPC_TIM0->TCR;
		regVal |= 0x02;
		LPC_TIM0->TCR = regVal;
  	}
  	else if (timer_num == 1)
  	{
		regVal = LPC_TIM1->TCR;
		regVal |= 0x02;
		LPC_TIM1->TCR = regVal;
  	}
	else if (timer_num == 2)
	{
		regVal = LPC_TIM2->TCR;
		regVal |= 0x02;
		LPC_TIM2->TCR = regVal;
	}
	else if (timer_num == 3)
	{
		regVal = LPC_TIM3->TCR;
		regVal |= 0x02;
		LPC_TIM3->TCR = regVal;
	}
  	return;
}
/******************************************************************************
** Function Name:      init_timer
**
** Description:        Initializes the timer.
**
** Parameters:         timer_number - Specifies the timer to initialize (0, 1, 2, or 3).
**
** Returned Value:     0 - Successful initialization.
**                     1 - Failed initialization.
**
** Notes on MCR (Match Control Register):
** The MCR controls the behavior of the timer when it reaches a match value.
** Below is a detailed explanation of the MCR configurations:
**
** LPC_TIM0->MCR = 0;   // No interrupt generated when the timer matches the value.
**                      // MR0I = 0, MR0R = 0, MR0S = 0 (interrupt disabled).
**
** LPC_TIM0->MCR = 1;   // Generates an interrupt when the timer reaches the match value.
**                      // MR0I = 1, MR0R = 0, MR0S = 0 (interrupt enabled, no reset).
**
** LPC_TIM0->MCR = 2;   // No interrupt generated; the timer resets on match.
**                      // MR0I = 0, MR0R = 1, MR0S = 0 (reset enabled, interrupt disabled).
**
** LPC_TIM0->MCR = 3;   // Generates an interrupt and resets the timer on match.
**                      // MR0I = 1, MR0R = 1, MR0S = 0 (interrupt and reset enabled).
**
** LPC_TIM0->MCR = 4;   // Stops the timer on match; no interrupt or reset occurs.
**                      // MR0I = 0, MR0R = 0, MR0S = 1 (stop enabled, interrupt/reset disabled).
**
** LPC_TIM0->MCR = 5;   // Generates an interrupt and stops the timer on match.
**                      // MR0I = 1, MR0R = 0, MR0S = 1 (interrupt enabled, no reset, stop enabled).
**
** LPC_TIM0->MCR = 6;   // Resets the timer on match but does not generate an interrupt.
**                      // MR0I = 0, MR0R = 1, MR0S = 1 (reset and stop enabled, no interrupt).
**
** LPC_TIM0->MCR = 7;   // Generates an interrupt, resets the timer, and stops it on match.
**                      // MR0I = 1, MR0R = 1, MR0S = 1 (interrupt, reset, and stop enabled).
**
** //	Stop	Reset	Interrupt
** //	0			0			0			= 0
** //	0			0			1			= 1
** //	0			1			0			= 2
** //   0			1			1			= 3
** //	1			0			0			= 4
** //	1			0			1			= 5
** //	1			1			0			= 6
** //	1			1			1			= 7

******************************************************************************/
uint32_t init_timer ( uint8_t timer_num, uint32_t Prescaler, uint8_t MatchReg, uint8_t SRImatchReg, uint32_t TimerInterval )
{
  	if ( timer_num == 0 )
  	{
		LPC_TIM0-> PR = Prescaler;
		
		if (MatchReg == 0){
			LPC_TIM0->MR0 = TimerInterval;
			LPC_TIM0->MCR |= SRImatchReg << 3*MatchReg;			
		}
		else if (MatchReg == 1){
			LPC_TIM0->MR1 = TimerInterval;
			LPC_TIM0->MCR |= SRImatchReg << 3*MatchReg;			
		}
		else if (MatchReg == 2){
			LPC_TIM0->MR2 = TimerInterval;
			LPC_TIM0->MCR |= SRImatchReg << 3*MatchReg;	
		}
		else if (MatchReg == 3){
			LPC_TIM0->MR3 = TimerInterval;
			LPC_TIM0->MCR |= SRImatchReg << 3*MatchReg;	
		}
		NVIC_EnableIRQ(TIMER0_IRQn);			/* enable timer interrupts    */
		NVIC_SetPriority(TIMER0_IRQn, 0);		/* more priority than buttons */
		return (0);
  	}
  	else if ( timer_num == 1 )
  	{
		LPC_TIM1-> PR = Prescaler;
		
		if (MatchReg == 0){
			LPC_TIM1->MR0 = TimerInterval;
			LPC_TIM1->MCR |= SRImatchReg << 3*MatchReg;			
		}
		else if (MatchReg == 1){
			LPC_TIM1->MR1 = TimerInterval;
			LPC_TIM1->MCR |= SRImatchReg << 3*MatchReg;			
		}
		else if (MatchReg == 2){
			LPC_TIM1->MR2 = TimerInterval;
			LPC_TIM1->MCR |= SRImatchReg << 3*MatchReg;	
		}
		else if (MatchReg == 3){
			LPC_TIM1->MR3 = TimerInterval;
			LPC_TIM1->MCR |= SRImatchReg << 3*MatchReg;	
		}		
		NVIC_EnableIRQ(TIMER1_IRQn);
		NVIC_SetPriority(TIMER1_IRQn, 0);	/* less priority than buttons and timer0*/
		return (0);
  	}
	// TIMER 2
	else if ( timer_num == 2 )
  	{
		LPC_TIM2-> PR = Prescaler;
		
		if (MatchReg == 0){
			LPC_TIM2->MR0 = TimerInterval;
			LPC_TIM2->MCR |= SRImatchReg << 3*MatchReg;			
		}
		else if (MatchReg == 1){
			LPC_TIM2->MR1 = TimerInterval;
			LPC_TIM2->MCR |= SRImatchReg << 3*MatchReg;			
		}
		else if (MatchReg == 2){
			LPC_TIM2->MR2 = TimerInterval;
			LPC_TIM2->MCR |= SRImatchReg << 3*MatchReg;	
		}
		else if (MatchReg == 3){
			LPC_TIM2->MR3 = TimerInterval;
			LPC_TIM2->MCR |= SRImatchReg << 3*MatchReg;	
		}		
		NVIC_EnableIRQ(TIMER2_IRQn);
		NVIC_SetPriority(TIMER2_IRQn, 0);	/* less priority than buttons and timer0*/
		return (0);
  	}
	// TIMER 3
	else if ( timer_num == 3 )
  	{
		LPC_TIM3-> PR = Prescaler;
		
		if (MatchReg == 0){
			LPC_TIM3->MR0 = TimerInterval;
			LPC_TIM3->MCR |= SRImatchReg << 3*MatchReg;			
		}
		else if (MatchReg == 1){
			LPC_TIM3->MR1 = TimerInterval;
			LPC_TIM3->MCR |= SRImatchReg << 3*MatchReg;			
		}
		else if (MatchReg == 2){
			LPC_TIM3->MR2 = TimerInterval;
			LPC_TIM3->MCR |= SRImatchReg << 3*MatchReg;	
		}
		else if (MatchReg == 3){
			LPC_TIM3->MR3 = TimerInterval;
			LPC_TIM3->MCR |= SRImatchReg << 3*MatchReg;	
		}		
		NVIC_EnableIRQ(TIMER3_IRQn);
		NVIC_SetPriority(TIMER3_IRQn, 0);	/* less priority than buttons and timer0*/
		return (0);
  	}
	return (1);
}
/******************************************************************************
** Function name:    toggle_timer
**
** Description:      Toggles the state of the specified timer by inverting the 
**                   current value of its TCR (Timer Control Register). If the timer 
**                   is currently enabled, it will be disabled, and vice versa.
**
** Parameters:       timer_num: The number of the timer to toggle. Valid values are:
**                        0 - Toggles Timer 0 (LPC_TIM0)
**                        1 - Toggles Timer 1 (LPC_TIM1)
**                        2 - Toggles Timer 2 (LPC_TIM2)
**                        3 - Toggles Timer 3 (LPC_TIM3)
**
** Returned value:   None
**
** Notes:            If an invalid timer number is passed, the function will 
**                   have no effect.
******************************************************************************/
void toggle_timer( uint8_t timer_num ) {
	if ( timer_num == 0 )
	{
		LPC_TIM0->TCR = !LPC_TIM0->TCR;
	}
	else if (timer_num == 1)
	{
		LPC_TIM1->TCR = !LPC_TIM1->TCR;
	}
	else if (timer_num == 2)
	{
		LPC_TIM2->TCR = !LPC_TIM2->TCR;
	}
	else if (timer_num == 3)
	{
		LPC_TIM3->TCR = !LPC_TIM3->TCR;
	}
	return;
}
/******************************************************************************
** Function name:    get_timer_value
**
** Description:      Retrieves the current count value of the specified timer by 
**                   reading its TC (Timer Counter) register.
**
** Parameters:       timer_num: The number of the timer to read. Valid values are:
**                        0 - Reads the value of Timer 0 (LPC_TIM0)
**                        1 - Reads the value of Timer 1 (LPC_TIM1)
**                        2 - Reads the value of Timer 2 (LPC_TIM2)
**                        3 - Reads the value of Timer 3 (LPC_TIM3)
**
** Returned value:   The current value of the Timer Counter (TC) for the specified timer.
**                   If an invalid timer number is passed, the function returns -1.
**
** Notes:            Ensure the specified timer is initialized and running before 
**                   calling this function to get meaningful results.
******************************************************************************/
unsigned int get_timer_value(uint8_t timer_num) {
	if ( timer_num == 0 )
	{
		return LPC_TIM0->TC;
	}
	else if (timer_num == 1)
	{
		return LPC_TIM1->TC;
	}
	else if (timer_num == 2)
	{
		return LPC_TIM2->TC;
	}
	else if (timer_num == 3)
	{
		return LPC_TIM3->TC;
	}
	return -1;
}

/******************************************************************************
** Function name:    get_timer_value_in_sec
**
** Description:      Retrieves the current count value of the specified timer in seconds.
**
** Parameters:       timer_num: The number of the timer to read. Valid values are:
**                        0 - Reads the value of Timer 0 (LPC_TIM0)
**                        1 - Reads the value of Timer 1 (LPC_TIM1)
**                        2 - Reads the value of Timer 2 (LPC_TIM2)
**                        3 - Reads the value of Timer 3 (LPC_TIM3)
**
** Returned value:    The current value of the Timer Counter (TC) for the specified timer in seconds.
**                    If an invalid timer number is passed, the function returns -1.
**
** Notes:            Ensure the specified timer is initialized and running before 
**                   calling this function to get meaningful results.
**
** Assumptions:      TIMER0_FREQ, TIMER1_FREQ, TIMER2_FREQ, and TIMER3_FREQ are 
**                   defined constants representing the respective timer frequencies 
**                   in Hz.
******************************************************************************/
float get_timer_value_in_sec(uint8_t timer_num) {

	switch (timer_num) {
        	case 0:
            		return (float) (LPC_TIM0->TC) / TIMER0_FREQ;
        	case 1:
            		return (float) (LPC_TIM1->TC) / TIMER1_FREQ;
       	 	case 2:
            		return (float) (LPC_TIM2->TC) / TIMER2_FREQ;
        	case 3:
            		return (float) (LPC_TIM3->TC) / TIMER3_FREQ;
       	 	default:
            		return -1; 
    	}
}
/******************************************************************************
** Function name:    is_timer_enabled
**
** Description:      Checks whether the specified timer is enabled by reading 
**                   the enable bit (bit 0) of its TCR (Timer Control Register).
**
** Parameters:       timer_num: The number of the timer to check. Valid values are:
**                        0 - Checks Timer 0 (LPC_TIM0)
**                        1 - Checks Timer 1 (LPC_TIM1)
**                        2 - Checks Timer 2 (LPC_TIM2)
**                        3 - Checks Timer 3 (LPC_TIM3)
**
** Returned value:   1 if the specified timer is enabled, 0 if it is disabled.
**
** Notes:            If an invalid timer number is passed, the function will 
**                   return 0, as the default value of regVal is 0.
******************************************************************************/
uint32_t is_timer_enabled ( uint8_t timer_num){
	
	uint32_t regVal = 0;
	
	switch(timer_num){
		case 0:
			regVal = LPC_TIM0->TCR;
			break;
		case 1:
			regVal = LPC_TIM1->TCR;
			break;		
		case 2:
			regVal = LPC_TIM2->TCR;
			break;
		case 3:
			regVal = LPC_TIM3->TCR;
			break;
	}

	regVal &= 0x00000001;
	return regVal; //Should be 1 if enabled, 0 if disabled
}

/******************************************************************************
** Function name:    power_on_timer2
**
** Description:      Powers on Timer 2 by setting bit 22 in the PCONP 
**                   (Power Control for Peripherals) register.
**
** Parameters:       None
**
** Returned value:   None
**
** Notes:            Ensure Timer 2 is properly configured after enabling power.
******************************************************************************/
void power_on_timer2(){
	LPC_SC -> PCONP |= (1 << 22);  // TURN ON TIMER 2
}
/******************************************************************************
** Function name:    power_on_timer3
**
** Description:      Powers on Timer 3 by setting bit 23 in the PCONP 
**                   (Power Control for Peripherals) register.
**
** Parameters:       None
**
** Returned value:   None
**
** Notes:            Ensure Timer 3 is properly configured after enabling power.
******************************************************************************/
void power_on_timer3(){
	LPC_SC -> PCONP |= (1 << 23);  // TURN ON TIMER 3	
}

/******************************************************************************
**                            End Of File
******************************************************************************/
