function []=PASTAInstructions(window,fontcolor)

DrawFormattedText(window, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
    'Welcome to the Alternative Names Game.', ...
    'In this game, your task is to find alternative', ...
    'names to various categories.', ...
    '(Press a key to continue reading the instructions.)'), 'center', 'center',fontcolor,[100],[],[],[2]);
Screen('Flip',window); 
KbStrokeWait;

DrawFormattedText(window, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
    'On each trial, you will be presented with one category title on top of the screen', ...
    'and below the category title, there will be three examples of new names for that category.', ...
    'Your task is to come up with new names for that category such as the given examples.', ...
    'Once you are done reading the category title and its examples, press the space bar.', ...
    '(Press a key to continue reading the instructions.)'), 'center', 'center',fontcolor,[100],[],[],[2]);
Screen('Flip',window); 
KbStrokeWait;

DrawFormattedText(window, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
    'When you press the space bar, you will see a + icon in the middle of the screen.', ...
    'When the + is there, come up with one new name for that category. ', ...
    'Once you come up with the new name, press the space bar and say that name outloud.', ...
    'The microphone icon means that we are recording your voice.', ...
    'Once you are done, press the space bar again and repeat these steps until your time ends.', ...
        '(Press a key to continue reading the instructions.)'), 'center', 'center',fontcolor,[100],[],[],[2]);
Screen('Flip',window);
KbStrokeWait;

DrawFormattedText(window, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
    'You have a total of 1 minute to come up with new names for each category', ...
    'There are no right or wrong answers.', ...
    'Try to come up with as many new names as possible. ', ...
    'Now press a key to practice the rules.'), 'center', 'center',fontcolor,[100],[],[],[2]);
Screen('Flip',window);
KbStrokeWait;