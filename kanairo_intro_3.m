% This function creates an interactive introduction for the third level
% whereby Baba and Nuru are able to interact. Pressing 'enter' key moves to the
% next line to be displayed

function [speech_end] = kanairo_intro_3

% Loads the background image
background = imread('images/baba_nuru_speech.png');

% Creates a figure with the background image and a dimensio of 1920 by 1080
% at axis 0,0
hfg = figure;
image(background);
set(hfg, 'Position', [0 0 1920 1080])
axis off equal

% Loads the background music
[y,Fs] = audioread('music/tushangilie_kenya.mp3');
sound(y,Fs)

% This is the keypress callback function that reacts to a key being
% pressed on the keyboard
set(hfg,'KeyPressFcn',@ScreenIsPressed);
speech_end = 0; % end of speech

% Dialogue lines
line{1} = 'WOW! You actually made it past those li--';
line{2} = 'I mean, WOW! I never doubted you even for a second';
line{3} = 'Are you sure you''re not Maasai? (Says Jockingly)';

line{4} = 'I guess I just have a way with animals. Unaweza niita the Lion Whisperer. HAHA';

line{5} = 'Sawa Lion Whisperer, all you need to do now is talk to Zakayo and come to an agreement in order to save the people.';
line{6} = 'However, it won''t be that easy to get to him.';
line{7} = 'State House is heavily guarded with security guards';
line{8} = 'Maybe they might be as impresses as the lions and let you pass!';

line{9} = 'I got this don''t worry!';

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
    function ScreenIsPressed(~,eventdata)
        switch eventdata.Character
            case 13 % Enter key on the keyboard
                % loop through the lines to display any lines available
                if count <= long
                    % Displaying the lines in the appropriate textbox for
                    % the specific characters
                    if count >= 1 && count <= 3
                        set(textbox_left, 'String', line{count});
                        set(textbox_right, 'String', '');
                    elseif count == 4
                        set(textbox_right, 'String', line{count});
                        set(textbox_left, 'String', '');
                    elseif count >= 5 && count <= 8
                        set(textbox_left, 'String', line{count});
                        set(textbox_right, 'String', '');
                    elseif count == 9
                        set(textbox_right, 'String', line{count});
                        set(textbox_left, 'String', '');
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
