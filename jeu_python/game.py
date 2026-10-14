#!/usr/bin/env python3

import pygame
from paddle import Paddle


class Game:
    # Créer une fenêtre de jeu
    def __init__(self):
        # Taille de la fenêtre
        self.screen = pygame.display.set_mode((1280, 720))
        # Nom de la fenêtre
        pygame.display.set_caption("Dawn Breaker")
        # Charger le fond
        self.fond = pygame.image.load(
            "jeu_python/BasicBreakoutAssetPack/background.png"
        ).convert_alpha()
        # Definit le joueur comme la paddle
        self.player = Paddle()
        # definit la position de la paddle (round(int...)) pour eviter plantage si la hauteur de la paddle est impaire
        self.player.rect.x =  int(round(640 - self.player.rect.width / 2,0))
        self.player.rect.y = 720 - self.player.rect.height  -10

    # Boucle du jeu
    def run(self):
        running = True
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
            self.screen.blit(self.fond, (0, 0))
            self.screen.blit(self.player.image, self.player.rect)
            pygame.display.flip()
            pygame.time.Clock().tick(60)

            # Gestion des touches
            keys = pygame.key.get_pressed()
            if keys[pygame.K_LEFT]:
                self.player.move_left()
            if keys[pygame.K_RIGHT]:
                self.player.move_right()

    pygame.quit()
