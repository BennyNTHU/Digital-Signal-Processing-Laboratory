#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec  7 22:40:09 2020

@author: wschien
"""

from glob import glob
import os
import librosa
import numpy as np
import pandas as pd
from sklearn.model_selection import KFold

#%%
DataPath = './Datasets'
FeaPath  = './Features/MFCC'

#%% Functions
def MFCC_feat(file):
    '''
    Please put your MFCC() function learned from lab9 here.
    '''
    return np.mean(mfcc, axis=1)

def cross_val(cv, c, train_data, train_target):
    '''
    You can do cross validation here to find the best 'c' for training.
    '''
    pass

#%% Loading training and test data
train_path = sorted(glob(os.path.join(DataPath, 'wav_train', 'train*.wav')))
test_path = sorted(glob(os.path.join(DataPath, 'wav_dev', 'dev*.wav')))

train_data = [MFCC_feat(path) for path in train_path]
test_data = [MFCC_feat(path) for path in test_path]

#%% Reading labels
labels = pd.read_csv(os.path.join(DataPath, 'labels.csv'))
name2label = dict((row['file_name'], row['label']) for idx, row in labels.iterrows())
train_label = [name2label[os.path.basename(path)] for path in train_path]
test_label = [name2label[os.path.basename(path)] for path in test_path]

#%% Training SVM model
X_train = np.vstack(train_data)
y_train = np.array(train_label)
X_test = np.vstack(test_data)
y_test = np.array(test_label)

'''
Train your SVM model here.
'''
y_predict = ?

#%% Saving results into csv
results = pd.DataFrame({'file_name':[os.path.basename(f) for f in devel_files], 'prediction':y_pred})
results.to_csv('results.csv', index=False)
