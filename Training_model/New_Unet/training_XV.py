from model import *
from data import *
from tensorflow.keras.callbacks import TensorBoard

import datetime
import numpy as np
  

path = '../TMJ/TMJ_database/xvalidation/'
XV_path = path+'XV/train/Fold1/'
log_path = path+'logs/'
Nbr_Folds = 10

server_path = '/Volumes/med-kayvan-lab/Projects/TMJ/Data/Processed/Large_FOV_Condyle_Seg/XV/train/Fold1/scans.npy'

batch_size=8
nb_epoch=10

for i in range(Nbr_Folds):
    
    model_num = str(i+1)
    model_path = path+'models/XV/unet_model_XV_'+model_num+'_{epoch}.hdf5'
    # train_image_arr = np.empty(shape=(0,512,512),dtype='float32')
    train_image_arr = np.empty(shape=(0,512,512),dtype='float32')
    train_label_arr = np.empty(shape=(0,512,512),dtype='float32')
    test_image_arr = np.empty(shape=(0,512,512),dtype='float32')
    test_label_arr = np.empty(shape=(0,512,512),dtype='float32')

    for j in range(Nbr_Folds):
        
        fold_num = str(j+1)

        if i == j :
            print('test',fold_num)
            test_image_arr  = np.load(XV_path+'Fold'+fold_num+'/scans.npy')
            test_image_arr = test_image_arr.astype('float32')
            test_label_arr  = np.load(XV_path+'Fold'+fold_num+'/segs.npy')
            test_label_arr = test_label_arr.astype('float32')
        else :
            print('train',fold_num)
            new_train_image_arr  = np.load(XV_path+'Fold'+fold_num+'/scans.npy')
            new_train_image_arr = new_train_image_arr.astype('float32')
            new_train_label_arr  = np.load(XV_path+'Fold'+fold_num+'/segs.npy')
            new_train_label_arr = new_train_label_arr.astype('float32')
            train_image_arr = np.concatenate((train_image_arr, new_train_image_arr), axis=0)
            train_label_arr = np.concatenate((train_label_arr, new_train_label_arr), axis=0)
              
    train_image_arr = np.reshape(train_image_arr,train_image_arr.shape + (1,))
    train_label_arr = np.reshape(train_label_arr,train_label_arr.shape + (1,))
    test_image_arr = np.reshape(test_image_arr,test_image_arr.shape + (1,))
    test_label_arr = np.reshape(test_label_arr,test_label_arr.shape + (1,))

    # model = unet()

    # model_checkpoint = ModelCheckpoint(model_path, monitor='loss',verbose=1, period=5)
    # log_dir = log_path+'XV_'+model_num+'_'+datetime.datetime.now().strftime("%Y_%d_%m-%H:%M:%S")
    # tensorboard_callback = TensorBoard(log_dir=log_dir,histogram_freq=1)

    # model.fit(train_image_arr, train_label_arr, batch_size, nb_epoch, validation_data=(test_image_arr,test_label_arr),verbose=1, shuffle=True, callbacks=[model_checkpoint, tensorboard_callback])

    del(train_image_arr)
    del(train_label_arr)
    del(test_image_arr)
    del(test_label_arr)

