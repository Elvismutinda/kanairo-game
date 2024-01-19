% This function creates an interactive dialogue for the negotiation after
% the third level whereby Zakayo and Nuru are able to interact. Pressing 'enter' key moves to the
% next line to be displayed

function [speech_end] = kanairo_ending

% Loads the background image
background = imread('zakayo_nuru_speech.png');

% Creates a figure with the background image and a dimensio of 1920 by 1080
% at axis 0,0
hfg = figure;
image(background);
set(hfg, 'Position', [0 0 1920 1080])
axis off equal

% Loads the background music
[y,Fs] = audioread('tushangilie_kenya.mp3');
sound(y,Fs)

% This is the keypress callback function that reacts to a key being
% pressed on the keyboard
set(hfg,'KeyPressFcn',@ScreenIsPressed);
speech_end = 0; % end of speech

% Dialogue lines
line{1} = 'Karibu Nuru. I''ve heard about your doings and efforts during the past days';
line{2} = 'Outrunning lions? That''s is surely something!';

line{3} = 'Asante, Rais.I appreciate the opportunity to be here in order to discuss the pressing socio-economic issues.';
line{4} = 'Well if you heard about the lions, then you also definitely heard about my encounter with thugs in the city?';
line{5} = 'That is one of the issues that needs to be addressed.';
line{6} = 'Those thugs stealing from people aren''t doing it for fun!';
line{7} = 'They have no other source of income, hence they resort to stealing from the people to get by.';
line{8} = 'I believe we can somehow come up with jobs for them so that they have something better to do with their life.';

line{9} = 'Kwanza pole sana for having to go through that.';
line{10} = 'Hilo ni wazo zuri la kutoa fursa za kubadilisha maisha ya wale walio potelea njia.';

line{11} = 'Naam, tunaweza pia kuboresha miundombingu ya mbuga ili kuhakikisha usalama wa wanyama na wageni wakati wa utalii.';
line{12} = 'Because trust me, being chased by those lions haikuwa kutaka kwangu. (Laughs)';

line{13} = '(Joins in the laughter)';
line{14} = 'This will be acted upon immediately.';
line{15} = 'For the sake of our fellow citizens and even foreigners.';
line{16} = 'Tutafanya kazi pamoja na wewe ili kuhakikisha haya yote wamefanyika.';
line{17} = '(Extends out his hand to shake Nuru''s hand)';

line{18} = '(Reaches out for Zakayo''s hand and shakes it)';

% Getting the total number of lines and then initializing a counter for the
% current line
long = length(line);
count = 1;

% Position and size of the textboxes that will contain the dialogue text
size_left = [.23 .155 .3 .2];
size_right = [.525 .155 .3 .2];

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
                    if count >= 1 && count <= 2
                        set(textbox_left, 'String', line{count});
                        set(textbox_right, 'String', '');
                    elseif count >= 3 && count <= 8
                        set(textbox_right, 'String', line{count});
                        set(textbox_left, 'String', '');
                    elseif count >= 9 && count <= 10
                        set(textbox_left, 'String', line{count});
                        set(textbox_right, 'String', '');
                    elseif count >= 11 && count <= 12
                        set(textbox_right, 'String', line{count});
                        set(textbox_left, 'String', '');
                    elseif count >= 13 && count <= 17
                        set(textbox_left, 'String', line{count});
                        set(textbox_right, 'String', '');
                    elseif count == 18
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
