function TrgP=SPM_SegmentWithB1(SrcFN,Force)
% BaseP='C:\STRDCE\John\Database\DCEOut\BeDa_20130617\';
[BaseP, ShortName, Ext]=fileparts(SrcFN);
BaseP=[BaseP filesep];
% BaseP='C:\STRDCE\John\Database\DCEOut\HaMo_20130714\';
% ASegP=[BaseP 'Seg_BaselineNoBadSli2' filesep];
% MeanFN=[BaseP 'DCEMean.nii'];
% FMaskFN=[BaseP 'FBrainMsk.nii'];
A=loadniidata(SrcFN);
% M=loadniidata(FMaskFN)>0;
% M=A>0;
S=A;
GoodSlicesS=1:size(A,3); % find(isfinite(squeeze(gsum(M,1:2))'));
% se=strel('disk',4,8);
H = fspecial('disk',10);
for i=GoodSlicesS
    S(:,:,i)=imfilter(squeeze(A(:,:,i)),H,'replicate');
end
N=median(A(A>0))*(A./S);
% N(~M)=NaN;
N(~isfinite(N))=0;
N=max(0,N);
N=min(1e5,N);

TempFN=[BaseP 'QuickB1Corrected_' ShortName '.nii'];
Raw2Nii(N,TempFN,'float32', SrcFN);
TrgP=SPM_Segment(TempFN,Force,[],false);

% mricronx({TempFN,[TrgP '\c1ForSeg.nii'],[TrgP '\c2ForSeg.nii'],[TrgP '\c3ForSeg.nii']},[0 1 2 3]);
