To assemble and run:
```bash
nasm -f elf programs/ex1.asm -o build/ex1.o
ld -m elf_i386 build/ex1.o -o build/ex1
./build/ex1
```
