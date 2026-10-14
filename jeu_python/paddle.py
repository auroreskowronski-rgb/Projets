import pygame


class Paddle(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.image = pygame.image.load(
            "BasicBreakoutAssetPack/paddle.png"
        ).convert_alpha()
        self.rect = self.image.get_rect()
        # Vitesse de déplacement de la paddle
        self.speed = 10

    def move_left(self):
        self.rect.x -= self.speed
        self.rect.x = max(self.rect.x, 0)

    def move_right(self):
        self.rect.x += self.speed
        self.rect.x = min(self.rect.x, 1280 - self.rect.width)
