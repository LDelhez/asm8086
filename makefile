

EXE=emulator/8086tiny
ifeq ($(OS),Windows_NT)
	EXE=emulator/8086tiny.exe
endif


default: emulator run

all: loader emulator run

loader: build/prog.com
	sudo mkdir -p /mnt/mounted
	sudo mount -o loop emulator/fd.img /mnt/mounted
	sudo cp build/prog.com /mnt/mounted
	sleep 1
	sudo umount /mnt/mounted

run:
	mkdir -p workspace
	mkdir -p build/

build/prog.com: src/loader.asm
	mkdir -p build/
	nasm -f bin -o build/prog.com src/loader.asm

emulator: emulator/8086tiny

emulator/8086tiny: emulator/8086tiny.c
	make -C emulator no_graphics

clean:
	rm -f *.o *.bin *.com
	rm -rf build/
	rm -f $(EXE)
