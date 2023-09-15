import numpy as np
import math
import pandas as pd
from scipy import stats
import scipy.optimize as optimization
from itertools import combinations
from sklearn.neural_network import MLPRegressor
from sklearn.linear_model import LinearRegression 
from sklearn.neighbors import KNeighborsRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.svm import SVR
import xgboost as xgb



def get_obj_scores(fileIn):
    # Load objective scores
    objective = pd.read_csv(fileIn)
    stim = objective["stimulus"].values.tolist()
    obj = objective.iloc[: , 1:].to_numpy()

    return [obj, stim]


def get_subj_scores(fileIn, dataset):
    Specify hidden references
    if dataset == 'D1':
        lutHiddenRefs = [i1, i2, i3]
    else:
        lutHiddenRefs = []
    # e.g.
    # if dataset == 'M-PCCD':
    #     lutHiddenRefs = [0, 30, 60, 90, 120, 150, 180, 210]
    # else:
    #     lutHiddenRefs = []

    # Load subjective scores
    subjective = pd.read_csv(fileIn).drop(lutHiddenRefs)
    stim = subjective["stimulus"].values.tolist()
    subj = subjective["MOS"].reset_index(drop=True).to_numpy()

    return [subj, stim]


def get_dataset_info(dataset):
    # Get num of contents and num of distortions per dataset
    if dataset == 'D1':
        numContents = c1
        numDistortions = d1
    elif dataset == 'D2':
        numContents = c2
        numDistortions = d2
    elif dataset == 'D3':
        numContents = c3
        numDistortions = d3
    # e.g.
    # if dataset == 'M-PCCD':
    #     numContents = 8
    #     numDistortions = 29
    # elif dataset == 'SJTU':
    #     numContents = 9
    #     numDistortions = 42
    # elif dataset == 'WPC':
    #     numContents = 20
    #     numDistortions = 37

    return [numContents, numDistortions]


def get_data_samples(objective, subjective, partition, numDist):
    # Get indexes of stimuli to be used
    idx = []
    for j in range(len(partition)):
        idx = idx+list(range(partition[j]*numDist, (partition[j]+1)*numDist))

    # Get samples
    y = subjective[idx]
    x = objective[idx][:]
    
    # Remove nan and inf values
    idxNan = np.isnan(x).any(axis=1)
    idxInf = np.isinf(x).any(axis=1)
    x = np.delete(x, idxNan, 0)
    x = np.delete(x, idxInf, 0)
    y = np.delete(y, idxNan, 0)
    y = np.delete(y, idxInf, 0)

    return x, y


def get_partitions(n, ratio):
    # Get k
    k = int(round(n * ratio))

    # Get lists for testing with all combinations of k items selected from the set {0, 1, 2, ..., n}
    partitionTest = list(combinations(range(0, n), k))

    # Get lists of training with remaining items 
    allIndexes = [list(range(0,n))]*len(partitionTest)
    partitionTrain = []
    for i in range(len(partitionTest)):
        partitionTrain.append([x for x in allIndexes[i] if x not in partitionTest[i]])
    
    return [partitionTest, partitionTrain]


def fit_curve(x, y, curve_type='logistic_4params'):
    r'''Fit the scale of predict scores to MOS scores using logistic regression suggested by VQEG.
    The function with 4 params is more commonly used.
    The 5 params function takes from DBCNN:
        - https://github.com/zwx8981/DBCNN/blob/master/dbcnn/tools/verify_performance.m
    '''
    assert curve_type in [
        'logistic_4params', 'logistic_5params'], f'curve type should be in [logistic_4params, logistic_5params], but got {curve_type}.'
    betas_init_4params = [np.max(y), np.min(y), np.mean(x), np.std(x) / 4.]

    def logistic_4params(x, beta1, beta2, beta3, beta4):
        yhat = (beta1 - beta2) / (1 + np.exp(- (x - beta3) / beta4)) + beta2
        return yhat

    betas_init_5params = [10, 0, np.mean(y), 0.1, 0.1]

    def logistic_5params(x, beta1, beta2, beta3, beta4, beta5):
        logistic_part = 0.5 - 1. / (1 + np.exp(beta2 * (x - beta3)))
        yhat = beta1 * logistic_part + beta4 * x + beta5
        return yhat

    if curve_type == 'logistic_4params':
        logistic = logistic_4params
        betas_init = betas_init_4params
    elif curve_type == 'logistic_5params':
        logistic = logistic_5params
        betas_init = betas_init_5params
    betas, _ = optimization.curve_fit(logistic, x, y, p0=betas_init, maxfev=20000)
    yhat = logistic(x, *betas)
    return yhat



if __name__ == '__main__':

    # Set datasets
    DATASETS = ['D1', 'D2', 'D3'] 
    # e.g. 
    # DATASETS = ['M-PCCD', 'SJTU', 'WPC']

    # Set testing ratio
    RATIO = 0.2

    # Set regression models
    REGRESSION_MODELS = [('LinearRegression',LinearRegression()),
                        ('KNN',KNeighborsRegressor()), 
                        ('SVR', SVR()),
                        ('XGBoost', xgb.XGBRegressor(random_state=123)),      
                        ('MLP', MLPRegressor(hidden_layer_sizes=tuple([128] * 3),max_iter=1000,learning_rate_init = 0.005,random_state=123)),
                        ('RandomForest',RandomForestRegressor(random_state=123))]

    # Set paths
    pathInSubj = './datasets/_TBD_/subjective scores/'
    pathInObj = './datasets/_TBD_/objective scores/'
    pathOut = './datasets/_TBD_/results/'  

    for d in range(0, len(DATASETS)):
        print('Dataset:' + DATASETS[d])
        
        # Set order, such as the first to be used for within-dataset and the other two for cross-dataset validation
        datasets = DATASETS.copy()
        train = datasets.pop(d)
        datasets.insert(0, train)

        # Get training dataset info
        [numContents, numDistortions] = get_dataset_info(datasets[0])    

        # Load subjective scores
        fileInSubj = pathInSubj.replace('_TBD_', datasets[0])+'subj.csv'
        [subj, subjStim] = get_subj_scores(fileInSubj, datasets[0])

        # Load objective scores
        fileInObj = pathInObj.replace('_TBD_', datasets[0])+'obj_pointpca_predictors.csv'
        [obj, objStim] = get_obj_scores(fileInObj)

        # Check correspondence between subjective and objective scores
        if subjStim != objStim:
            raise TypeError("The order of stimuli ratings in subjective and objective data sheets should be the same")

        # Get partitions for within-dataset
        [partitionsTest, partitionsTrain] = get_partitions(numContents, RATIO)

        # Initializations
        df = pd.DataFrame(columns=['dataset', 'regModel', 'PLCCavg', 'PLCCstd', 'SROCCavg', 'SROCCstd', 'RMSEavg', 'RMSEstd']) 
        for modelName, model in REGRESSION_MODELS:
            print('Regression Model:' + str(modelName))
            
            PLCC = np.zeros((len(partitionsTrain), 3))
            SROCC = np.zeros((len(partitionsTrain), 3))
            RMSE = np.zeros((len(partitionsTrain), 3))
            for i in range(len(partitionsTrain)):
                print('Fold = ' + str(i+1))

                # -- Within-dataset validation
                # Testing data
                [xTestPrd, yTest] = get_data_samples(obj, subj, partitionsTest[i], numDistortions)

                # Training data
                [xTrainPrd, yTrain] = get_data_samples(obj, subj, partitionsTrain[i], numDistortions)

                # Train model
                model.fit(xTrainPrd, yTrain)

                # Predict quality scores
                xTest = model.predict(xTestPrd)
                
                # Apply logistic fitting
                yTestHat = fit_curve(xTest, yTest, 'logistic_4params')

                # Compute performance indexes
                PLCC[i][0] = stats.pearsonr(yTestHat, yTest)[0]
                SROCC[i][0] = stats.spearmanr(yTestHat, yTest)[0]
                RMSE[i][0] = math.sqrt(np.mean((yTestHat - yTest)**2))

                # -- Cross-dataset validation
                for j in range(len(datasets)-1):
                    # Get testing dataset info
                    [numContentsTest, numDistortionsTest] = get_dataset_info(datasets[j+1])

                    # Load subjective scores
                    subjTest = get_subj_scores(datasets[j+1], pathInSubj)

                    # Load objective scores
                    objTest = get_obj_scores(datasets[j+1], pathInObj)

                    # Testing data
                    [xTestPrd, yTest] = get_data_samples(objTest, subjTest, list(range(0, numContentsTest)), numDistortionsTest)

                    # Fuse predictors to a quality score
                    xTest = model.predict(xTestPrd)
                    
                    # Apply logistic fitting
                    yTestHat = fit_curve(xTest, yTest, 'logistic_4params')

                    # Compute performance indexes
                    PLCC[i][j+1] = stats.pearsonr(yTestHat, yTest)[0]
                    SROCC[i][j+1] = stats.spearmanr(yTestHat, yTest)[0]
                    RMSE[i][j+1] = math.sqrt(np.mean((yTestHat - yTest)**2))

            # Compute average performance indexes across partitions and append in dataframe
            for j in range(len(datasets)):
                idx = datasets.index(DATASETS[j])
                df = pd.concat([df, pd.DataFrame([[datasets[idx], modelName, np.nanmean(PLCC, axis=0)[idx], np.nanstd(PLCC, axis=0)[idx], np.nanmean(SROCC, axis=0)[idx], np.nanstd(SROCC, axis=0)[idx], np.nanmean(RMSE, axis=0)[idx], np.nanstd(RMSE, axis=0)[idx]]], columns=['dataset', 'regModel', 'PLCCavg', 'PLCCstd', 'SROCCavg', 'SROCCstd', 'RMSEavg', 'RMSEstd'])], ignore_index=True)

            # Export dataframe to xlsx
            df.to_excel(pathOut.replace('_TBD_', datasets[0])+'perf.xlsx', index=False)

