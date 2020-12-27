#include "video.h"
#include "state.h"
#include "logo.ase.h"

VIDEO_IMPLEMENTATION
{
  sprite_animation_draw(logo_rainbow, state_elapsed_buffer, state_x_buffer, state_y_buffer, video_buffer, video_width, video_height);
}
