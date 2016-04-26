


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
	make -C src run

build/prog.com: src/loader.asm
	mkdir -p build/
	nasm -f bin -o build/prog.com src/loader.asm

emulator: emulator/8086tiny

emulator/8086tiny: emulator/8086tiny.c
	make -C emulator no_graphics

clean:
	rm *.o *.bin *.com
