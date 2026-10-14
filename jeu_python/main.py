#!/usr/bin/env python3

import pygame
from game import Game

"""jeu_python.main"""

__author__ = "skowro_j"

# Initialisation de Pygame
pygame.init()


if __name__ == "__main__":
    game = Game()
    game.run()
