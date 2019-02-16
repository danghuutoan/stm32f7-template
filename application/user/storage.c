#include "storage.h"
#include "ff.h"

/* FatFs includes component */
#include "ff_gen_drv.h"
#include "sd_diskio.h"
#include <stdlib.h>
#include <stddef.h>
FATFS SDFatFs;  /* File system object for SD card logical drive */
char SDPath[4]; /* SD card logical drive path */
static FIL _file;
int storage_init(void)
{
  if(FATFS_LinkDriver(&SD_Driver, SDPath) != 0)
  {
    printf("failed to link sd driver\r\n");
    return -1;
  } else {
    
    if(f_mount(&SDFatFs, (TCHAR const*)SDPath, 0) != FR_OK)
    {
      printf("failed to mount disk\r\n");
      return -1;
    }
  }

  return 1;
}

int storage_open(char *filename)
{
  FRESULT fr;
  fr = f_open(&_file, filename, FA_READ);
  if(fr != FR_OK)
  {
    return -1;
  }
  return 1;
}

int storage_read(uint8_t *buffer, uint32_t length)
{
  uint32_t bytesread;
  FRESULT fr;
  fr = f_read(&_file, buffer, length, (UINT*)&bytesread);
  if(fr != FR_OK)
  {
    return -1;
  }
  return bytesread;
}

int storage_get_size(void)
{
  return f_size(&_file);
}
#if _USE_LFN == 3	/* LFN with a working buffer on the heap */
/*------------------------------------------------------------------------*/
/* Allocate a memory block                                                */
/*------------------------------------------------------------------------*/
/* If a NULL is returned, the file function fails with FR_NOT_ENOUGH_CORE.
*/

void* ff_memalloc (	/* Returns pointer to the allocated memory block */
	UINT msize		/* Number of bytes to allocate */
)
{
	return malloc(msize);	/* Allocate a new memory block with POSIX API */
}


/*------------------------------------------------------------------------*/
/* Free a memory block                                                    */
/*------------------------------------------------------------------------*/

void ff_memfree (
	void* mblock	/* Pointer to the memory block to free */
)
{
	free(mblock);	/* Discard the memory block with POSIX API */
}

#endif

static void Error_Handler(void)
{
  /* Turn LED1 on */
  BSP_LED_On(LED1);
  while(1)
  {
    BSP_LED_Toggle(LED1);
    HAL_Delay(200);
  }
}