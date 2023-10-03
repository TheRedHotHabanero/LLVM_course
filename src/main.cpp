#include "../include/life.h"
#include <SFML/Graphics.hpp>
#include <vector>
#include <ctime>
#include <cstdlib>
#include <omp.h>

std::vector<std::vector<bool>> grid(GRID_WIDTH, std::vector<bool>(GRID_HEIGHT, false));
std::vector<std::vector<bool>> nextGrid(GRID_WIDTH, std::vector<bool>(GRID_HEIGHT, false));

int main() {
    srand(static_cast<uint8_t>(time(nullptr)));

    sf::RenderWindow window(sf::VideoMode(WIDTH, HEIGHT), "Game of Life");
    Menu::create_icon("icon.jpg", window);
    window.display();

    // Begins with random values
    for (int x = 100; x < GRID_WIDTH / 2; x++) {
        for (int y = 0; y < GRID_HEIGHT / 2; y++) {
            grid[x][y] = (rand() % 2 == 1);
        }
    }

    sf::Clock clock;
    double deltaTime = (float)0.0;
    double updateInterval = (float)0.0;

    while (window.isOpen()) {
        sf::Event event;
        while (window.pollEvent(event)) {
            if (event.type == sf::Event::Closed || sf::Keyboard::isKeyPressed(sf::Keyboard::Escape)) {
                window.close();
            }
        }

        deltaTime += clock.restart().asSeconds();

        if (deltaTime >= updateInterval) {
            LifeGame::updateGrid(grid, nextGrid);
            deltaTime = (float)0.0;
        }

        LifeGame::drawGrid(window, grid);
    }

    return 0;
}

