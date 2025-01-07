#!/bin/bash

# Define default paths and parameters
DEFAULT_CHANNELS="0"
DEFAULT_PATH_PRETRAINED_MODEL="/home/pablo/train/models/CP_improved_2500"
DEFAULT_PATH_README=""
DEFAULT_LIST_PATH_COVER_IMAGES=""
DEFAULT_MODEL_ID="wing-disc-3d"
DEFAULT_MODEL_ICON=""
DEFAULT_MODEL_VERSION="0.1.0"
DEFAULT_MODEL_NAME="Drosophila wing disc 3D"
DEFAULT_MODEL_DOCUMENTATION="Cyto3 cellpose model re-trained with Drosophila wing disc segmented cells."
DEFAULT_MODEL_AUTHORS='[{"name": "Pablo Vicente-Munuera", "affiliation": "LMCB, University College London, UK", "github_user": "Pablo1990", "orcid": "0000-0001-5402-7637"},{"name": "Giulia Paci", "affiliation": "LMCB, University College London, UK", "github_user": "giuliapaci", "orcid": "0000-0003-0565-4356"}]'
DEFAULT_MODEL_CITE='[{"text": "For more details of the model itself, see the manuscript", "doi": "10.1101/2024.02.19.580954", "url": null}]'
DEFAULT_MODEL_TAGS="cellpose 3d"
DEFAULT_MODEL_LICENSE="MIT"
DEFAULT_MODEL_REPO="https://github.com/Pablo1990/3D-deep-segmentation-protocol"

# Run the Python script with default parameters
python export.py \
    --channels $DEFAULT_CHANNELS \
    --path_pretrained_model "$DEFAULT_PATH_PRETRAINED_MODEL" \
    --path_readme "$DEFAULT_PATH_README" \
    --list_path_cover_images $DEFAULT_LIST_PATH_COVER_IMAGES \
    --model_version "$DEFAULT_MODEL_VERSION" \
    --model_name "$DEFAULT_MODEL_NAME" \
    --model_documentation "$DEFAULT_MODEL_DOCUMENTATION" \
    --model_authors "$DEFAULT_MODEL_AUTHORS" \
    --model_cite "$DEFAULT_MODEL_CITE" \
    --model_tags $DEFAULT_MODEL_TAGS \
    --model_license "$DEFAULT_MODEL_LICENSE" \
    --model_repo "$DEFAULT_MODEL_REPO"

