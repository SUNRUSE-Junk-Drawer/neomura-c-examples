#include "../../submodules/neomura/c-library/neomura.h"

STATE_DECLARATION(x, u16_t)
STATE_DECLARATION(y, u16_t)

#define STATE_MOTION_LEFT 1
#define STATE_MOTION_UP 2

STATE_DECLARATION(motion, u8_t)
