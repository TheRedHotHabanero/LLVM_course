#include <SFML/Graphics.hpp>
#include <ctime>
// #include <omp.h>

#include "life.h"

void LifeGame::updateGrid(std::vector<std::vector<bool>> &grid, std::vector<std::vector<bool>> &nextGrid) {
    // #pragma omp parallel for
    for (int x = 0; x < GRID_WIDTH; x++) {
        for (int y = 0; y < GRID_HEIGHT; y++) {
            int aliveNeighbors = 0;
            for (int dx = -1; dx <= 1; ++dx) {
                for (int dy = -1; dy <= 1; ++dy) {
                    if (dx == 0 && dy == 0) {
                        continue;
                    }
                    int nx = x + dx;
                    int ny = y + dy;
                    if (nx >= 0 && nx < GRID_WIDTH && ny >= 0 && ny < GRID_HEIGHT && grid[nx][ny]) {
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
    grid = nextGrid;
}

void LifeGame::drawGrid(sf::RenderWindow& window, std::vector<std::vector<bool>> &grid) {

    window.clear();

    sf::RectangleShape cell(sf::Vector2f(CELL_SIZE, CELL_SIZE));

    // Total aqua disco
    cell.setFillColor(sf::Color(rand(), rand(), rand())); // Rectangle color
    cell.setOutlineColor(sf::Color(rand(), rand(), rand())); // Border colors
    cell.setOutlineThickness((float)3.0);

    for (int x = 0; x < GRID_WIDTH; ++x) {
        for (int y = 0; y < GRID_HEIGHT; ++y) {
            if (grid[x][y]) {
                cell.setPosition(x * CELL_SIZE, y * CELL_SIZE);
                window.draw(cell);
            }
        }
    }

    Menu::create_icon("../images/naruto.png", window);
    window.display();
}

void Menu::create_icon(const std::string &icon_, sf::RenderWindow &window_) {
    sf::Image icon;
    icon.loadFromFile(icon_);
    window_.setIcon(64, 64, icon.getPixelsPtr());
}
