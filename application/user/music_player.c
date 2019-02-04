#include "music_player.h"
#include "main.h"
#include <string.h>

extern uint16_t AUDIO_SAMPLE[];
#define AUDIO_FILE_SZE          990000
#define AUIDO_START_ADDRESS     58 /* Offset relative to audio file header size */
static AUDIO_OUT_BufferTypeDef  BufferCtl;
WAVE_FormatTypeDef *header = (WAVE_FormatTypeDef *)AUDIO_SAMPLE;
uint8_t *audio_ptr = (uint8_t *)(AUDIO_SAMPLE) + AUIDO_START_ADDRESS;
AUDIO_PLAYBACK_StateTypeDef AudioState = AUDIO_STATE_IDLE;

void music_player_init(void)
{
    if (BSP_AUDIO_OUT_Init(OUTPUT_DEVICE_HEADPHONE, 70, AUDIO_FREQUENCY_48K) != 0)
    {
        printf("init audio failed\r\n");
    }

    BSP_AUDIO_OUT_SetAudioFrameSlot(CODEC_AUDIOFRAME_SLOT_02);
    BufferCtl.state = BUFFER_OFFSET_NONE;
}

void music_player_play(void)
{
    // load the first audio frame
    memcpy(&BufferCtl.buff[0], audio_ptr, AUDIO_OUT_BUFFER_SIZE);
    AudioState = AUDIO_STATE_PLAY;
    BufferCtl.fptr = AUDIO_OUT_BUFFER_SIZE;
    BSP_AUDIO_OUT_Play((uint16_t*)&BufferCtl.buff[0], AUDIO_OUT_BUFFER_SIZE);
}

void music_player_process(void)
{
    if(BufferCtl.state == BUFFER_OFFSET_HALF)
    {
        memcpy(&BufferCtl.buff[0], (audio_ptr + BufferCtl.fptr), AUDIO_OUT_BUFFER_SIZE/ 2);
        BufferCtl.state = BUFFER_OFFSET_NONE;
        BufferCtl.fptr += AUDIO_OUT_BUFFER_SIZE/ 2; 
    }
    
    if(BufferCtl.state == BUFFER_OFFSET_FULL)
    { 
        memcpy(&BufferCtl.buff[AUDIO_OUT_BUFFER_SIZE /2], (audio_ptr + BufferCtl.fptr), AUDIO_OUT_BUFFER_SIZE/ 2);
        BufferCtl.state = BUFFER_OFFSET_NONE;
        BufferCtl.fptr += AUDIO_OUT_BUFFER_SIZE/ 2; 
    }
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