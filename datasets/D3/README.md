
This folder defines an indicative structure of sub-folders to read and write data for the benchmarking of a given `D3` dataset.
This structure is aligned with the provided examples and scripts.
Below, a brief description of the data that each sub-folder should contain.

- `stimuli`: The point cloud stimuli, as given by the `D3` dataset.
- `subjective scores`: The subjective scores per stimulus, as given by the `D3` dataset. An example with fictional data is provided.
- `objective scores`: The PointPCA predictors per stimulus of the `D3` dataset, as computed by the `main.m` script. An example with fictional data is provided.
- `results`: The benchmarking results of the `D3` dataset for within- and cross-dataset validation, as computed by the `regression_models.py` script. 

Note that the order of stimuli ratings in subjective and objective data sheets should be the same.
