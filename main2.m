clc; clear

u='shojaee'; s='orion.fnb.maschinenbau.tu-darmstadt.de'; a='-agent ';  % set a='' if no Pageant/keys
rb='/home/cps/shojaee'; f='main.py'; lf=pwd;
rn=['run_' datestr(now,'yyyymmdd_HHMMss')]; rd=[rb '/' rn];

system(sprintf('plink -batch %s%s@%s "mkdir -p ''%s''"', a,u,s,rd));
system(sprintf('pscp  -batch %s"%s" %s@%s:"%s/"', a, fullfile(lf,'*.py'), u,s,rd));
system(sprintf('plink -batch -t %s%s@%s "bash -lc ''cd \"%s\"; python3 -u %s''"', a,u,s,rd,f));

if ~isfolder(fullfile(lf,rn)), mkdir(fullfile(lf,rn)); end
system(sprintf('pscp -batch %s%s@%s:"%s/*.csv" "%s"', a,u,s,rd,fullfile(lf,rn)));
system(sprintf('pscp -batch %s%s@%s:"%s/*.png" "%s"', a,u,s,rd,fullfile(lf,rn)));
