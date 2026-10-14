#!/usr/bin/env python3

import pygame


class Game:
    # Créer une fenêtre de jeu
    def __init__(self):
        self.screen = pygame.display.set_mode((1280, 720))
        pygame.display.set_caption("Dawn Breaker")
        self.fond = pygame.image.load(
            "jeu_python/BasicBreakoutAssetPack/background.png"
        ).convert()

    # Boucle du jeu
    def run(self):
        running = True
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
            self.screen.blit(self.fond, (0, 0))
            pygame.display.flip()
    pygame.quit()

        
