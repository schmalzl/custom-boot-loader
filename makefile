# OS Makefile
# NOTE: All files generated during the build process are stored in ./cache/
# NOTE: The current makefile only supports the creators structure. You may adapt some commands to your needs.

# Assembly file (.asm) to use as bootloader
ASM_FILE = boot
# Binary file (.bin)
BIN_FILE = ./cache/$(ASM_FILE).bin
# NASM Assembler
NASM = nasm
NASM_FLAGS = -f bin
# Emulator command and flags
QEMU = qemu-system-i386
QEMU_FLAGS = -drive format=raw,file=$(BIN_FILE)

# default build command
all:
# Build the bootsector using NASM
	nasm "./src/boot.asm" -f bin -o "./cache/boot.bin"

# Build the kernel entry assembly file
	nasm "./src/kernel_entry.asm" -f elf32 -o "./cache/kernel_entry.o"

# compile the kernel.c file --> kernel.o
	/opt/homebrew/opt/x86_64-elf-gcc/bin/x86_64-elf-gcc -ffreestanding -m32 -g -c "./src/kernel.cpp" -o "./cache/kernel.o"

# Compile the Zeroes file
	nasm "./src/zeroes.asm" -f bin -o "./cache/zeroes.bin"

# Link to a full kernel binary
	/opt/homebrew/opt/x86_64-elf-binutils/bin/x86_64-elf-ld -m elf_i386 -o "./cache/full_kernel.bin" -Ttext 0x1000 "./cache/kernel_entry.o" "./cache/kernel.o" --oformat binary

# Pack all binaries into an image
	cat "./cache/boot.bin" "./cache/full_kernel.bin" "./cache/zeroes.bin"  > "./bin/image.bin"

# cleaup
clean:
	rm -f ./cache/boot.bin
	rm -f ./cache/full_kernel.bin
	rm -f ./cache/kernel_entry.bin
	rm -f ./cache/zeroes.bin
	rm -f ./cache/kernel.o
	rm -f ./cache/kernel_entry.o

run:
	qemu-system-i386 -drive format=raw,file=./bin/image.bin