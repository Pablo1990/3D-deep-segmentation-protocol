#!/usr/bin/env python

import sys
import napari
from skimage import io

imageID = sys.argv[1]
image_path = sys.argv[2]
masks_path = sys.argv[3]

print(f"Reviewing: {imageID}")

# Load files
image = io.imread(image_path)
masks = io.imread(masks_path)

# Create viewer
# viewer = napari.Viewer(title=f"Image: {imageID}")
# viewer.add_image(image, name='Image', colormap='gray')
# labels_layer = viewer.add_labels(masks, name='Segmentation')

# Run napari
napari.run()

# Save segmented files
io.imsave(output_path, labels_layer.data.astype(masks.dtype))
print(f"Saved: {output_path}")