#!/usr/bin/env python3

import pygame

class Paddle(pygame.sprite.Sprite):

    def __init__(self):
        super().__init__()
        self.sprite.sheet = pygame.image.load("jeu_python/BasicBreakoutAssetPack/paddle.png")
        self.rect = self.sprite.sheet.get_rect()