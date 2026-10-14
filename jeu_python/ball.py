import math

import pygame
import utilities
from paddle import Paddle


class Ball(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.image = pygame.image.load(
            "BasicBreakoutAssetPack/ball.png"
        ).convert_alpha()
        self.rect = self.image.get_rect()
        # Vitesse de déplacement de la balle
        self.speed_x = 0
        self.speed_y = -10

    def move(self):
        
        self.rect.x += self.speed_x

        self.rect.y += self.speed_y

        # Rebond sur le mur gauche
        if self.rect.x <= 0:
            self.rect.x = 0
            self.speed_x = -self.speed_x

        # Rebond sur le mur droit (1280 est la largeur de l'écran)
        if self.rect.x >= 1280 - self.rect.width:
            self.rect.x = 1280 - self.rect.width
            self.speed_x = -self.speed_x

        # Rebond sur le haut de l'écran
        if self.rect.y <= 0:
            self.rect.y = 0
            self.speed_y = -self.speed_y

    def check_collision_paddle(self, paddle):
        # Vérifie si la balle touche la raquette
        if not self.rect.colliderect(paddle.rect):
            return
        
        amp_vect_1 = utilities.amplitude_vector(self.speed_x, self.speed_y)
        # Inverser la vitesse verticale pour faire rebondir la balle vers le haut
        # Repositionner la balle juste au dessus de la paddle (anti-bug)
        self.rect.bottom = paddle.rect.top
        #Calculer le décalage entre le centre de la balle et le centre de la raquette
        ball_center = self.rect.centerx
        paddle_center = paddle.rect.centerx
        offset = ball_center - paddle_center
        # Ajuster la vitesse sur l'axe X selon l'endroit de l'impact
        self.speed_x =(abs(offset) ** 2 * 0.01)
        # Ajuster la vitesse sur l'axe y en fonction de la vitesse de x
       
        
        self.speed_y =((amp_vect_1**2 - self.speed_x**2)**0.5)
        self.speed_y = -self.speed_y

        if offset < 0:
                    self.speed_x = -self.speed_x

        print(self.speed_x, self.speed_y, amp_vect_1, (self.speed_y))
