To assemble and run:
```bash
nasm -f elf programs/ex4.asm -o build/ex4.o
ld -m elf_i386 build/ex4.o -o build/ex4
./build/ex3
```
