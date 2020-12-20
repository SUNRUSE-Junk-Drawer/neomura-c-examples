#include "../../submodules/neomura/c-library/neomura.h"

REFRESH_RATE(60)

#define VIDEO_WIDTH 270
#define VIDEO_HEIGHT 180

#define LOGO_WIDTH 64
#define LOGO_HEIGHT 48

STATE(x, u16_t)
STATE(y, u16_t)

#define STATE_MOTION_LEFT 1
#define STATE_MOTION_UP 2

STATE(motion, u8_t)

void elapse_axis(u16_t * position, u8_t motion_reverse_bit, u8_t logo_size) {
  if (state_motion_buffer & motion_reverse_bit) {
    if (*position > 0) {
      (*position)--;
    } else {
      state_motion_buffer &= ~motion_reverse_bit;
      (*position)++;
    }
  } else {
    if (*position < VIDEO_WIDTH - logo_size) {
      (*position)++;
    } else {
      state_motion_buffer |= motion_reverse_bit;
      (*position)--;
    }
  }
}

ELAPSE() {
  elapse_axis(&state_x_buffer, STATE_MOTION_LEFT, LOGO_WIDTH);
  elapse_axis(&state_y_buffer, STATE_MOTION_UP, LOGO_HEIGHT);
}

VIDEO(VIDEO_WIDTH, VIDEO_HEIGHT) {
  video_buffer[0]++;
}
