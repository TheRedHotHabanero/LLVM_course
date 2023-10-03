#pragma once

#include <SFML/Graphics.hpp>

const int WIDTH = 1400;
const int HEIGHT = 800;
const int CELL_SIZE = 4;
const int GRID_WIDTH = WIDTH / CELL_SIZE;
const int GRID_HEIGHT = HEIGHT / CELL_SIZE;

namespace Menu {
    void create_icon(const std::string& icon_, sf::RenderWindow &window_);
}

namespace LifeGame {
    void updateGrid(std::vector<std::vector<bool>> &grid, std::vector<std::vector<bool>> &nextGrid);
    void drawGrid(sf::RenderWindow& window, std::vector<std::vector<bool>> &grid);
}