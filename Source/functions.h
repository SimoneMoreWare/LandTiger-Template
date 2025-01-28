// Function to extract bits between indices `start` and `end` (inclusive)
// Parameters:
//   value  - The 32-bit value from which the bits will be extracted
//   start  - The starting index of the bit range to extract (0 to 31)
//   end    - The ending index of the bit range to extract (0 to 31)
// Returns:
//   The extracted bits as an unsigned short (16 bits)
unsigned short extract_bits(unsigned int value, int start, int end);

// Function to represent a 32-bit value on the LEDs, 8 bits at a time
// Parameters:
//   res      - The 32-bit value to be displayed on the LEDs
//   position - The position of the byte to display (0 to 3)
//             - 0: least significant byte (LSB), 1: next byte, etc.
// No return value; output is sent directly to LEDs
void represent_on_leds(unsigned int res, int position);
