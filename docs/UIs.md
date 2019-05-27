# UIs
# Advanced DCE GUI options

1. SubSampling - Allowing to sub-sample the original data (use lower temporal resolution)
Default: 1. DO NOT CHANGE (used for high resolution data).  3= for HTR change from 2sec to 6sec
2. nVolsToRemoveFromStart - Cut the first volumes of the test (for Siemens the first volumes are distorted).  Default: 0
3. nVolsToRemoveFromEnd - Cut the last volumes of the test (sometimes the last volumes are distorted).  Default: 0
4. SubSecondResolution - Number of sub seconds parts for super resolution ("2" means 1/2 of a second). Default: 2
5. MinFirstBolusStd - The minimum width of the bolus (standard deviation of the Gaussian that represents the first bolus). Default: 2
6. EM_Num_Of_Iterations - Number of iterations for the Expected Minimization algorithm which finds the optimal AIF and parameters. ).
Default: 5. (Currently not used).
7. FMS_TolFun - Function Minimum Search's (Matlab's) parameter. Tolerate Function - minimal improvement for continuing the search.
Default: e^(-11)
8.FMS_MaxFunEvals - Number of possibilities for the F Mean Search at each step to change. Can think of it as in the case of 2-D vector
f(X) ( How many 2-D  points to move to from the current one). Default: 10000
9. FMS_MaxIter - Maximal Number of iterations for FMS algorithm. Default: 10000
10. MaxTDif_ForAIFSearch - The possible shift in time for the AIF of the representing voxels (in seconds). Default: 3
11. MaxTDif_ForWholeVOI - Same as MaxTDif_ForAIFSearch, just when allowing shifting in time for all voxels in VOI (and not just
representing voxels). Default: 6
12. Rep_MaxAroundBolus - Number of clusters around the bolus (for finding representing voxels). Default: 10
13. Rep_RatioToEnd - Number of clusters around the end of the test (for finding representing voxels). Default: 10
14. Rep_nPerSet - Number of total clusters will be MaxAroundBolus *Rep_RatioToEnd. This option will determine how many representing
voxels we will choose from each cluster. Default: 1
15. Mask_Thresh - Set threshold for masking (the general mask of where to work).
For positive values (0-1) uses SPM for masking.
For negative values (0 to -1) uses BET for masking.
The absolute value is passed to the SPM or BET. 
Default: 0.5 (i.e., positive, uses SPM and the thresholds with 0.5).
16. Run_On_All - Run all processing steps. Default: 0 (Currently not used).
17. TimeDelayToMaskVeins - Delay from Bolus peak.  Default: -0.5
18. WeightForAIFMeanVesses - Similarity to the selected AIF Default: 0?
19. MainCoregistration - Choose between 1-realignment, 0-no motion correction and >=2 - coregister to that volume. Default: 1
20. CoregRelaxToMain - Do coregistration between Relaxometry and main. Default: 1
21. MakeNoBATManualArtAnalysis - If "1" and manualArt.nii exists, take the arteries from that file, take their average and make a
regular calculation (we have AIF so we simply use Murase to get the PK parameters) without the possibility to shift BAT. Default: 0
22. MakeBATManualArtAnalysis - If "1" and manualArt.nii exists, take the arteries from that file, calculate the parameters using F Min
Search on the picked arteries (instead of finding representative) and allow the possibility to shift BAT. Default: 0 (Currently not
used). 
23. MakeBATAutoArtAnalysis - The default mode of choosing the arteries automatically. Default: 1
24. Extracted FAs - Correct the flip angles of the scan (we assume there is an error).Default: 1 (Currently not used).
25. IncludingMainInT1 - Default: 1. Include the DCE main (FA 20) in T1 calculation. (DO only if the DCE main acquired with the same
calibration as the DESPOTs)
26. UsingN3T1 - Do inhomogeneity correction.  Default: 1
27. TimeMultiplier - Default: 1. can be used for time correction in Siemens data  (insert the estimated TR: -6 for STR and -2 for HTR).
28. Use_Single_M0 - Enable calculating T1 using a single angel. Default: 0
29. Calc_Gains_Diff - Enable/disable gains calculation made by Gilad. Default: 1
30. ThreshForRefMask. Default: 0.99 - threshold for the segmented WM mask (used as reference for T1 and Vp  cakculation).

# Relaxometry coregistration - Use the list box:
Can coregister to DCEMean ('Mean 4D'), use no coregistration (' No coreg') or coregister to the median angle. Anyway will coregister the
T1 map o DCE mean.

# Force AIF shape (parameters) calculated before:  
InspectedAIFParams.mat

# Add reference files insert NIFTI files named:
RefVp_WM_830.nii
RefT1_WM_830.nii
Manual_BrainMask.nii
Manual_B1.nii [values ~1]

# For artery selection:
InspectedRepVox.nii - Takes exactly what's there, or
ManualArtMask.nii - Looks for arteries only inside that mask.

# Run additional time points from the DCEmain:
Order and names of folders:
St88_Se13_DCE_MAIN_15
St88_Se13_DCE_MAIN_15_UIDChange01
St88_Se13_DCE_MAIN_15_UIDChange04

# Improve B1 (calc T1 map) by excluding lesion area from RefT1_WM_830 map:
WMExMask.nii - Lesion mask mask.
