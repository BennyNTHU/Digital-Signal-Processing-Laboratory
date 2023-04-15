'''
@Modified by Paul Cho; 10th, Nov, 2020

For NTHU DSP Lab 2020 Autumn
'''

import numpy as np
import soundfile as sf
import matplotlib.pyplot as plt
from librosa.filters import mel as librosa_mel_fn
from scipy.fftpack import dct

from Lab9_functions_student import pre_emphasis, STFT, mel2hz, hz2mel, get_filter_banks

filename = './audio.wav'
source_signal, sr = sf.read(filename) #sr:sampling rate
print('Sampling rate={} Hz.'.format(sr))

### hyper parameters
frame_length = 512                    # Frame length(samples)
frame_step = 256                      # Step length(samples)
emphasis_coeff = 0.95                 # pre-emphasis para
num_bands = 12                        # Filter number = band number
num_FFT = frame_length                # FFT freq-quantization
freq_min = 0
freq_max = int(0.5 * sr)
signal_length = len(source_signal)    # Signal length

# number of frames it takes to cover the entirety of the signal
num_frames = 1 + int(np.ceil((1.0 * signal_length - frame_length) / frame_step))

##########################
'''
Part I:
(1) Perform STFT on the source signal to obtain one spectrogram (with the provided STFT() function)
(2) Pre-emphasize the source signal with pre_emphasis()
(3) Perform STFT on the pre-emphasized signal to obtain the second spectrogram
(4) Plot the two spectrograms together to observe the effect of pre-emphasis

hint for plotting:
you can use "plt.subplots()" to plot multiple figures in one.
you can use "axis.pcolor" of matplotlib in visualizing a spectrogram. 
'''

stft = STFT(source_signal, num_frames, num_FFT, frame_step, frame_length, signal_length, verbose=False)
enph_signal = pre_emphasis(source_signal, 0.95)
enph_stft = STFT(enph_signal, num_frames, num_FFT, frame_step, frame_length, signal_length, verbose=False)
plt.matshow(stft)
plt.title('STFT')
plt.matshow(enph_stft)
plt.title('STFT')
plt.title('enph_STFT')


##########################

'''
Head to the import source 'Lab9_functions_student.py' to complete these functions:
mel2hz(), hz2mel(), get_filter_banks()
'''
# get Mel-scaled filter
fbanks = get_filter_banks(num_bands, num_FFT , sr, freq_min, freq_max)

##########################
'''
Part II:
(1) Convolve the pre-emphasized signal with the filter
(2) Convert magnitude to logarithmic scale
(3) Perform Discrete Cosine Transform (dct) as a process of information compression to obtain MFCC
    (already implemented for you, just notice this step is here and skip to the next step)
(4) Plot the filter banks alongside the MFCC
'''
#YOUR CODE STARTS HERE:



# step(3): Discrete Cosine Transform
MFCC = dct(features, norm = 'ortho')[:,:num_bands]
# equivalent to Matlab dct(x)
# The numpy array [:,:] stands for everything from the beginning to end.



#YOUR CODE ENDS HERE;
##########################
