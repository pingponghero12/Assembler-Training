To assemble and run:
```bash
nasm -f elf programs/ex3.asm -o build/ex3.o
ld -m elf_i386 build/ex3.o -o build/ex3
./build/ex3
```
