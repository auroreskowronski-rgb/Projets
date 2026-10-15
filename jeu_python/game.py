import pygame
from ball import Ball
from paddle import Paddle


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
            "BasicBreakoutAssetPack/background.png"
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

    def reset(self):
        #Replace la raquette au centre
        self.player.rect.x = int(round(640 - self.player.rect.width / 2, 0))
        self.player.rect.y = 720 - self.player.rect.height - 10
                
        # Replace la balle juste au-dessus de la raquette
        self.ball.rect.x = int(round(640 - self.ball.rect.width / 2, 0))
        self.ball.rect.y = self.player.rect.y - self.ball.rect.height - 5
        
        # Reinitialise la vitesse de la balle a son etat initial
        self.ball.speed_x= 0
        self.ball.speed_y= -10
        self.ball.is_moving = False

    # Boucle du jeu
    def run(self):
        running = True
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                
                if event.type == pygame.KEYDOWN and event.key == pygame.K_SPACE:
                    self.ball.is_moving = True

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

            self.ball.move(self.player)
            self.ball.check_collision_paddle(self.player)

            pygame.display.flip()
            self.clock.tick(60)

            # Si la balle dépasse le bas de l'écran, on reset
            if self.ball.rect.y > 720:
                self.reset()


   

    pygame.quit()
