% set directory
st = dbstack;
namestr = st.name;
directory=fileparts(which([namestr, '.m']));
cd(directory)

trialdeadline=3; % in seconds (for idea generation)

PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
%PsychDebugWindowConfiguration(0,0.5) % for debugging purposes

subjectId=input('What is subject ID?');
Session=input('What is study session? Test(1), ReTest(2): '); % this can be 1 or 2 (test and re-test)

datafileName = ['ID_' num2str(subjectId) '_SessionNo' num2str(Session) '_Data Folder'];
if ~exist(datafileName, 'dir')
    mkdir(datafileName);
end


%Import the options of the excel file
opts=detectImportOptions('PASTAtrials.xlsx');
ConditionList=readtable('PASTAtrials.xlsx',opts, 'ReadVariableNames', true);

rng('default')
rng(subjectId)
order=shuffle([1:30]); % on each session 15 of them will be presented
if Session == 1
    sessionorder=order(1:15);
elseif Session == 2
    sessionorder=order(16:30);
end


mic_image=imread('mic_image.png');
baseRect = [0 0 200 200];


% Get the screen numbers
screens = Screen('Screens');

% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);

% Define black, white and grey
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;

% Open an on screen window and color it grey
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);
allRects(:, 1) = CenterRectOnPointd(baseRect, xCenter, yCenter);
numchannels = 1; % mono sound
% you can CHOOSE your frequency when recording
freq = 44100;
   
% we also open an audio channel when we're doing recording
audiochannel = PsychPortAudio('Open', [], 2, [], freq, numchannels);
% except we set it to 2 instead of 1
% 2 is for recording mode
% 3 is for BOTH

% we need to set aside from space for the sound that we're going to record
PsychPortAudio('GetAudioData', audiochannel, 10);
% this would set aside 10 seconds of recording per trial
% better to error on the side of caution
% if you use MORE than the time you alloted, it starts writing over the
% start of the sound (like an old VHS tape)

Screen('TextSize', window, 30);
PASTAInstructions(window,grey);

Trialtype='Practice'; 
Index = find(contains(ConditionList.TrialType,Trialtype));
Results={}; counter=1;
for t=1:length(Index)
    Category=ConditionList.Category{Index(t)};
    Ex1=ConditionList.Example1{Index(t)};
    Ex2=ConditionList.Example2{Index(t)};
    Ex3=ConditionList.Example3{Index(t)};
    fontsize=70;
    [Results,counter]=PASTAtrialstructure(counter,Results,Session,trialdeadline,subjectId,window,grey,fontsize,screenYpixels,screenXpixels,audiochannel,freq,mic_image,allRects,t,Category,Ex1,Ex2,Ex3,Trialtype);
end
PracticeTable=cell2table(Results,'VariableNames',{'TrialNo' 'Category' 'Example1' 'Example2' 'Example3' 'ReadTime' 'RT' 'Recordtime' 'TaskType'});
writetable(PracticeTable,['PracticeResults',num2str(Session),'_' 'subject',num2str(subjectId),'_',date,'.xlsx']);

Screen('TextSize', window, 30);
DrawFormattedText(window, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
    'Great! You are now done with practice.', ...
    'If you have any questions, ask the researcher now. ', ...
    'Otherwise, press a key to start testing.'), 'center', 'center',grey,[100],[],[],[2]);
Screen('Flip',window); KbStrokeWait;

Trialtype='Test'; Results={}; counter=1;
for t=1:length(sessionorder)

    Category=ConditionList.Category{sessionorder(t)};
    Ex1=ConditionList.Example1{sessionorder(t)};
    Ex2=ConditionList.Example2{sessionorder(t)};
    Ex3=ConditionList.Example3{sessionorder(t)};
    fontsize=70;
    [Results,counter]=PASTAtrialstructure(counter,Results,Session,trialdeadline,subjectId,window,grey,fontsize,screenYpixels,screenXpixels,audiochannel,freq,mic_image,allRects,t,Category,Ex1,Ex2,Ex3,Trialtype);
end
TestTable=cell2table(Results,'VariableNames',{'TrialNo' 'Category' 'Example1' 'Example2' 'Example3' 'ReadTime' 'RT' 'Recordtime' 'TaskType'});
writetable(TestTable,['TestResults',num2str(Session),'_' 'subject',num2str(subjectId),'_',date,'.xlsx']);

PsychPortAudio('Close', audiochannel);

files = dir(['subject' num2str(subjectId) '*.wav']);
for f=1:length(files)
    movefile(fullfile(files(f).folder,files(f).name), datafileName)
end
tablefiles = dir(['*_subject' num2str(subjectId) '*.xlsx']);
for f=1:length(tablefiles)
    movefile(fullfile(tablefiles(f).folder,tablefiles(f).name), datafileName)
end

Screen('TextSize', window, 30);
DrawFormattedText(window, sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s', ...
    'Great! You finished the game!', ...
    'Thank you for your participation!'), 'center', 'center',grey,[100],[],[],[2]);
Screen('Flip',window); KbStrokeWait;

% Clear the screen
sca;