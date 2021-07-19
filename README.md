# PASTAgame
PASTA naming task adapted from Boot et al, 2017

# Task description
A convergent/divergent creativity task. In this task, participants are asked to come up with as many new names as possible for a certain category title. To the extent participants' newly generated names follow the category examples, their responses are considered convergent. On each trial, the participant has a total of 1 minute to come with new names. Once they come up with a new name, they press the SPACE bar to speak the new name out loud. Their responses are recorded as an audio file. They repeat this process for until trial deadline. For a test-retest design, I divided trial numbers by 2. On each session, participants are presented with 15 categories. 

# Instructions on how to use the code
1) Download the folder on your computer. 
2) Open Matlab (Psychtoolbox needs to be installed). 
3) Use these below commands to clear your workspace:
  close all;
  clear all;
  clear mex;
  clear PsychPortAudio;
4) Drag/drop the PASTAtask.m on the command window. 
5) When prompted, enter the subject ID.
6) When prompted, enter the session number. Enter 1 for the first session (test), Enter 2 for the second session (re-test). 
7) When you are done with the experiment, you will have a subject folder that contains all your results including the recordings. 

## Warning: 
Audio recording function implemented in Psychtoolbox is barely compatible with Matlab 2020b+ on Mac. That means, Matlab might crash if you try to re-run the script. Clear all commands might or might not work, so you might need to exit matlab before re-running this script on the same session. 
