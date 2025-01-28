/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           timer.h
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        Prototypes of functions included in the lib_timer, funct_timer, IRQ_timer .c files
** Correlated files:    lib_timer.c, funct_timer.c, IRQ_timer.c
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#ifndef __TIMER_H
#define __TIMER_H

/* init_timer.c */
//uint32_t init_timer ( uint8_t timer_num, uint32_t Prescaler, uint8_t MatchReg, uint8_t SRImatchReg, uint32_t TimerInterval )
//extern uint32_t init_timer( uint8_t timer_num, uint32_t timerInterval );
extern uint32_t init_timer( uint8_t timer_num, uint32_t Prescaler, uint8_t MatchReg, uint8_t SRImatchReg, uint32_t TimerInterval );
extern void enable_timer( uint8_t timer_num );
extern void disable_timer( uint8_t timer_num );
extern void reset_timer( uint8_t timer_num );
void toggle_timer( uint8_t timer_num );
unsigned int get_timer_value(uint8_t timer_num);
uint32_t is_timer_enabled ( uint8_t timer_num);
void power_on_timer2();
void power_on_timer3();
float get_timer_value_in_sec(uint8_t timer_num);

/* IRQ_timer.c */
extern void TIMER0_IRQHandler (void);
extern void TIMER1_IRQHandler (void);
extern void TIMER2_IRQHandler (void);
extern void TIMER3_IRQHandler (void);

#define TIMER0 0
#define TIMER1 1
#define TIMER2 2
#define TIMER3 3

#define TIMER0_FREQ 25000000
#define TIMER1_FREQ 25000000
#define TIMER2_FREQ 25000000
#define TIMER3_FREQ 25000000

#define CONTROL_NULL				(0)
#define CONTROL_INTERRUPT 	(1 << 0)
#define CONTROL_RESET 			(1 << 1)
#define CONTROL_STOP				(1 << 2)


#define CURRCLK 						(0x05F5E100)  	/* 100MHz */
#define TIMER_CLK						(CURRCLK >> 2)  /* CURRCLK / 4 */

#endif /* end __TIMER_H */
/*****************************************************************************
**                            End Of File
******************************************************************************/
