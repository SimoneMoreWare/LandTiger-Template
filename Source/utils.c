#include "utils.h"

//	here you can add the functions that use during the simulation or the exam

// === TIMERS ===
uint32_t s_to_mr(uint32_t seconds, uint32_t timer_freq, uint32_t prescaler) {
    return (seconds * timer_freq) / (prescaler + 1);
}

uint32_t ms_to_mr(uint32_t ms, uint32_t timer_freq, uint32_t prescaler) {
    return (ms * (timer_freq / 1000)) / (prescaler + 1);
}

uint32_t hz_to_mr(uint32_t hz, uint32_t timer_freq, uint32_t prescaler) {
    return timer_freq / ((prescaler + 1) * hz);
}

// === BIT MANIPULATION ===
// Se 16 bit, fare solo il primo shift di 8 bit
uint8_t exor_4_bytes(uint32_t v) {
    return (uint8_t)(v ^ (v >> 8) ^ (v >> 16) ^ (v >> 24));
}

uint8_t or_4_bytes(uint32_t v) {
    return (uint8_t)(v | (v >> 8) | (v >> 16) | (v >> 24));
}

uint8_t and_4_bytes(uint32_t v) {
    return (uint8_t)(v & (v >> 8) & (v >> 16) & (v >> 24));
}

uint8_t not(uint8_t v) {
    return ~v;
}

// === LEDs ===
void blink_leds_value(uint8_t v) {
    if (LED_BLINK_ON == 1) {
        LED_OffAll();
        LED_BLINK_ON = 0;
    } else {
        LED_Out(v);
        LED_BLINK_ON = 1;
    }
}

void blink_all_leds() {
    blink_leds_value(255);
}

void init() {
    // initialize variables
}