#include "sim.h"

bool grid[SIM_X_SIZE][SIM_Y_SIZE];
bool nextGrid[SIM_X_SIZE][SIM_Y_SIZE];

void initializeGrid() {
    for (int x = 225; x < SIM_X_SIZE / 2 + 100; x++) {
        for (int y = 225; y < SIM_Y_SIZE / 2 + 100; y++) {
            grid[x][y] = simRand() % 2 == 1;
        }
    }
}

void drawGrid() {
    for (int x = 0; x < SIM_X_SIZE; ++x) {
        for (int y = 0; y < SIM_Y_SIZE; ++y) {
            if (grid[x][y]) {
                simPutPixel(x, y, 0xFFFF0000);
            }
        }
    }
    simFlush();
}

void app() {
    initializeGrid();

    for (int step = 0; step < 1000; ++step) {
        for (int x = 0; x < SIM_X_SIZE; x++) {
            for (int y = 0; y < SIM_Y_SIZE; y++) {
                int aliveNeighbors = 0;
                for (int dx = -1; dx <= 1; ++dx) {
                    for (int dy = -1; dy <= 1; ++dy) {
                        if (dx == 0 && dy == 0) {
                            continue;
                        }
                        int nx = x + dx;
                        int ny = y + dy;
                        if (nx >= 0 && nx < SIM_X_SIZE && ny >= 0 && ny < SIM_Y_SIZE && grid[nx][ny]) {
                            aliveNeighbors++;
                        }
                    }
                }
                if (grid[x][y]) {
                    nextGrid[x][y] = (aliveNeighbors == 2 || aliveNeighbors == 3);
                } else {
                    nextGrid[x][y] = (aliveNeighbors == 3);
                }
            }
        }

        for (int x = 0; x < SIM_X_SIZE; x++) {
            for (int y = 0; y < SIM_Y_SIZE; y++) {
                grid[x][y] = nextGrid[x][y];
            }
        }
        drawGrid();
    }
}
