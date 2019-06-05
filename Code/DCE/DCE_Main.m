CodeP='/home/a/Documents/DUSTER_Nii';
cd(CodeP);
DCEInit;
%%
DataP='/home/a/Documents/sample_data/28/';
WorkingP=DataP;
T1MapFN=[WorkingP 'rT1map_brain_28-2.nii'];
DCE4DFN=[WorkingP 'rDCE_brain_28-2.nii'];
B1MapFN=[WorkingP 'rB1_map_28-2.nii']; % leave as '' is not available. Will use uniform 1
B1MapFactor=100;

cd(WorkingP);
%%
TimeBetweenDCEVols=5.45;
TR=3.5;
FA=8;
ReportTitle='Test'; % this is just a title for the report
%%
MinSignalP=0.002;
MinEnhancementR=1.02;
%%
T1Map=loadniidata(T1MapFN);
DCE4D=loadniidata(DCE4DFN);

S=sort(DCE4D(DCE4D(:)>0));
MinSignal=S(floor(numel(S)*MinSignalP));
clear S
%%
TimeBetweenDCEVolsMin=TimeBetweenDCEVols/60;
Min2Timestep=1/TimeBetweenDCEVolsMin;
%%
DCE_getDefaults;
Options=Defaults;
%% Calculating and saving mean volume
MeanVol=mean(DCE4D,4);
MeanFN=[WorkingP 'DCEMean.nii'];
Raw2Nii(MeanVol,MeanFN,'float32',T1MapFN);
%%
MskMinSignal=all(DCE4D>MinSignal,4);
PercentAboveMin=sum(MskMinSignal(:))./numel(MskMinSignal)*100
% figure;montage(MskMinSignal);title('Min signal mask');
%%
BrainMask=MeanVol>1e5;
%% Prepare report log
DCE_ResetReport;
%% Step 6 - Find bolus start, compute baseline
% takes few seconds
DCE_FindBolusStart;
%% Step 6.3 new SPM masking with quick B1
% takes ~1 minute
Force=true;
DCE_SegmentAndMask;
%% save
TimeBetweenDCEVolsFinal=TimeBetweenDCEVols*Options.TimeMultiplier;

save(PrepareFN,'WorkingP','Baseline','BadSlicesF2','nVols','Min2Timestep','BrainMask','BadTimePoints','Msk','DCE4D','TimeBetweenDCEVols','BolusStart','Options');
disp('Saved');
%% CTC (takes several seconds)
CalcForce=true;
Additional_T1_Maps_Time_Stamps=[];
DoN3=false;
DoGlobal=false;
DoDeviations=false;
WhichMean=0;
DCEInfo=struct('RepetitionTime',TR,'FlipAngle',FA);
DCEInfo.RepetitionTime=TR;
DCEInfo.FlipAngle=FA;

DCET1_CTCfN(DCEInfo, Additional_T1_Maps_Time_Stamps, WorkingP,DoN3,DoGlobal,DoDeviations,CalcForce,WhichMean,Options,T1MapFN,B1MapFN,B1MapFactor);
disp('Finished CTC calculation');
%% Finding arteries
UnderSampling=Options.SubSampling;
if(UnderSampling==1)
    USStr='';
else
    USStr=['_' num2str(UnderSampling)];
end
CTCFN=[WorkingP 'AfterCTC' USStr '.mat'];
disp('Loading..');
load(CTCFN);

disp('DCET1_PKf..');
DCET1_PKf;
disp('AIFFinderTry..');
% ROIStrs=get(handles.listboxROI,'String');
% ROIStr=ROIStrs{get(handles.listboxROI,'value')};
ROIStr='Full';
ArtFinder;
%% Run GUI to inspect manually the arterial voxels
RepVoxGUI(WorkingP);
%% initialize automatic estimation of AIF (Takes few seconds)
AIFFinder;
%% Run GUI to inspect manually the AIF
AIFGUI(WorkingP);
%% Calculate parameters for the entire brain (all voxels)
% This takes several minutes!
RelaxFN=[WorkingP 'Relax.mat'];
save(RelaxFN,'GoodSlices','GoodRows','GoodCols');

CTCFN=[WorkingP 'AfterCTC' USStr '.mat'];
disp('Loading..');
load(CTCFN);
disp('DCET1_PKf..');
% Get clustering, bolus time and noise...
DCET1_PKf;
disp('WholeROICompute..');
% Calculate parameters for the entire brain (all voxels)
DCET1_WholeVolCompute;
disp('Finished whole volume compute');
%% Run GUI to inspect manually the AIF
if(isempty(B1MapFN))
    B1=FinalT1*0;
else
    B1=loadniidata(B1MapFN)/B1MapFactor;
end
ExploreDCEResults;
%%
MakeReport
