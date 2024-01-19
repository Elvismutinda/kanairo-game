% This is a class definition that uses the app designer code syntax to
% create the Main Menu for the game where the player can start the game or
% exit.

classdef KanairoGameApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = private)
        UIFigure      matlab.ui.Figure
        StartButton   matlab.ui.control.Button
        ExitButton    matlab.ui.control.Button
    end

    methods (Access = private)

        % Callback function for StartButton
        function startGame(~, ~)
            % Clear everything for the game to start
            close all;
        
            % Defining the 3 levels information
            levels = {
                struct('map', 'nairobi_city_map.jpg', 'collision', 'nairobi_city_collision_map.png', 'victory', 'nairobi_city_victory_map.png', 'death', 'nairobi_city_death_map.png', 'audio', 'wakadinali_mc_mca.mp3'),...
                struct('map', 'nairobi_park_map.jpg', 'collision', 'nairobi_park_collision_map.png', 'victory', 'nairobi_park_victory_map.png', 'death', 'nairobi_park_death_map.png', 'audio', 'hakuna_matata.mp3'),...
                struct('map', 'state_house_map.jpg', 'collision', 'state_house_collision_map.png', 'victory', 'state_house_victory_map.png', 'death', 'state_house_death_map.png', 'audio', 'tushangilie_kenya.mp3')
            };

            % Initializing the total score that is accumulated for every
            % level
            totalScore = 0;
        
            % Iterating through levels
            for levelIndex = 1:length(levels)
                % Load intro for the current level
                feval(['kanairo_intro_' num2str(levelIndex)]);
        
                % Load level based on the current level information
                [WIN, levelScore] = KanairoGame(levels{levelIndex}.map, levels{levelIndex}.collision, levels{levelIndex}.victory, levels{levelIndex}.death, levels{levelIndex}.audio, levelIndex);
        
                % Check if the player won
                if WIN == 0
                    return;
                end

                % Update the total score after each level
                totalScore = totalScore + levelScore;
            end
        
            % Load ending scene
            kanairo_ending();
            total_score(totalScore);
        end


        % Callback function for ExitButton
        function exitGame(app, ~)
            close(app.UIFigure);
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure
            app.UIFigure = uifigure('Name', 'KanairoGameApp', 'Position', [100, 100, 640, 480]);
        
            % Add an Axes component for the background image
            backgroundAxes = uiaxes(app.UIFigure, 'Position', [-20, -20, 680, 510]);
            app.UIFigure.Children = backgroundAxes;
        
            % Load and set the background image
            backgroundImage = imread('main_menu.jpg'); % Provide the path to your image
            backgroundAxes.XLim = [0 1];
            backgroundAxes.YLim = [0 1];
            image(backgroundAxes, 'CData', flipud(backgroundImage), 'XData', [0 1], 'YData', [0 1]);
        
            fontName = 'Franklin Gothic Heavy';
            fontSize = 16;
        
            app.StartButton = uibutton(app.UIFigure, 'Text', 'Start Game', 'Position', [270, 240, 100, 30], ...
                'ButtonPushedFcn', @(~, ~) app.startGame, 'FontName', fontName, 'FontSize', fontSize, 'BackgroundColor', [0.7, 0.7, 0.7]);
        
            app.ExitButton = uibutton(app.UIFigure, 'Text', 'Exit', 'Position', [270, 190, 100, 30], ...
                'ButtonPushedFcn', @(~, ~) app.exitGame, 'FontName', fontName, 'FontSize', fontSize, 'BackgroundColor', [0.7, 0.7, 0.7]);
        
        end
    end

    methods (Access = public)

        % Construct app
        function app = KanairoGameApp
            % Create and configure components
            createComponents(app);

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end
end
