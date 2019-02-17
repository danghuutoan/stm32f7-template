#include "music_player.h"
#include "main.h"
#include <string.h>
#include "storage.h"
#include "ff.h"

static AUDIO_OUT_BufferTypeDef  BufferCtl;
AUDIO_PLAYBACK_StateTypeDef AudioState = AUDIO_STATE_IDLE;
static FIL wav_file;
static WAVE_FormatTypeDef info;

void music_player_init(void)
{
  BufferCtl.state = BUFFER_OFFSET_NONE;
}
void music_player_song_select(char *filename)
{
  uint32_t numOfReadBytes;
  f_open(&wav_file, filename, FA_OPEN_EXISTING | FA_READ);
  f_read(&wav_file, &info, sizeof(WAVE_FormatTypeDef), (void *)&numOfReadBytes);
  f_lseek(&wav_file, sizeof(WAVE_FormatTypeDef));
  printf("file size %d\r\n", info.FileSize);
  printf("sample rate %d\r\n", info.SampleRate);

  if (BSP_AUDIO_OUT_Init(OUTPUT_DEVICE_HEADPHONE, 70, info.SampleRate) != 0)
  {
      printf("init audio failed\r\n");
  }
  BSP_AUDIO_OUT_SetAudioFrameSlot(CODEC_AUDIOFRAME_SLOT_02);
}
void music_player_play(void)
{
    // load the first audio frame
    AudioState = AUDIO_STATE_PLAY;
    BufferCtl.fptr = AUDIO_OUT_BUFFER_SIZE;
    BSP_AUDIO_OUT_Play((uint16_t*)&BufferCtl.buff[0], AUDIO_OUT_BUFFER_SIZE);
}

void music_player_process(void)
{
  uint32_t numOfReadBytes;
  if(BufferCtl.state == BUFFER_OFFSET_HALF)
  {
      f_read(&wav_file, &BufferCtl.buff[0], AUDIO_OUT_BUFFER_SIZE/2, (void *)&numOfReadBytes);
      BufferCtl.state = BUFFER_OFFSET_NONE;
      BufferCtl.fptr += AUDIO_OUT_BUFFER_SIZE/ 2; 
  }
  
  if(BufferCtl.state == BUFFER_OFFSET_FULL)
  { 
      f_read(&wav_file, &BufferCtl.buff[AUDIO_OUT_BUFFER_SIZE /2], AUDIO_OUT_BUFFER_SIZE/2, (void *)&numOfReadBytes);
      BufferCtl.state = BUFFER_OFFSET_NONE;
      BufferCtl.fptr += AUDIO_OUT_BUFFER_SIZE/ 2; 
  }

  if(BufferCtl.fptr >= info.FileSize)
  {
    printf("end of file is reached\r\n");
  }
}

void music_player_song_end(void)
{
  f_close(&wav_file);
}
/**
  * @brief  Calculates the remaining file size and new position of the pointer.
  * @param  None
  * @retval None
  */
void BSP_AUDIO_OUT_TransferComplete_CallBack(void)
{
  if(AudioState == AUDIO_STATE_PLAY)
  {
    BufferCtl.state = BUFFER_OFFSET_FULL;
  }
}

/**
  * @brief  Manages the DMA Half Transfer complete interrupt.
  * @param  None
  * @retval None
  */
void BSP_AUDIO_OUT_HalfTransfer_CallBack(void)
{ 
  if(AudioState == AUDIO_STATE_PLAY)
  {
    BufferCtl.state = BUFFER_OFFSET_HALF;
  }
}