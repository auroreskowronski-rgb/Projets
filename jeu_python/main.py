#!/usr/bin/env python3

import pygame
import pytmx
from game import Game
from paddle import Paddle

"""jeu_python.main"""

__author__ = "skowro_j"

# Initialisation de Pygame
pygame.init()




if __name__ == "__main__":
    game = Game()
    game.run()

# Générer un joueur

