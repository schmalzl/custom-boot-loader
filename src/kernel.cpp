#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

static inline void outb(uint16_t port, uint8_t val) {
    asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

// Set VGA 320x200x256 graphics mode
extern "C" void set_graphics_mode() {
    asm volatile (
        "mov $0x13, %%ax\n\t"
        "int $0x10\n\t"
        :
        :
        : "ax"
    );
}

// main entry point
extern "C" void main(){
    set_graphics_mode();
    while (1);
}