#!/usr/bin/env python

"""
3D to 2D Image Converter for Cellpose Training
Code by Alvaro Miranda de Larra and Pablo Vicente-Munuera
"""

import sys
import os
import tifffile as tiff

input_dir = sys.argv[1]
output_dir = sys.argv[2]
segmented_input = sys.argv[3].lower() == 'true'

def iterative_image_splicer(input_dir, output_dir, segmented_input=False):

  # Create the output directory if it doesn't exist
  os.makedirs(output_dir, exist_ok=True)

  # Get a list of all .tif files in the input directory
  tif_files = [f for f in os.listdir(input_dir) if f.endswith('.tif')]

  # Iterate over each 3D image
  for tif_file in tif_files:
    if not tif_file.startswith('.'):
      # Load the multi-directory TIFF image
      with tiff.TiffFile(os.path.join(input_dir, tif_file)) as tif:
          image = tif.asarray()

      # Get the shape of the 3D image
      z, y, x = image.shape
      print(image.shape)
      # Generate 2D images along XY, XZ, and YZ coordinates

      for z_coord in range(z):
          xy_image = image[z_coord, :, :]  # XY plane at the current Z coordinate

          # Save the 2D images with appropriate names
          base_name = os.path.splitext(tif_file)[0]
          # Remove '_segmented' from base_name
          base_name = base_name.replace('_segmented', '')
          if segmented_input:
            tiff.imwrite(os.path.join(output_dir, f'{base_name}_XY_Z{z_coord}_masks.tif'), xy_image)
          else:
            tiff.imwrite(os.path.join(output_dir, f'{base_name}_XY_Z{z_coord}.tif'), xy_image)

      for xy_coord in range(x):
          xz_image = image[:, :, xy_coord]  # XZ plane at the current Y coordinate
          yz_image = image[:, xy_coord, :]  # YZ plane at the current X coordinate

          if segmented_input:
            tiff.imwrite(os.path.join(output_dir, f'{base_name}_XZ_Y{xy_coord}_masks.tif'), xz_image)
            tiff.imwrite(os.path.join(output_dir, f'{base_name}_YZ_X{xy_coord}_masks.tif'), yz_image)
          else:
            tiff.imwrite(os.path.join(output_dir, f'{base_name}_XZ_Y{xy_coord}.tif'), xz_image)
            tiff.imwrite(os.path.join(output_dir, f'{base_name}_YZ_X{xy_coord}.tif'), yz_image)

# !rm -rf labelled_data_2D/
# iterative_image_splicer('labelled_data/raw/', 'labelled_data_2D')
# iterative_image_splicer('labelled_data/segmented/', 'labelled_data_2D', segmented_input=True)

iterative_image_splicer(input_dir, output_dir, segmented_input)