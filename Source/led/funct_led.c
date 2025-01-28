/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           funct_led.h
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        High level led management functions
** Correlated files:    lib_led.c, funct_led.c
**--------------------------------------------------------------------------------------------------------       
*********************************************************************************************************/

#include "LPC17xx.h"
#include "led.h"

#define LED_NUM     8                   /* Number of user LEDs                */
const unsigned long led_mask[] = { 1UL<<0, 1UL<<1, 1UL<<2, 1UL<< 3, 1UL<< 4, 1UL<< 5, 1UL<< 6, 1UL<< 7 };

extern unsigned char led_value;

/*----------------------------------------------------------------------------
  Function that turns on requested LED
 *----------------------------------------------------------------------------*/
void LED_On(unsigned int num) {
 
  LPC_GPIO2->FIOPIN |= led_mask[num];
	led_value = LPC_GPIO2->FIOPIN;
}

/*----------------------------------------------------------------------------
  Function that turns off requested LED
 *----------------------------------------------------------------------------*/
void LED_Off(unsigned int num) {

  LPC_GPIO2->FIOPIN &= ~led_mask[num];
	led_value = LPC_GPIO2->FIOPIN;
}

/*----------------------------------------------------------------------------
  Function that outputs value to LEDs
 *----------------------------------------------------------------------------*/
void LED_Out(unsigned int value) {
  int i;
	
  for (i = 0; i < LED_NUM; i++) {
    if (value & (1<<i)) {
      LED_On (i);
    } else {
      LED_Off(i);
    }
  }
	led_value = LPC_GPIO2->FIOPIN;
	
}
/*----------------------------------------------------------------------------
  Function that outputs value to LEDs in reverse order
 *----------------------------------------------------------------------------*/
void LED_Out_reverse(unsigned int value) {
  int i;

  for (i = LED_NUM; i >= 0; i--) {
    if (value & (1<<i)) {
      LED_On (LED_NUM-i-1);
    } else {
      LED_Off(i);
    }
  }
	led_value = value;
}

/*----------------------------------------------------------------------------
  Function that power on ALL led
 *----------------------------------------------------------------------------*/
void LED_OnAll(void)
{
	int i;
	for (i = 0; i < LED_NUM; i++)
	{
		LED_On(i);
	}
}
/*----------------------------------------------------------------------------
  Function that power down ALL led
 *----------------------------------------------------------------------------*/
void LED_OffAll(void)
{
	int i;
	for (i = 0; i < LED_NUM; i++)
	{
		LED_Off(i);
	}
}
/*----------------------------------------------------------------------------
  Function that power on range led from start to end
 *----------------------------------------------------------------------------*/
void LED_Out_Range(unsigned int value, uint8_t from_led_num, uint8_t to_led_num){
	int i;
	int j;
	if (to_led_num < from_led_num || to_led_num >= LED_NUM) return;
	
  for (i = from_led_num, j=0; i <= to_led_num; i++,j++) {
    if (value & (1<<j)) {
      LED_On (i);
    } else {
      LED_Off(i);
    }
  }
	led_value = LPC_GPIO2->FIOPIN;
}