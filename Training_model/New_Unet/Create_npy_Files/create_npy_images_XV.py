from tensorflow.keras.preprocessing.image import load_img
from tensorflow.keras.preprocessing.image import img_to_array

import numpy as np
import glob
import os


def adjustData(img,mask=False):
    if(np.max(img) > 1):
        img = img / 255
        
    if(mask):
        if(np.max(img) > 1):
            img = img /255
        img[img > 0.5] = 1
        img[img <= 0.5] = 0
    return (img)


path = '../TMJ/TMJ_database/xvalidation/XV/'
train_path = path+'train/Fold'
test_path = path+'test/'

NbrFolds = 10

for i in range (NbrFolds) :
    
    fold_path = train_path+str(i+1)+'/'
    train_image_path = fold_path+'scans/'
    train_label_path = fold_path+'segs/'

    train_image_arr = glob.glob(os.path.join(train_image_path,'*.png'))
    train_arr = np.zeros((int(len(train_image_arr)), 512, 512))

    cpt=0
    for index,item in enumerate(train_image_arr):
        cpt+=1
        img = load_img(item,color_mode='grayscale')
        img = img_to_array(img)

        img = adjustData(img,mask=False)
        img = np.reshape(img,(512,512))
        img = img.astype('float32')
        train_arr[index,:,:]=img

        if(cpt%500==0):print(cpt, ' images saved')

    np.save(fold_path+'scans',train_arr)
    del(train_arr)



    train_mask_arr = glob.glob(os.path.join(train_label_path,'*.png'))
    maskTrain_arr = np.zeros((int(len(train_mask_arr)), 512, 512))

    cpt=0
    for index,item in enumerate(train_mask_arr):
        cpt+=1
        mask = load_img(item,color_mode='grayscale')
        mask = img_to_array(mask)

        mask = adjustData(mask,mask=True)
        mask = np.reshape(mask,(512,512))
        maskTrain_arr[index,:,:]=mask

        if(cpt%500==0):print(cpt, ' images saved')

    np.save(fold_path+'segs',maskTrain_arr)
    del(maskTrain_arr)


test_image_path = test_path+'scans/'
test_label_path = test_path+'segs/'

test_image_arr = glob.glob(os.path.join(test_image_path,'*.png'))
test_arr = np.zeros((int(len(test_image_arr)), 512, 512))

cpt=0
for index,item in enumerate(test_image_arr):
    cpt+=1
    img = load_img(item,color_mode='grayscale')
    img = img_to_array(img)

    img = adjustData(img,mask=False)
    img = np.reshape(img,(512,512))
    test_arr[index,:,:]=img
    
    if(cpt%500==0):print(cpt, ' images saved')

np.save(test_path+'test_image',test_arr)
del(test_arr)



test_mask_arr = glob.glob(os.path.join(test_label_path,'*.png'))
maskTest_arr = np.zeros((int(len(test_mask_arr)), 512, 512))

cpt=0
for index,item in enumerate(test_mask_arr):
    cpt+=1
    mask = load_img(item,color_mode='grayscale')
    mask = img_to_array(mask)

    mask = adjustData(mask,mask=True)
    mask = np.reshape(mask,(512,512))
    maskTest_arr[index,:,:]=mask
    
    if(cpt%500==0):print(cpt, ' images saved')

np.save(test_path+'test_label',maskTest_arr)
del(maskTest_arr)
