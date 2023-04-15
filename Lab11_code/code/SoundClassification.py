#%%
import os
import itertools
import librosa
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from glob import glob
from sklearn.metrics import confusion_matrix, accuracy_score
from sklearn.model_selection import KFold
from sklearn.svm import SVC, LinearSVC
from sklearn.preprocessing import StandardScaler
from plot_cm import plot_confusion_matrix

RANDSEED = 0 # setup random seed
CVFOLD = 5 # number of folds of cross validation
classNames = ['Dog bark', 'Rain', 'Sea waves', 'Baby cry',
              'Clock tick', 'Person sneeze', 'Helicopter', 'Chainsaw',
              'Rooster', 'Fire crackling']
#%%
##### Load data & Calculate features MFCC
labels = pd.read_csv('../data/label.csv')
nameToLabel = dict((row['filename'], row['label']) for idx, row in labels.iterrows())
trainFiles = sorted(glob('../data/Train/*/*.ogg'))
testFiles = sorted(glob('../data/Test/*/*.ogg'))
trainLabel = np.array([nameToLabel[os.path.basename(p)] for p in trainFiles])
testLabel = np.array([nameToLabel[os.path.basename(p)] for p in testFiles])

def feat_extraction(path):
    '''
    Input: path for a single file
    Output: 1D feature vector
    (1) Read file using librosa
    (2) Use librosa to calculate MFCC
    (3) Aggregate the 2D MFCC along time axis to 1D feature vector (ex: mean, std ...)
    '''
	######
	#CODE HERE
	######
    return 

trainFeat = np.vstack([feat_extraction(p) for p in trainFiles])
testFeat = np.vstack([feat_extraction(p) for p in testFiles])

#%%
##### Perform cross-validation
'''
(1) Use KFold to perform cross validation
(2) Normalize training set and testing set
(3) Collect result from each fold
(4) Calculate accuracy and confusion matrix
'''
X = trainFeat
y = trainLabel
Kf = KFold(n_splits=CVFOLD, shuffle=True, random_state=RANDSEED)
sc = StandardScaler()

y_dev_cv = []
y_predict_cv = []
for cvIdx, (trainIdx, devIdx) in enumerate(Kf.split(range(len(X)))):
	######
	#CODE HERE
	######
    
accuracy = accuracy_score(????)
cm = confusion_matrix(?????)

plot_confusion_matrix(cm , classNames)
print('ACC = ',  accuracy)
#%%
##### Predict on test set
'''
(1) Train a model based on your best parameters
(2) Prediction on test set
(3) Calculate accuracy and confusion matrix
'''
X_test = np.vstack(testFeat)
y_test = np.array(testLabel)

######
#CODE HERE
######

accuracy = accuracy_score(?????)
cm = confusion_matrix(?????)

plot_confusion_matrix(cm , classNames)
print('ACC = ',  accuracy)

# %%
