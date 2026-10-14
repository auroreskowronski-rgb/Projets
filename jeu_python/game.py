#!/usr/bin/env python3

import pygame
from paddle import Paddle
from ball import Ball


class Game:
    # Créer une fenêtre de jeu
    def __init__(self):
        # Taille de la fenêtre
        self.screen = pygame.display.set_mode((1280, 720))
        # Nom de la fenêtre
        pygame.display.set_caption("Dawn Breaker")
        self.clock = pygame.time.Clock()
        # Charger le fond
        self.fond = pygame.image.load(
            "jeu_python/BasicBreakoutAssetPack/background.png"
        ).convert_alpha()
        # Definit le joueur comme la paddle
        self.player = Paddle()
        # definit la position de la paddle (round(int...)) pour eviter plantage si la hauteur de la paddle est impaire
        self.player.rect.x = int(round(640 - self.player.rect.width / 2, 0))
        self.player.rect.y = 720 - self.player.rect.height - 10

        # 2. Instanciation de la balle
        self.ball = Ball()
        # Positionner la balle au centre, juste au-dessus de la raquette
        self.ball.rect.x = int(round(640 - self.ball.rect.width / 2, 0))
        self.ball.rect.y = self.player.rect.y - self.ball.rect.height - 5

    # Boucle du jeu
    def run(self):
        running = True
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
            
            # Affichage
            self.screen.blit(self.fond, (0, 0))
            self.screen.blit(self.player.image, self.player.rect)
            self.screen.blit(self.ball.image, self.ball.rect)
           

            # Gestion des touches
            keys = pygame.key.get_pressed()
            if keys[pygame.K_LEFT]:
                self.player.move_left()
            if keys[pygame.K_RIGHT]:
                self.player.move_right()

            self.ball.move()
            self.ball.check_collision_paddle(self.player)


            pygame.display.flip()
            self.clock.tick(60)

    pygame.quit()
