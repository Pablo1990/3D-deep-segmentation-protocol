#!/usr/bin/env python

"""
Code by Giulia Paci and Pablo Vicente-Munuera
"""

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

from cellpose import io
import numpy as np
from scipy import ndimage

# Accepts values from VISUALIZE as arguments
imageID = sys.argv[1]
image_path = sys.argv[2]
masks_path = sys.argv[3]

def visualize_3d_sections(image, masks, segmented=True, num_sections=3):
    """
    Visualizes different random sections of the 3D image and its segmentation.

    Args:
        image: A 3D numpy array representing the image.
        masks: A 3D numpy array representing the cell masks.
        num_sections: The number of random sections to visualize.
    """

    z_dim = image.shape[0]

    # Generate 'num_sections' random numbers
    random_sections = np.random.randint(0, z_dim, num_sections)

    # Sort the random numbers in ascending order
    random_sections = np.sort(random_sections)

    # Create a colormap for all the sections
    cmap = matplotlib.colormaps.get_cmap('prism')

    for id in range(num_sections):
        z_slice = random_sections[id]
        plt.figure(figsize=(10, 5))
        plt.subplot(1, 2, 1)
        plt.imshow(image[z_slice], cmap='gray')
        plt.title(f"Image - Z Slice: {z_slice}")

        plt.subplot(1, 2, 2)
        if segmented:
          plt.imshow(masks[z_slice], cmap)
          plt.title(f"Segmentation - Z Slice: {z_slice}")
        else:
          plt.imshow(masks[z_slice], cmap='gray')
          plt.title(f"Image - Z Slice: {z_slice}")
        # plt.show()

# Get images and masks - ORIGINAL
# files = io.get_image_files(input_dir, '_cp_masks')
# images = [io.imread(f) for f in files]
# masks = [io.imread(f.replace('.tif', '_cp_masks.tif')) for f in files]
# visualize_3d_sections(images[3], masks[3], num_sections=1)

# Get images and masks - UPDATED
image = io.imread(image_path)
masks = io.imread(masks_path)
visualize_3d_sections(image, masks, segmented=True, num_sections=3)

# Download results
output_file = f"{imageID}_visualization.png"
plt.savefig(output_file, dpi=300, bbox_inches='tight')
plt.close('all')