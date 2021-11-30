
# PointPCA

PointPCA is a full-reference point cloud objective quality metric that relies on statistical features computed from geometric and textural descriptors. The point clouds first pass through point fusion, and correspondences are computed based on the fused geometry. Geometric and textural descriptors are extracted from both point clouds, before estimating corresponding statistical features. The latter are compared to provide quality predictions. A final quality score is obtained as a weighted linear combination of the individual quality predictions.

The provided material consists of functions for the execution of the metric, a mat file with the proposed learned weights, and an example of a main. The structure of the code closely follows the metric's architecture, as defined in [1].

To compute PointPCA:

  `[Q] = pointpca(A, B, cfg)`

where `A` is the original point cloud, `B` the distorted point cloud, and `cfg` a custom struct that determines the configuration of the metric. In the output, a table `Q` with quality scores of PointPCA and every statistical feature, is returned. An illustrative example of usage is provided in main.

For more details, the reader can refer to [1].


### Conditions of use

If you wish to use any of the provided material in your research, we kindly ask you to cite [1].


### References

[1] E. Alexiou, I. Viola and P. Cesar, "[PointPCA: Point Cloud Objective Quality Assessment Using PCA-Based Descriptors](https://arxiv.org/abs/2111.12663)," *submitted to IEEE Transactions on Multimedia*
