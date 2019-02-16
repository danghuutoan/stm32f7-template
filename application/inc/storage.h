#ifndef __STORAGE_H
#define __STORAGE_H
#include <stdint.h>
int storage_init(void);
int storage_read(uint8_t *buffer, uint32_t length);
int storage_open(char *filename);
int storage_get_size(void);
#endif