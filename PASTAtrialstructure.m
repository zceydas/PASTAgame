function [Results,counter]=PASTAtrialstructure(design,counter,Results,audiochannel,mic_image,t,Category,Ex1,Ex2,Ex3,Trialtype)

%EEG event codes:
fixationstart=100;
fixationend=101;
ideacode=102;
lagtime=0.035;
%%%%%%%%%%%%%%%%

Screen('TextSize', design.window, design.fontsize);
Screen('TextFont', design.window, 'Times');
DrawFormattedText(design.window, '+', 'center',...
    design.screenYpixels * 0.55, design.grey);
%Screen('FillRect', design.window, [255 255 255], [100 600 500 1000] )

Screen('Flip', design.window);
WaitSecs(lagtime)
if design.runEEG
    design.sp.sendTrigger(fixationstart)
end
WaitSecs(4+rand);

WaitSecs(lagtime)
if design.runEEG
    design.sp.sendTrigger(fixationend)
end

ideacount=0;
RT=0;
% Draw text in the upper portion of the screen with the default font in red
Screen('TextSize', design.window, design.fontsize);
DrawFormattedText(design.window, Category, 'center',...
    design.screenYpixels * 0.40 , [1 0 0]);


% Draw text in the bottom of the screen in Times in blue
Screen('TextSize', design.window, design.fontsize);
Screen('TextFont', design.window, 'Times');
DrawFormattedText(design.window, Ex1, 'center',...
    design.screenYpixels * 0.55, [0 0 1]);

% Draw text in the bottom of the screen in Times in blue
Screen('TextSize', design.window, design.fontsize);
Screen('TextFont', design.window, 'Times');
DrawFormattedText(design.window, Ex2, 'center',...
    design.screenYpixels * 0.65, [0 0 1]);

% Draw text in the bottom of the screen in Times in blue
Screen('TextSize', design.window, design.fontsize);
Screen('TextFont', design.window, 'Times');
DrawFormattedText(design.window, Ex3, 'center',...
    design.screenYpixels * 0.75, [0 0 1]);

if contains(Trialtype,'Practice')
    Screen('TextSize', design.window, 35);
    Screen('TextFont', design.window, 'Times');
    DrawFormattedText(design.window, '(Once you are done reading, press the space bar)', 'center',...
        design.screenYpixels * 0.90, design.grey);
end

% Flip to the screen
Screen('Flip', design.window); ReadStart=GetSecs; WaitSecs(0.2);
KbStrokeWait; Readit=GetSecs; ReadTime=Readit-ReadStart;
RecordTime=0; Recordall=0;
triggered=0;

while 1

    % idea generation
    Screen('TextSize', design.window, design.fontsize);
    Screen('TextFont', design.window, 'Times');
    DrawFormattedText(design.window, '+', 'center',...
        design.screenYpixels * 0.55, [0 1 0]);
 %   Screen('FillRect', design.window, [255 255 255], [100 600 500 1000] )
    if contains(Trialtype,'Practice')
        Screen('TextSize', design.window, 35);
        Screen('TextFont', design.window, 'Times');
        DrawFormattedText(design.window, '(Now try to come up with a new name when you see this green plus sign.)', 'center',...
            design.screenYpixels * 0.90, design.grey);
    end
    

    Screen('Flip', design.window);
    WaitSecs(lagtime)
    if design.runEEG
        design.sp.sendTrigger(fixationstart)
    end


    %[keyIsDown,TimeStamp,keyCode] = KbCheck;
    [triggered]=AutomaticTrigger(audiochannel,Readit,Recordall,design);

    if  ((GetSecs-Readit) - Recordall) > design.trialdeadline
        if ideacount == 0
            RT=GetSecs-Readit; % idea generation RT since the beginning of the first idea generation screen
        else
            RT=GetSecs-RecordStopped;
        end
        % organize results
        Results{counter,1}=t;
        Results{counter,2}=Category;
        Results{counter,3}=Ex1;
        Results{counter,4}=Ex2;
        Results{counter,5}=Ex3;
        Results{counter,6}=ReadTime;
        Results{counter,7}=RT;
        Results{counter,8}=0;
        Results{counter,9}=Trialtype;
        counter=counter+1; 
        break %        
    end
    
    if triggered
        
        if ideacount == 0
            RT=GetSecs-Readit; % idea generation RT since the beginning of the first idea generation screen
        else
            RT=GetSecs-RecordStopped;
        end
        
        % voice recording
        Screen(design.window,'PutImage',mic_image,design.allRects);
        if contains(Trialtype,'Practice')
            Screen('TextSize', design.window, 35);
            Screen('TextFont', design.window, 'Times');
            DrawFormattedText(design.window, '(Now say the name out loud as we record your voice.)', 'center',...
                design.screenYpixels * 0.90, design.grey);
%             DrawFormattedText(design.window, 'When ready to come up with another new name, press space bar again.)', 'center',...
%                 design.screenYpixels * 0.90, design.grey);
        end
        
        Screen('Flip', design.window); RecordStart=GetSecs;
        ideacount=ideacount+1;
        
        %         PsychPortAudio('Start',audiochannel,1);
        %         % we need to do the reverse of when we played a file
        %         % get the audio OUT of the buffer and into a matrix
        %         % then, save the matrix into a file
        %         WaitSecs(5);
        %         recordedaudio = PsychPortAudio('GetAudioData', audiochannel);
        
        [recordedaudio]=ListenToSilence(audiochannel);
        % (at this point, since we've dumped things out of the buffer, we could
        % record another 10 seconds if we wanted to)
        PsychPortAudio('Stop',audiochannel); % stop the recording channel
        RecordStopped=GetSecs;
        RecordTime=RecordStopped-RecordStart; % recording RT
        Recordall=Recordall+RecordTime;
        
        % right now this is just a matrix in MATLAB.  we need to save it to a file
        % on our hard drive
        if ~isempty(recordedaudio)
            filename = ['subject' num2str(design.subjectId) '_Session' num2str(design.Session) '_' Trialtype '_trial' num2str(t) '_response' num2str(ideacount) '.wav']; % in a real experiment, you'd want to have the filename
            % be based on the current subject & trial
            % no.
            audiowrite(filename,recordedaudio,design.freq);
        end
        
        
        % organize results
        Results{counter,1}=t;
        Results{counter,2}=Category;
        Results{counter,3}=Ex1;
        Results{counter,4}=Ex2;
        Results{counter,5}=Ex3;
        Results{counter,6}=ReadTime;
        Results{counter,7}=RT;
        Results{counter,8}=RecordTime;
        Results{counter,9}=Trialtype;
        counter=counter+1;
    end
    
end






