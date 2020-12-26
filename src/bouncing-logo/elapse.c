#include "state.h"
#include "video.h"
#include "elapse.h"

void elapse_axis(u16_t *position, u8_t motion_reverse_bit, u16_t canvas_size, u8_t logo_size)
{
  if (state_motion_buffer & motion_reverse_bit)
  {
    if (*position > 0)
    {
      (*position)--;
    }
    else
    {
      state_motion_buffer &= ~motion_reverse_bit;
      (*position)++;
    }
  }
  else
  {
    if (*position < canvas_size - logo_size)
    {
      (*position)++;
    }
    else
    {
      state_motion_buffer |= motion_reverse_bit;
      (*position)--;
    }
  }
}

ELAPSE_IMPLEMENTATION
{
  elapse_axis(&state_x_buffer, STATE_MOTION_LEFT, VIDEO_WIDTH, 128);
  elapse_axis(&state_y_buffer, STATE_MOTION_UP, VIDEO_HEIGHT, 32);
}
