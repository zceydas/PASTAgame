function [Results]=PASTAtrialstructure(trialdeadline,subjectId,window,grey,fontsize,screenYpixels,screenXpixels,audiochannel,freq,mic_image,allRects,t,Category,Ex1,Ex2,Ex3,Trialtype)

ReadStart=GetSecs;
% Draw text in the upper portion of the screen with the default font in red
Screen('TextSize', window, fontsize);
DrawFormattedText(window, Category, 'center',...
    screenYpixels * 0.40 , [1 0 0]);


% Draw text in the bottom of the screen in Times in blue
Screen('TextSize', window, fontsize);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, Ex1, 'center',...
    screenYpixels * 0.55, [0 0 1]);

% Draw text in the bottom of the screen in Times in blue
Screen('TextSize', window, fontsize);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, Ex2, 'center',...
    screenYpixels * 0.65, [0 0 1]);

% Draw text in the bottom of the screen in Times in blue
Screen('TextSize', window, fontsize);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, Ex3, 'center',...
    screenYpixels * 0.75, [0 0 1]);

if contains(Trialtype,'Practice')
    Screen('TextSize', window, 35);
    Screen('TextFont', window, 'Times');
    DrawFormattedText(window, '(Once you are done reading, press the space bar)', 'center',...
        screenYpixels * 0.90, grey);
end

% Flip to the screen
Screen('Flip', window);
KbStrokeWait; ReadTime=GetSecs-ReadStart;
ideacount=0;
RT=[];  begin=GetSecs;
i=1; RecordTime=[]; 
while 1
    % idea generation
    Screen('TextSize', window, fontsize);
    Screen('TextFont', window, 'Times');
    DrawFormattedText(window, '+', 'center',...
        screenYpixels * 0.55, grey);
    
    if contains(Trialtype,'Practice')
        Screen('TextSize', window, 35);
        Screen('TextFont', window, 'Times');
        DrawFormattedText(window, '(Now try to come up with a new name and press the space bar when ready to say it out loud.)', 'center',...
            screenYpixels * 0.90, grey);
    end
    Screen('Flip', window); 
    
    [keyIsDown,TimeStamp,keyCode] = KbCheck;
    if  ((GetSecs-begin) - sum(RecordTime)) > trialdeadline
        break %
    end
    
    if keyIsDown
        generatefinish=GetSecs;
        
        % voice recording
        Screen(window,'PutImage',mic_image,allRects);
        if contains(Trialtype,'Practice')
            Screen('TextSize', window, 35);
            Screen('TextFont', window, 'Times');
            DrawFormattedText(window, '(Now say the name out loud as we record your voice.', 'center',...
                screenYpixels * 0.85, grey);
            DrawFormattedText(window, 'When ready to come up with another new name, press space bar again.)', 'center',...
                screenYpixels * 0.90, grey);
        end
        
        Screen('Flip', window); RecordStart=GetSecs;
        ideacount=ideacount+1;
        
        PsychPortAudio('Start',audiochannel,1);
        % we need to do the reverse of when we played a file
        % get the audio OUT of the buffer and into a matrix
        % then, save the matrix into a file
        KbStrokeWait;
        recordedaudio = PsychPortAudio('GetAudioData', audiochannel);
        % (at this point, since we've dumped things out of the buffer, we could
        % record another 10 seconds if we wanted to)
        PsychPortAudio('Stop',audiochannel); % stop the recording channel
        
        % right now this is just a matrix in MATLAB.  we need to save it to a file
        % on our hard drive
        if ~isempty(recordedaudio)
            filename = ['subject' num2str(subjectId) '_' Trialtype '_trial' num2str(t) '_response' num2str(ideacount) '.wav']; % in a real experiment, you'd want to have the filename
            % be based on the current subject & trial
            % no.
            audiowrite(filename,recordedaudio,freq);
        end
        RT(i)=generatefinish-begin; % idea generation RT since the beginning of the first idea generation screen
        generatestart=[];
        RecordTime(i)=GetSecs-RecordStart; % recording RT
        i=i+1;
    end
    
end

% organize results
Results{1}=t;
Results{2}=Category;
Results{3}=Ex1;
Results{4}=Ex2;
Results{5}=Ex3;
Results{6}=ReadTime;
Results{7}=RT;
Results{8}=RecordTime;
Results{9}=Trialtype;

