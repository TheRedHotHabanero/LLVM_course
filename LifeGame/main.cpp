#include <SFML/Graphics.hpp>
#include <vector>
#include <ctime>
#include <iostream>

#include "life.h"


std::vector<std::vector<bool>> grid(GRID_WIDTH, std::vector<bool>(GRID_HEIGHT, false));
std::vector<std::vector<bool>> nextGrid(GRID_WIDTH, std::vector<bool>(GRID_HEIGHT, false));

int main() {
    srand(static_cast<uint8_t>(time(nullptr)));

    sf::RenderWindow window(sf::VideoMode(WIDTH, HEIGHT), "Game of Life");
    Menu::create_icon("../naruto.png", window);
    window.display();

    bool settingInitialState = true;
    while (window.isOpen() && settingInitialState) {
        sf::Event event;
        while (window.pollEvent(event)) {
            if (event.type == sf::Event::Closed || sf::Keyboard::isKeyPressed(sf::Keyboard::Escape)) {
                window.close();
            }
        }
        if (sf::Mouse::isButtonPressed(sf::Mouse::Left) && settingInitialState) {
            // Обработка щелчка мыши для установки состояния клетки
            sf::Vector2i mousePosition = sf::Mouse::getPosition(window);
            int x = mousePosition.x / CELL_SIZE;
            int y = mousePosition.y / CELL_SIZE;
            // Проверяем, что координаты внутри игровой сетки
            if (x >= 0 && x < GRID_WIDTH && y >= 0 && y < GRID_HEIGHT) {
                grid[x][y] = !grid[x][y]; // Инвертируем состояние клетки
            }
            LifeGame::drawGrid(window, grid);
        }
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::Space)) {
            // Завершение установки начального состояния
            settingInitialState = false;
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

