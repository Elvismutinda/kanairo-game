% This is the main function creates the whole gameplay and contains all the game logic
function [WIN, levelScore] = KanairoGame(maplevel, collisionmap, victoryMap, DeathMap, levelSong, level)
clc
clf
close all
WIN = 1; % This means the player is still alive and proceeds to the next level

% GAME VARIABLES
% Player movement and abilities
run = 0; % Check if the character is moving or not
jump = 0; % Check if the character is jumping or not
punch = 0; % Check if character is punching or not
defend = 0;
isDefending = false;
vx = 0; % Intial velocity in the x direction
vy = 50; % Initial velocity in the y direction
g= 0; % Initial gravity
InAir = 0; % Checks if the character is in the Air or not
wWidth = 232; % Aritary variable for the camera/equations
dt = 0.5; % Time step
ii = 0; % Amount of iterations in the while loop for frames
life = 5; % Sets the amount of lifes the character has
CollisionState = 1; % State of character collision. If they are touching the ground or not
invincibilityFrames = 0; % This acts as a shield whenever the player comes into contact with an enemy to prevent rapid loss of life

% Player movement and abilites
enemyHealth = 1; % Sets the enemy's health bar state
enemyAlive = true; % If the enemy is alive or not
enemySpeed = 1; % Sets the speed at which the enemy moves
numEnemies = 10; % Sets the number of enemies spawned on the map

victory = 0; % If the player is in victory state or not
cstate = 1; % State of character. If they are alive or dead
levelScore = 0; % Stores the score for each level after the player completes it


% Loads and plays songs for the various levels 
[LevelSong, Song2] = audioread(levelSong);
player = audioplayer(LevelSong, Song2); % the audioplayer object is used to play the audio data
play(player)

% Loads the game over song and image 
[GameOverSong, Song1] = audioread('game_over_song.mp3');
[GameOver, ~, AGameOver] = imread('game_over.png');

% Loads the images for the player's healthbar system
[HealthBarFull, ~, AHealthBarFull] = imread('healthbar_5.png');
[HealthBar4, ~, AHealthBar4] = imread('healthbar_4.png');
[HealthBar3, ~, AHealthBar3] = imread('healthbar_3.png');
[HealthBar2, ~, AHealthBar2] = imread('healthbar_2.png');
[HealthBar1, ~, AHealthBar1] = imread('healthbar_1.png');

% Loads the animation frames for running. flip object is used here with 1
% to flip the character vertically since he's rendered while upside down.
% 1 flips horizontally and 2 flips vertically
[nuruRun1, ~, AnuruRun1] = imread('nuru_run_1.png');
nuruRun1 = flip(nuruRun1, 1);
AnuruRun1 = flip(AnuruRun1, 1);
[nuruRun2, ~, AnuruRun2] = imread('nuru_run_2.png');
nuruRun2 = flip(nuruRun2, 1);
AnuruRun2 = flip(AnuruRun2, 1);
[nuruRun3, ~, AnuruRun3] = imread('nuru_run_3.png');
nuruRun3 = flip(nuruRun3, 1);
AnuruRun3 = flip(AnuruRun3, 1);

% Loads the animation frames for jumping up and down
[nuruJumpUP, ~, AnuruJumpU] = imread('nuru_jump_up.png');
nuruJumpUP = flip(nuruJumpUP, 1); %flips it around because it is upside down
AnuruJumpU = flip(AnuruJumpU, 1);
[nuruJumpDOWN, ~, AnuruJumpD] = imread('nuru_jump_down.png');
nuruJumpDOWN = flip(nuruJumpDOWN, 1);
AnuruJumpD = flip(AnuruJumpD, 1);

% Loads the static image of the character
[Player, ~, alpha] = imread('nuru_static.png');
Player = flip(Player, 1);
alpha = flip(alpha, 1);

% Loads the animation frames for punching
[nuruPunch, ~, AnuruPunch] = imread('nuru_punch.png');
nuruPunch = flip(nuruPunch, 1);
AnuruPunch = flip(AnuruPunch, 1);

% Loads the animation frames for defending
[nuruDefend, ~, AnuruDefend] = imread('nuru_defend.png');
nuruDefend = flip(nuruDefend, 1);
AnuruDefend = flip(AnuruDefend, 1);

% Level-specific enemy images and animations
switch level
    case 1
        [enemyRun1, ~, AenemyRun1] = imread('thug_run_1.png');
        enemyRun1 = flip(flip(enemyRun1, 1), 2);
        AenemyRun1 = flip(flip(AenemyRun1, 1), 2);
        [enemyRun2, ~, AenemyRun2] = imread('thug_run_2.png');
        enemyRun2 = flip(flip(enemyRun2, 1), 2);
        AenemyRun2 = flip(flip(AenemyRun2, 1), 2);
        [enemyRun3, ~, AenemyRun3] = imread('thug_run_3.png');
        enemyRun3 = flip(flip(enemyRun3, 1), 2);
        AenemyRun3 = flip(flip(AenemyRun3, 1), 2);
        [enemyAttack, ~, AenemyAttack] = imread('thug_attack.png');
        enemyAttack = flip(flip(enemyAttack, 1), 2);
        AenemyAttack = flip(flip(AenemyAttack, 1), 2);
        [enemyDead, ~, AenemyDead] = imread('thug_dead.png');
        enemyDead = flip(flip(enemyDead, 1), 2);
        AenemyDead = flip(flip(AenemyDead, 1), 2);
    case 2
        [enemyRun1, ~, AenemyRun1] = imread('lion_walk_1.png');
        enemyRun1 = flip(enemyRun1, 1);
        AenemyRun1 = flip(AenemyRun1, 1);
        [enemyRun2, ~, AenemyRun2] = imread('lion_walk_2.png');
        enemyRun2 = flip(enemyRun2, 1);
        AenemyRun2 = flip(AenemyRun2, 1);
        [enemyRun3, ~, AenemyRun3] = imread('lion_walk_3.png');
        enemyRun3 = flip(enemyRun3, 1);
        AenemyRun3 = flip(AenemyRun3, 1);
        [enemyAttack, ~, AenemyAttack] = imread('lion_walk_3.png');
        enemyAttack = flip(enemyAttack, 1);
        AenemyAttack = flip(AenemyAttack, 1);
        [enemyDead, ~, AenemyDead] = imread('lion_dead.png');
        enemyDead = flip(enemyDead, 2);
        AenemyDead = flip(AenemyDead, 2);
    case 3
        [enemyRun1, ~, AenemyRun1] = imread('soldier_walk_1.png');
        enemyRun1 = flip(flip(enemyRun1, 1), 2);
        AenemyRun1 = flip(flip(AenemyRun1, 1), 2);
        [enemyRun2, ~, AenemyRun2] = imread('soldier_walk_2.png');
        enemyRun2 = flip(flip(enemyRun2, 1), 2);
        AenemyRun2 = flip(flip(AenemyRun2, 1), 2);
        [enemyRun3, ~, AenemyRun3] = imread('soldier_walk_1.png');
        enemyRun3 = flip(flip(enemyRun3, 1), 2);
        AenemyRun3 = flip(flip(AenemyRun3, 1), 2);
        [enemyAttack, ~, AenemyAttack] = imread('soldier_walk_2.png');
        enemyAttack = flip(flip(enemyAttack, 1), 2);
        AenemyAttack = flip(flip(AenemyAttack, 1), 2);
        [enemyDead, ~, AenemyDead] = imread('soldier_walk_1.png');
        enemyDead = imrotate(enemyDead, -90);
        AenemyDead = imrotate(AenemyDead, -90);
    otherwise
        error('Unsupported level');
end

enemyRun = {enemyRun1, enemyRun2, enemyRun3};
AenemyRun = {AenemyRun1, AenemyRun2, AenemyRun3};

% Creates the collision matrix of the character which will follow him
CollisionC = ones(21,16);

% Create enemy collision matrix
enemyCollisionState = ones(1, numEnemies);

% Reads the maplevel and assign it a handle
B = imread(maplevel);

% Gets the alpha data of the collisionmap (so that empty = 0 and 
% collision = 255), victoryMap and DeathMap
[~, ~, Beta] = imread(collisionmap);
Beta = Beta./255; % Makes the collision pixels = 1
Beta = uint16(Beta); % Makes the matrix a unit16
[~, ~, Vmap] = imread(victoryMap);
Vmap = uint16(Vmap);
[~, ~, Dmap] = imread(DeathMap);
Dmap = uint16(Dmap);

% Makes every pixel in death = 375 and victory = 113233
Vmap =  (Vmap ./225).* 113233;
Dmap = (Dmap ./225).*375;

% Adds all these matrix together in a a single matrix
% Now collision = 1, death = 375, victory = 113233 and nothing = 0 in a
% single matix
Beta = Beta + Vmap;
Beta = Beta + Dmap;

% Gets the size of the player
[Ya, Xa, ~] = size(Player);

% Gets the size of the map
[Yb, Xb, ~]= size(B);

% Sets the intial condition/position of the character and what we see of the
% map ( the camera)
y = 100; % Location of the bottom of the character
x = 232; % The center of the camera ( 29*16 blocks)
x1 = x - (232-1); % The left limit of the camera
x2 = x+232; % The right limit of the camera

% Now plotting everything together
hfg = figure; 
image(B); % Plots the RGB value of the map
hold on

% Plots the character and sets its position in the camera
C = image(Player, 'AlphaData', alpha);
set(C, 'XData', [ x1+100 x1+100+Xa], 'YData', [y y-Ya])

% Plots the collison of the character and position it at the same place
ColC = image(CollisionC);
set(ColC, 'XData', [ x1+108 x1+108+16], 'YData', [y y-21], 'Visible', 'off')

% Sets the initial health bar image
HealthBar = image(HealthBarFull, 'AlphaData', AHealthBarFull);
set(HealthBar, 'XData', [x1 + 300 x1 + 300 + 100], 'YData', [10 30]);

% Creates the limits of the camera
ax.XLim = [ x1 x2 ];
ax.YLim = [ 0 Yb];

% Positioning the figure on the screen
set(hfg, 'Position', [0 0 1920 1080])
axis off equal

% Creates the key handles for the figure on the screen
set(hfg,'KeyPressFcn', @keyPress)
set(hfg, 'KeyReleaseFcn', @keyRelease)

% Initialize enemy information
enemies = struct('X', cell(1, numEnemies), 'Y', cell(1, numEnemies), ...
                 'Health', ones(1, numEnemies), 'Alive', true, ...
                 'RunCounter', zeros(1, numEnemies));

% Initialize enemy positions
for i = 1:numEnemies
    enemies(i).X = x + 300 * i;  % Adjust the initial X position of each enemy
    enemies(i).Y = 210;
end

switch level
    case 2
        numEnemies = 3;
        enemies(1).X = 300;
        enemies(1).Y = 210;
        enemies(2).X = 700;
        enemies(2).Y = 180;
        enemies(3).X = 4500;
        enemies(3).Y = 210;
end

% Initialize enemy figure handles
EnemyC = gobjects(1, numEnemies);
for i = 1:numEnemies
    EnemyC(i) = image(enemyRun{1}, 'AlphaData', AenemyRun{1});
    set(EnemyC(i), 'XData', [enemies(i).X enemies(i).X + 16], 'YData', [enemies(i).Y enemies(i).Y - 21]);
end

% This while loop is what contains most of the game logic and it only ends
% if the player wins the level or loses all lifes and dies
while ~victory

    % Enemy logic
    for i = 1:numEnemies
        % Check if the player is close to the current enemy
        distanceToEnemy = sqrt((x - enemies(i).X)^2 + (y - enemies(i).Y)^2);

        if distanceToEnemy < 120 && distanceToEnemy > 118
            % Enemy attack animation
            if ~isDefending
                set(EnemyC(i), 'CData', enemyAttack, 'AlphaData', AenemyAttack);

                % Check if the player is punching and the punch is within the enemy's range
                if punch == 1
                    enemies(i).Health = enemies(i).Health - 1; % Decrease enemy health

                    % Check if the enemy is defeated
                    if enemies(i).Health <= 0
                        % Display the dead image of the enemy
                        set(EnemyC(i), 'CData', enemyDead, 'AlphaData', AenemyDead);
                        enemies(i).Alive = false;  % Set enemy state to dead
                    end
                else
                    % Player is not punching, deduct only one life
                    if invincibilityFrames == 0
                        life = life - 1;
                        invincibilityFrames = 300; % Set a cooldown to prevent rapid loss of life
                    end
                end
            end
        else
            if enemies(i).Alive
                % Increment the enemyRunCounter
                enemies(i).RunCounter = enemies(i).RunCounter + 1;

                % Every 10 loops updates the frames if he is still moving
                if enemies(i).RunCounter == 1
                    set(EnemyC(i), 'Cdata', enemyRun1, 'AlphaData', AenemyRun1);
                elseif enemies(i).RunCounter == 10
                    set(EnemyC(i), 'Cdata', enemyRun2, 'AlphaData', AenemyRun2);
                elseif enemies(i).RunCounter == 20
                    set(EnemyC(i), 'Cdata', enemyRun3, 'AlphaData', AenemyRun3);
                elseif enemies(i).RunCounter == 30
                    set(EnemyC(i), 'Cdata', enemyRun1, 'AlphaData', AenemyRun1);
                    enemies(i).RunCounter = 0;
                end

                % Update enemy position
                set(EnemyC(i), 'XData', [enemies(i).X enemies(i).X + 16], 'YData', [enemies(i).Y enemies(i).Y - 21]);

                % Calculate the direction towards the player
                enemyDirection = -1;

                % Move the enemy towards the player
                enemies(i).X = enemies(i).X + enemyDirection * enemySpeed;
            end
        end
        
        % Check if the enemy is defeated
        if enemies(i).Health <= 0
            % Display the dead image of the enemy
            set(EnemyC(i), 'CData', enemyDead, 'AlphaData', AenemyDead);
        else
            % Increment the enemyRunCounter
            enemies(i).RunCounter = enemies(i).RunCounter + 1;

            % Every 10 loops updates the frames if he is still moving
            if enemies(i).RunCounter == 1
                set(EnemyC(i), 'Cdata', enemyRun1, 'AlphaData', AenemyRun1);
            elseif enemies(i).RunCounter == 10
                set(EnemyC(i), 'Cdata', enemyRun2, 'AlphaData', AenemyRun2);
            elseif enemies(i).RunCounter == 20
                set(EnemyC(i), 'Cdata', enemyRun3, 'AlphaData', AenemyRun3);
            elseif enemies(i).RunCounter == 30
                set(EnemyC(i), 'Cdata', enemyRun1, 'AlphaData', AenemyRun1);
                enemies(i).RunCounter = 0;
            end

            % Update enemy position
            set(EnemyC(i), 'XData', [enemies(i).X enemies(i).X + 16], 'YData', [enemies(i).Y enemies(i).Y - 21]);
    
            % Calculate the direction towards the player
            enemyDirection = -1;
        
            % Move the enemy towards the player
            enemies(i).X = enemies(i).X + enemyDirection * enemySpeed;
        end
    end

    % Condition containing the logic for when the character is in the alive state
    if cstate == 1 
        % Updates the health bar depending on how many lifes the player has
        % left
        if life == 4
            set(HealthBar, 'CData', HealthBar4, 'AlphaData', AHealthBar4);
        elseif life == 3
            set(HealthBar, 'CData', HealthBar3, 'AlphaData', AHealthBar3);
        elseif life == 2
            set(HealthBar, 'CData', HealthBar2, 'AlphaData', AHealthBar2);
        elseif life == 1
            set(HealthBar, 'CData', HealthBar1, 'AlphaData', AHealthBar1);
        elseif life == 0
            cstate = 0; % Character is dead if there are no more lifes left
        end
        
        % Frames for the character while they jump
        if jump == 1
            % Jumping up
            if vy < 0
                set(C, 'Cdata', nuruJumpUP, 'AlphaData', AnuruJumpU);
            % Going down
            elseif vy > 0
                set(C, 'Cdata', nuruJumpDOWN, 'AlphaData', AnuruJumpD);
            % When on the ground and not in any jump state
            else
                set(C, 'Cdata', Player, 'AlphaData', alpha);
            end
        % Frames for the character while they run
        elseif run == 1
            ii = ii +1; %counts the number of while loop iteration
            %every 10 loops updates the frames if he is still moving
            if ii == 1
                set(C, 'Cdata', nuruRun1, 'AlphaData', AnuruRun1);
            elseif ii == 10
                set(C, 'Cdata', nuruRun2, 'AlphaData', AnuruRun2);
            elseif ii == 20
                set(C, 'Cdata', nuruRun3, 'AlphaData', AnuruRun3);
            elseif ii == 30
                set(C, 'Cdata', Player, 'AlphaData', alpha);
                ii = 0;  
            end
        % Frame for the character punching
        elseif punch == 1
            set(C, 'Cdata', nuruPunch, 'AlphaData', AnuruPunch);
        elseif defend == 1
            isDefending = true;
            set(C, 'Cdata', nuruDefend, 'AlphaData', AnuruDefend);
        % If the character is not in motion, sets him to his original state    
        else
            set(C, 'Cdata', Player, 'AlphaData', alpha);
            ii = 0; % Starts the loop counter again
        end

        % Calculates the upcoming y position of the character for a given Vy
        vy  = vy + g*0.1;
        y = y + vy*0.1;
        % Find the Y border of the collisionMap of the character
        Yd = [round(y) round(y-21)];
        
        % Rescales the borders of the Y if it ends up out of the map
        if 1>Yd(2) 
            y = 22;
            Yd(2) =1;
            Yd(1) = 22;
        elseif  303<Yd(1)
            Yd(2) = 303-21;
            Yd(1) = 303;
            y = 303; 
        end
        
        % Checks if the character is in collision range or not, if he is
        % not then sets him as 'in the air'
        if CollisionState == 0
           InAir = 1; %is in the air so gravity is acting
           g = 10;
        else 
           InAir = 0;
           vy=0; %is not in the air so no y velocity or gravity
           jump = 0;
           g=0;
        end
      
        % Calculates the upcoming x position (middle of the camera)
        x = x + vx * dt;
        
        % If x is out of borders, rescale it
        if x+wWidth > Xb
            x = Xb-wWidth-eps;
        elseif x-wWidth < 1
            x = wWidth+eps;
        end
        
        % Sets the border of the camera depending on x
        x1 = x-wWidth;
        x2 = x+wWidth;
        % Finds the x border of the collision of the character
        Xd  = [round(x1+108) round(x1+108+16)];
        
        % Checks the matrix under the character to see if he is on a platform by summing the Betamatrix of the same location. If it is 0 then he is not on a floor and collision = 0
        GMatrix = sum(Beta(Yd(1)+1, Xd(1):Xd(2)));
        if GMatrix == 0  
            CollisionState = 0;
        else 
            g = 0;
        end
        
        % Sums up twice the Beta matrix at the same location that the
        % character to find if he is in a wall, dead, or won the game
        SmallCollision = Beta(Yd(2):Yd(1), Xd(1):Xd(2));
        Asum = sum(SmallCollision);
        DAsum = sum(Asum);
        
        % We first check victory, then we check death, then we check
        % collision
        % If the sum is bigger than 65535-1, then he is in the victory area,
        % end of the loop, end of the level
        if DAsum > 65535-1
            victory = 1;

            % Calculate score for the level based on the number of lives left
            switch life
                case 5
                    levelScore = 100;
                case 4
                    levelScore = 80;
                case 3
                    levelScore = 60;
                case 2
                    levelScore = 40;
                case 1
                    levelScore = 20;
                otherwise
                    levelScore = 0;
            end
        % If the sum is now bigger than 375-1 then he hit a death zone
        elseif DAsum >375-1
            % Takes away a life, reset the character and camera at the
            % start of the level
            life = life -1;
            y = 100;
            x = 232;
            x1 = x - (232-1);
            x2 = x+232;
            set(ColC, 'XData', [ x1+108 x1+108+16], 'YData', [y y-21], 'Visible', 'off')
            set(C, 'XData', [ x1+100 x1+100+Xa], 'YData', [y y-Ya])
            axis([x1 x2 0 Yb])

        % If the sum is bigger than 0 now, means he is in a wall    
        elseif DAsum >0
            % Finds the Beta matrix at one pixel shifted in every direction
            BetaC_up = Beta(Yd(2)-1 :Yd(1)-1, Xd(1):Xd(2)); %shifted up
            BetaC_down = Beta(Yd(2)+1 :Yd(1)+1, Xd(1):Xd(2)); %shifted down
            BetaC_left = Beta(Yd(2) :Yd(1), Xd(1)-1:Xd(2)-1); %shifted left
            BetaC_right = Beta(Yd(2) :Yd(1), Xd(1)+1:Xd(2)+1); %shifted right

            Sum_up = sum(sum(BetaC_up)); %double sum the up shifted matrix
            Sum_down = sum(sum(BetaC_down)); %double sum the down shifted matrix
            Sum_left = sum(sum(BetaC_left)); %double sum the left shifted matrix
            Sum_right = sum(sum(BetaC_right)); %double sum the right shifted matrix
            
            % Compares the up and down shifted matrix, then the left and
            % rigth shifted matrix, and from this we can tell which side and
            % how much pixel he is 'in' the wall and then pushes him back than
            % much in the opposite direction 
            
            % The caharacter is hitting the ground under him
            if Sum_up < DAsum && Sum_down > DAsum 
                CollisionState = 1;
                y = y - DAsum/16;
            
            % The character is hitting a ceiling above him
            elseif Sum_up > DAsum && Sum_down < DAsum 
                CollisionState = 1;
                y = y + DAsum/16;
            
            % The character is hitting a wall on the left side of him
            elseif  Sum_left > DAsum && Sum_right < DAsum
                CollisionState = 1;
                x = x + DAsum/21;
            
            % The character is hitting a wall on the right side of him
            elseif  Sum_left < DAsum && Sum_right > DAsum
                CollisionState = 1;
                x = x - DAsum/21;
            end
            
        % Plots the camera and character and everything on the right 
        % position if he is not hitting anything    
        else
            axis([x1 x2 0 Yb])
            set(C, 'XData', [ x1+100 x1+100+Xa], 'YData', [y y-Ya])
            set(ColC, 'XData', [ x1+108 x1+108+16], 'YData', [y y-21])
            set(HealthBar, 'XData', [ x1+300 x1+300+100], 'YData', [10 30])
        end

    % Condition containing the logic for when the character is in the dead state
    elseif cstate == 0
        close all % Closes all windows

        % Plays the game over audio
        player = audioplayer(GameOverSong,Song1);
        play(player)

        % Plots the game over image on the screen
        hfg = figure;
        image(GameOver, 'AlphaData', AGameOver);
        set(hfg, 'Position', [0 0 1920 1080]); 
        axis off

        % Returns the WIN ouput as 0 meaning the player lost all lifes
        WIN = 0;

        % Waits for a keyboard or mouse input, when it happens breaks out of
        % the while loop and ends the game
        k = waitforbuttonpress;
        if k == 1 || k == 0
            break
        end
     
    end
    % Keeps updating the images
    drawnow
    
end
close all

    % Function to handle keyboard inputs when pressed by the player
    function keyPress(~, eventdata)
        switch eventdata.Character
            % Character movement to the right
            case 'd'
                vx = 7;
                run = 1;
            
            % Character movement to the left
            case 'a'
                vx = -7;
                run = 1;
            
            % Character jumping 
            case 'w'
                % Makes him be in the air with no collision
                CollisionState = 0;
                jump = 1;
                % Only creates a jumping initial velocity if the player is touching
                % the ground (so there are no double jumps)
                if InAir == 0
                    vy = -40;
                end
               
            % Character punching
            case 'p'
                punch = 1;

            % Character blocking
            case 'b'
                defend = 1;
                isDefending = true;

            % Skipping the level. This is just for presentation purposes in
            % case we don't need to show the whole gameplay
            case 'n'
                victory = true;
                close all
        end
    end

    % Function to handle release of keyboard inputs
    function keyRelease(~, eventdata)
        switch eventdata.Character
            % Stops the character from moving right
            case 'd'
                run = 0;
                vx = 0;
            
            % Stops the character from moving left
            case 'a'
                vx = 0;
                run = 0; 

            % Stops the character's punching animation
            case 'p'
                punch = 0;

            % Stops the character's blocking animation
            case 'b'
                defend = 0;
                isDefending = false;
        end
    end
end