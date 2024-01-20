% This fuunction handles the figure that displays the total store
% accumulated by the player in all levels

function total_score(totalScore)

    % Loads the background image
    background = imread('images/total_score.png');

    % Creates a figure with the background image and a dimensio of 1920 by 1080
    % at axis 0,0
    hfg = figure;
    image(background);
    set(hfg, 'Position', [0 0 1920 1080])
    axis off equal % turning off axis labels

    % Loads the background music
    [y,Fs] = audioread('music/score.mp3');
    sound(y,Fs)

    textProps = {'Color', 'white', 'FontSize', 64, 'HorizontalAlignment', 'center', 'FontName', 'NEW ACADEMY'};

    text(520, 300, [num2str(totalScore)], textProps{:});

    % This is the keypress callback function that reacts to a key being
    % pressed on the keyboard
    set(hfg, 'KeyPressFcn', @KeyPressCallback);

    % Wait for the player to press Enter
    waitfor(hfg);

    % Callback function for keypress events
    function KeyPressCallback(~, eventdata)
        switch eventdata.Character
            case 13 % Enter key on the keyboard
                % Close the figure
                close all;
                clear all;
        end
    end

end