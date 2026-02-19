clc;
clear

%% === Settings ===
user   = '????????';  % Use your own username. If you don't have one, ask Michael to create it.
server = 'orion.fnb.maschinenbau.tu-darmstadt.de';

agent  = '-agent ';   % Use this if you use Pageant/SSH keys. If not, set: agent = ''.

localFolder = pwd;    % Local folder to upload (current MATLAB folder)
remoteBase  = '/home/cps/shojaee';   % Change this to your own remote path (e.g., /home/cps/<yourUser>)
entryFile   = 'main.py';            % Script to run on Orion

% Download mode:
% true  -> download everything from the run folder
% false -> download only *.csv and *.png
downloadAll = false;

%% === Minimal run ===
runName     = ['run_' datestr(now,'yyyymmdd_HHMMss')];
remoteRunDir= [remoteBase '/' runName];

system(sprintf('plink -batch %s%s@%s "mkdir -p ''%s''"', agent,user,server,remoteRunDir));
system(sprintf('pscp -batch %s"%s" %s@%s:"%s/"', agent, fullfile(localFolder,'*.py'), user,server,remoteRunDir));
system(sprintf('plink -batch -t %s%s@%s "bash -lc ''cd \"%s\"; python3 -u %s''"', agent,user,server,remoteRunDir,entryFile));

destLocal = fullfile(localFolder, runName); if ~isfolder(destLocal), mkdir(destLocal); end
if downloadAll
    system(sprintf('pscp -batch -r %s%s@%s:"%s" "%s"', agent,user,server,remoteRunDir,localFolder));
else
    system(sprintf('pscp -batch %s%s@%s:"%s/*.csv" "%s"', agent,user,server,remoteRunDir,destLocal));
    system(sprintf('pscp -batch %s%s@%s:"%s/*.png" "%s"', agent,user,server,remoteRunDir,destLocal));
end
