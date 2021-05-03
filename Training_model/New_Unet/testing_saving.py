from model import *
from data import *
from tensorflow.keras.models import load_model

import datetime
import numpy as np
  

path = '../TMJ/TMJ_database/xvalidation/'
train_path = path+'train/'
test_image_path = path+'test/scans/'
save_path = path+'test/results/'
npy_path = train_path+'npy_files/'
model_path = path+'models/unet_model_2_GL.hdf5'


batch_size=2
test_image_arr  = np.load(npy_path+'test_scan.npy')
test_image_arr = np.reshape(test_image_arr,test_image_arr.shape + (1,))


model = unet()

model = load_model(model_path)
results = model.predict(test_image_arr, batch_size=batch_size,verbose=1)
saveResult(test_image_path, save_path, results)







