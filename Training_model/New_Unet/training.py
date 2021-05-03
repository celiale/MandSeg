from model import *
from data import *
from tensorflow.keras.callbacks import TensorBoard

import datetime
import numpy as np
  

path = '../TMJ/TMJ_database/xvalidation/'
train_path = path+'train/'
test_path = path+'test/'
test_image_path = test_path+'scans/'
npy_path = train_path+'npy_files/'
model_path = path+'models/unet_model_1_NP_{epoch}.hdf5'
log_path = path+'logs/'


batch_size=11
nb_epoch=100


train_image_arr = np.load(npy_path+'train_scan.npy')
train_label_arr = np.load(npy_path+'train_label.npy')
test_image_arr  = np.load(npy_path+'test_scan.npy')
test_label_arr  = np.load(npy_path+'test_label.npy')
             
train_image_arr = np.reshape(train_image_arr,train_image_arr.shape + (1,))
train_label_arr = np.reshape(train_label_arr,train_label_arr.shape + (1,))
test_image_arr = np.reshape(test_image_arr,test_image_arr.shape + (1,))
test_label_arr = np.reshape(test_label_arr,test_label_arr.shape + (1,))


model = unet()

model_checkpoint = ModelCheckpoint(model_path, monitor='loss',verbose=1, period=5)
log_dir = log_path+datetime.datetime.now().strftime("%Y_%d_%m-%H:%M:%S")
tensorboard_callback = TensorBoard(log_dir=log_dir,histogram_freq=1)
   
   
model.fit(train_image_arr, train_label_arr, batch_size, nb_epoch, validation_data=(test_image_arr,test_label_arr),verbose=2, shuffle=True, callbacks=[model_checkpoint, tensorboard_callback])
