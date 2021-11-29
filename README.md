
# PointPCA

PointPCA is a full-reference point cloud objective quality metric that relies on statistical features computed from geometric and textural descriptors. The point clouds first pass through point fusion, and correspondences are computed based on the fused geometry. Geometric and textural descriptors are computed for both point clouds, before estimating corresponding statistical features. The latter are compared providing individual quality predictions. A final quality score is obtained as their linear combination using a selected set of weights.

The provided material consists of functions that are called during the execution of the metric, a mat file including the proposed learned weights, and an example of a main.

To compute PointPCA:

  `[q] = pointpca(A, B, cfg)`

with `A` and `B` being two point clouds under comparison and `cfg` a struct that determines the configuration of the metric.

For more details, the reader can refer to [1].


### Conditions of use

If you wish to use any of the provided scripts in your research, we kindly ask you to cite [1].


### References

[1] E. Alexiou, I. Viola and P. Cesar, "[PointPCA: Point Cloud Objective Quality Assessment Using PCA-Based Descriptors](https://arxiv.org/abs/2111.12663)," *submitted to IEEE Transactions on Multimedia*
