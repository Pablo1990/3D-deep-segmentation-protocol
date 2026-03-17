from cellpose import io
import numpy as np
from scipy import ndimage

import sys


def calculate_cell_persistence_score(mask_img, min_percentage=85):
  """
  Count the number of cells that are present in a 'min_percentage' of slices.
  Developed by Giulia Paci
  @mask_img: 3D mask image
  @min_percentage: minimum percentage of slices that a cell must be present in to be considered a good cell
  return: number of good cells and number of bad cells
  """
  z_planes = mask_img.shape[0]

  # Minimum of number of slices for a cell to be correct
  target_n_planes = (min_percentage / 100 ) * z_planes
  #print(f'Minimum number of z-planes is: {target_n_planes}')

  # Count the number of good cells
  unique_ids = np.unique(mask_img)
  count_good = 0
  count_bad = 0

  # Loop
  for cell_id in unique_ids:
    if cell_id == 0:
      continue

    # Get the voxels of the current cell
    current_img = mask_img == cell_id

    # Get the position of the voxels
    binary_img_pos = np.where(current_img)

    # Check if they are connected by using connected components
    _, num_objects = ndimage.label(current_img)

    if num_objects > 2:
      count_bad = count_bad + 1
      continue

    # Get only the unique Z position of the voxels
    unique_z_position = np.unique(binary_img_pos[0])

    # Count the number of slices that the cell is present in
    if len(unique_z_position) > target_n_planes:
        count_good = count_good + 1
    else:
        count_bad = count_bad + 1

  return count_good, count_bad


# # Get evaluation of segmentation
# files = io.get_image_files(input_dir, '_cp_masks')
# for file in files:
#   print(f'File name: {file}')
#   mask = io.imread(file.replace('.tif', '_cp_masks.tif'))
#   good_cells, bad_cells = calculate_cell_persistence_score(mask)
#   print(f'Number of good cells: {good_cells} and bad cells: {bad_cells}')

image_id = sys.argv[1]
mask_path = sys.argv[2]

mask = io.imread(mask_path)
good_cells, bad_cells = calculate_cell_persistence_score(mask)

print(f"{image_id} - good cells: {good_cells}, bad cells: {bad_cells}")