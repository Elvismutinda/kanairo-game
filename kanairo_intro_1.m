% This function creates an interactive introduction for the first level
% whereby Baba and Nuru are able to interact. Pressing 'enter' key moves to the
% next line to be displayed

function [speech_end] = kanairo_intro_1

% Loads the background image
background = imread('images/baba_nuru_speech.png');

% Creates a figure with the background image and a dimensio of 1920 by 1080
% at axis 0,0
hfg = figure;
image(background);
set(hfg, 'Position', [0 0 1920 1080])
axis off equal % turning off axis labels

% Loads the background music
[y,Fs] = audioread('music/wakadinali_mc_mca.mp3');
sound(y,Fs)

% This is the keypress callback function that reacts to a key being
% pressed on the keyboard
set(hfg, 'KeyPressFcn', @ScreenIsPressed);
speech_end = 0; % end of speech

% Dialogue lines
line{1} = 'Karibu Nuru';
line{2} = 'We''ve been expecting you for a while now';
line{3} = 'My name is Baba and welcome to Kanairo!';
line{4} = 'For some time now Kanairo has been facing some serious socio-economical problems, hence in need of a Hero!';
line{5} = 'Question is are you up for the task?';

line{6} = 'Of course, I''d do anything for my homeland.';
line{7} = 'What do I need to do?';

line{8} = 'Wait, you''ll actually do it?';
line{9} = 'Awesome, I''ll be giving you any intel I receive on Zakayo''s whereabouts.';
line{10} = 'He is the person you need to talk to in order to save the people.';
line{11} = 'First you will have to navigate through the heart of the city.';
line{12} = 'But be careful, there are thugs roaming around and they won''t let you off that easily.';
line{13} = 'Here''s a small tip for you, but don''t tell anyone...';
line{14} = 'You can use the ''a'' and ''d'' keys to move left and right respectively.';
line{15} = 'Use the''p'' key to punch obstacles you may come across.';
line{16} = 'Use the ''b'' key to block';
line{17} = 'Good luck out there!';

% Getting the total number of lines and then initializing a counter for the
% current line
long = length(line);
count = 1;

% Position and size of the textboxes that will contain the dialogue text
size_left = [.24 .11 .3 .2];
size_right = [.535 .11 .3 .2];

textbox_left = annotation('textbox',size_left,'String','','LineStyle','none','FontSize',15);
textbox_right = annotation('textbox',size_right,'String','','LineStyle','none','FontSize',15);

% This is to ensure that the program is completely finished for successful
% execution of the intro
while speech_end == 0
    drawnow
end

% Callback function for keypress events
    function ScreenIsPressed(~, eventdata)
        switch eventdata.Character
            case 13 % Enter key on the keyboard
                % loop through the lines to display any lines available
                if count <= long
                    % Displaying the lines in the appropriate textbox for
                    % the specific characters
                    if count >= 1 && count <= 5
                        set(textbox_left, 'String', line{count});
                        set(textbox_right, 'String', '');
                    elseif count >= 6 && count <= 7
                        set(textbox_right, 'String', line{count});
                        set(textbox_left, 'String', '');
                    elseif count >= 8 && count <= 17
                        set(textbox_left, 'String', line{count});
                        set(textbox_right, 'String', '');
                    end
                    % Move to the next line
                    count = count + 1;
                else
                    % If all lines are displayed, close the figure and end the scene
                    close all
                    clear all
                    speech_end = 1;
                end
        end
    end
end
