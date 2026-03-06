#!/usr/bin/env python

!rm -rf test/
!rm -rf train/

# Divide sets into training and set test
from sklearn.model_selection import train_test_split

train_files = natsorted([f for f in glob('labelled_data_2D/*.tif')
                        if '_masks.tif' not in f])
train_files, test_files = train_test_split(train_files, test_size=0.2, random_state=42)

# Save files from train into 'train'
os.makedirs('train', exist_ok=True)
for f in train_files:
    shutil.copy(f, 'train')
    # Get the '_mask' from the file f
    shutil.copy(f.replace('.tif', '_masks.tif'), 'train')

# Save files from test into 'test'
os.makedirs('test', exist_ok=True)
for f in test_files:
    shutil.copy(f, 'test')
    # Get the '_mask' from the file f
    shutil.copy(f.replace('.tif', '_masks.tif'), 'test')