#!/usr/bin/env python

import sys
import os
import numpy as np
import matplotlib.pyplot as plt
from cellpose import io
from natsort import natsorted
from glob import glob

raw_dir = sys.argv[1] if len(sys.argv) > 1 else '.'
mask_dir = sys.argv[2] if len(sys.argv) > 2 else '.'

train_files = natsorted([f for f in glob('labelled_data_2D/*.tif')
                        if '_masks' not in f])
train_seg = natsorted(glob('labelled_data_2D/*_masks.tif'))

num_images_to_show = 5

# Generate 'num_sections' random numbers
random_sections = np.random.randint(0, len(train_files), num_images_to_show)

# Visualize a few training and segmentation images
for k,f in enumerate(random_sections):
    img = io.imread(train_files[f])
    plt.figure(figsize=(10, 5))
    plt.subplot(1, 2, 1)
    plt.imshow(img, cmap='gray')
    plt.title(f"Image - name: {train_files[f]}")

    # Get the corresponding segmentation image
    seg = io.imread(train_seg[f])
    plt.subplot(1, 2, 2)
    plt.imshow(seg, cmap='prism')
    plt.savefig(f'training_visualization_{k}.png', bbox_inches='tight')
    plt.close()

