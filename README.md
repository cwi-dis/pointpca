
# PointPCA

PointPCA is a full-reference point cloud objective quality metric that relies on statistical features computed from geometric and textural descriptors. The point clouds first pass through a duplicate point merging step, before computing a correspondence function that identifies matching points between the reference and the point cloud under evalution. Geometric and textural descriptors are then computed, and corresponding statistical features are estimated. The latter are compared to produce predictors of visual quality. A final quality score is obtained by fusing individual quality predictors using a regression method.

The provided material consists of functions for the execution of the metric, and an example of a main. The structure of the code closely follows the metric's architecture, as defined in [1].

To compute PointPCA:

  `[Q] = pointpca(A, B, cfg)`

where `A` is the original point cloud, `B` the distorted point cloud, and `cfg` a custom struct that determines the configuration of the metric. In the output, a table `Q` of quality predictors that correspond to the proposed statistical features of PointPCA, is returned. An indicative example is provided in `main.m`.

A python script, namely `regression_models.py` is included, implementing the training/testing for within- and cross-dataset validation, and showing the settings that were used to test different regression models in [1]. Please note that adjustements are needed in order to run this script.

Finally, in the folder `datasets` an indicative structure of sub-folders to read and write data for the benchmarking of datasets is shown, as well as some example files, all being in alignment with directories and naming conventions used in `main.m` and `regression_models.py`.

For more details, the reader can refer to [1].


### Conditions of use

If you wish to use any of the provided material in your research, we kindly ask you to cite [1].


### References

[1] E. Alexiou, X. Zhou, I. Viola, and P. Cesar, “PointPCA: point cloud objective quality assessment using PCA-based descriptors.” In *EURASIP Journal of Image and Video Processing*, 2024.
