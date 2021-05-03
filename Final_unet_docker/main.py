import os
from model import *
from data import *
from tensorflow.keras.models import load_model

ImagePredict_path = '../Slices'
save_path = '../Slices_segmented'
model_path = 'XV/models/unet_model_XV_5_20.hdf5'

model = unet()
model = load_model(model_path)

testGene = testGenerator(ImagePredict_path)
results = model.predict(testGene,verbose=1)
saveResult(ImagePredict_path,save_path,results)
