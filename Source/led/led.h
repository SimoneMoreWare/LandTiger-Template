																			 /*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           timer.h
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        Prototypes of functions included in the lib_led, funct_led .c files
** Correlated files:    lib_led.c, funct_led.c
**--------------------------------------------------------------------------------------------------------       
*********************************************************************************************************/

/* lib_led */
void LED_init(void);
void LED_deinit(void);

/* funct_led */
void LED_On (unsigned int num);
void LED_Off (unsigned int num);
void LED_Out(unsigned int value);
void LED_Out_reverse(unsigned int value);
void LED_OnAll(void);
void LED_OffAll(void);
void LED_Out_Range(unsigned int value, unsigned char from_led_num, unsigned char to_led_num);

#define D4 	7
#define D5 	6
#define D6 	5
#define D7 	4
#define D8 	3
#define D9 	2
#define D10 1
#define D11 0