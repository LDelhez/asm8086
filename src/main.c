#include <stdio.h>
#include <stdlib.h>

int error(char* str) {
  printf("%s\n", str);
  exit(-1);
}

unsigned int get_file_size(FILE* fp) {
  fseek(fp, 0L, SEEK_END);
  unsigned int sz = ftell(fp);
  fseek(fp, 0L, SEEK_SET);
  return sz;
}

FILE* create_file() {
  FILE* src = fopen("../src/header.asm", "r");
  if (!src) return error("Pas de fichier ../src/header.asm"), NULL;
  FILE* dest = fopen("../build/to_be_nasmed.asm", "w");
  if (!dest) return error("Impossible d'ecrire dans ../build/"), NULL;

  unsigned int length = get_file_size(src) + 1;
  char* buffer = malloc( length * sizeof(char) );
  fread(buffer, sizeof(char), length - 1, src);
  fclose(src);

  fprintf(dest, "%s\n", buffer);

  free(buffer);
  return dest;
}

void assemble_with_nasm(char* filename) {
  FILE* fp = fopen(filename, "r");
  FILE* dest = create_file();

  fclose(fp);
  fclose(dest);
}


int main(int argc, char *argv[] ) {

  if (argc != 2) {
    puts("[!]: Aucun fichier");
    puts("Utilisation: ljed filename.asm\n");
  }

  assemble_with_nasm(argv[1]);

  return 0;
}
