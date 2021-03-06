local GameConstants = {
    Mode = {RED = 1, BLUE = 2},
    Dir = {UP = 1, LEFT = 2, DOWN = 3, RIGHT = 4},
    Tile = {
        FLOOR = 1,
        DEVIL_EXIT = 2,
        ANGEL_EXIT = 3,
        BLOCK = 4,
        WALL = 5,
        WALL_TOP = 6,
        BRICK_LEFT = 7,
        BRICK_RIGHT = 8,
        BRICK_BOT = 9,
        DEVIL_END = 10,
        ANGEL_END = 11,
        ANGEL_WIN = 12,
        DEVIL_WIN = 14
    },
    TILE_SIZE = 64,
    SCREEN_WIDTH = 1024,
    SCREEN_HEIGHT = 576,
    State = {MENU = 0, PLAYING = 1, LVL_SELECT = 3}
}

return GameConstants
