import pygame


class Brick(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.sprite_sheet = pygame.image.load(
            "BasicBreakoutAssetPack/blocks.png"
        ).convert_alpha()
        self.image = self.get_image(0, 0)
        self.rect = self.image.get_rect()

    def get_image(self, x, y):
        image = pygame.Surface((61, 28))
        image.blit(self.sprite_sheet, (0, 0), pygame.Rect(x, y, 61, 28))
        return image
