#include <stdint.h>

#define VGA_MEM 0xA0000
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200

// Draw a pixel in Mode 13h
extern "C" void put_pixel(int x, int y, uint8_t color) {
    if (x<0 || x>=SCREEN_WIDTH || y<0 || y>=SCREEN_HEIGHT) return;
    volatile uint8_t* vga = (volatile uint8_t*)VGA_MEM;
    vga[y * SCREEN_WIDTH + x] = color;
}

// Draw a test pattern to verify graphics mode
extern "C" void draw_test_pattern() {
    for (int y=0; y<SCREEN_HEIGHT; y++) {
        for (int x=0; x<SCREEN_WIDTH; x++) {
            put_pixel(x, y, (x+y)%256); // color changes across screen
        }
    }
}

// Main entry
extern "C" void main() {
    draw_test_pattern();              // fill screen with test colors
    while(1); // halt
}